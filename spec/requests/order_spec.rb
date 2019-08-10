require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  
  $headers = { "ACCEPT" => "application/json"}
  
  $order_uri = 'http://localhost:8080'            
  $customer_uri = 'http://localhost:8081'
  $item_uri = 'http://localhost:8082'
  
  $mockItem = {"id"=>1, "description"=>"Diamond Ring", "price"=> 999.99, "stockQty"=>3} 
  $mockCustomer = {
     'id' => 4,
     'email' => 'ccaldwell@csumb.edu',
     'lastName' => 'caldwell',
     'firstName' => 'chris',
     'lastOrder' => 0.00,
     'lastOrder2' => 0.00,
     'lastOrder3' => 0.00,
     'award' => 0.00
    }
    
  $mockOrder = {
     "itemId" => $mockItem['id'],
     "description" => $mockItem['description'],
     "customerId" => $mockCustomer['id'],
     "price" => $mockItem['price'],
     "award" => $mockCustomer['award'],
     "total" => $mockItem['price'] - $mockCustomer['award']
   }

    describe "POST /orders (create)" do
        it 'returns 201 and the JSON object representing the created order' do
          
          # make double for item find
          mock_item_response = double(:code => 200, :body => $mockItem.to_json)
          allow(HTTParty).to receive(:get).with($item_uri + "/items/#{$mockItem['id']}").and_return(mock_item_response)
          
          # make double for customer find
          mock_customer_response = double(:code => 200, :body => $mockCustomer.to_json)
          allow(HTTParty).to receive(:get).with(
            $customer_uri + "/customers?email=#{$mockCustomer['email']}", any_args).and_return(mock_customer_response)
          
          # make doubles for updates to item and customer services
          allow(HTTParty).to receive(:put).with($item_uri + "/items/order", any_args).and_return(double(:code => 204))
          allow(HTTParty).to receive(:put).with($customer_uri + "/customers/order", any_args).and_return(double(:code => 204))
          
          
          # response = double(:body => newOrder.to_json)
          params = { itemId: $mockItem['id'], email: $mockCustomer['email'] }
          post '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status(201)
          json_response = JSON.parse(response.body)
          
          # verify each field
          $mockOrder.each_key do |key|
            expect(json_response[key]).to eq($mockOrder[key.to_s])
          end
          
        end 
      
        it 'returns a 400 code and error message when itemId is missing' do
          
          params = { email: "dw@csumb.edu" }
          post '/orders', :params => params, :headers => @headers
          
          expect(response).to have_http_status(400)
          expect(response.body).to_not eq('')
          json = JSON.parse(response.body)
          expect(json.keys).to include('errors')
          expect(json['errors']).to_not eq('')
          
        end 
        
        it 'returns a 400 code and error message when email is missing' do
          
          params = { itemId: 123456 }
          post '/orders', :params => params, :headers => @headers
          
          expect(response).to have_http_status(400)
          expect(response.body).to_not eq('')
          json = JSON.parse(response.body)
          expect(json.keys).to include('errors')
          expect(json['errors']).to_not eq('')
          
        end 
        
    end

      before(:each) do 
        #create database record for wedding band
        Order.create(itemId: 1, description: "Diamond Ring", customerId: 3, price: 999.99, award: 0.00, total: 999.99) 
        Order.create(itemId: 2, description: "Billiard Ball", customerId: 4, price: 3.50, award: 0.00, total: 3.50) 
        Order.create(itemId: 3, description: "Mouse-trap", customerId: 4, price: 1.99, award: 1.00, total: 0.99) 
      end
      
      describe "GET /orders/:id" do
        
        it 'get of order by :id should return item information' do
          
          headers = { "CONTENT_TYPE" => "application/json" ,
               "ACCEPT" => "application/json"}    # Rails 4
          
          get '/orders/1', headers: headers
          expect(response).to have_http_status(:ok)
          order = JSON.parse(response.body) 
          expect(order['itemId']).to eq 1
          expect(order['description']).to eq "Diamond Ring"
          expect(order['customerId']).to eq 3
          expect(order['price']).to eq 999.99
          expect(order['award']).to eq 0.00
          expect(order['total']).to eq 999.99
          
        end
        
        it 'get order by invalid :id - should return 404' do
        
          headers = { "CONTENT_TYPE" => "application/json",
                       "ACCEPT" => "application/json"}
          get '/orders/100', headers: headers
          expect(response).to have_http_status(:not_found)
          
        end
        
        
      end
    
    #return an array of orders by customerId
   describe "GET /orders?customerId=nnn" do
        
        it 'get array of orders by customerId status code = 200' do
          
          params = { customerId: $mockCustomer['id'] }
          get '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status("200")
          expect(response.body).to_not eq('')
          
          orders = JSON.parse(response.body)

          expect(orders.count).to eq(2)
          
        end
        
        it 'get empty array if customerId relates to no order code = 200' do
        
          params = { customerId: 123 }
          get '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status("200")
          expect(response.body).to_not eq('')
          orders = JSON.parse(response.body)
          
          expect(orders.count).to eq(0)
          
        end
        
      end
      
      #return an array of orders by email
      describe "GET /orders?email=nn@nnnn" do
      
        it 'get array of orders by email status code = 200' do
          
          # stub out http call to Customer service to get customerId
          mock_customer_response = double(:code => 200, :body => $mockCustomer.to_json)
          allow(HTTParty).to receive(:get).with(
            $customer_uri + "/customers?email=#{$mockCustomer['email']}").and_return(mock_customer_response)
          
          
          params = { email: $mockCustomer['email'] }
          get '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status("200")
          expect(response.body).to_not eq('')
          
          orders = JSON.parse(response.body)

          expect(orders.count).to eq(2)
          
        end
        
        it 'get empty array if email not found, code = 200' do
          
          bad_email = "missing@email.com"
          # stub out http call to Customer service to get customerId
          mock_customer_response = double(:code => 404)
          allow(HTTParty).to receive(:get).with(
            $customer_uri + "/customers?email=#{bad_email}").and_return(mock_customer_response)
          
          
          params = { email: bad_email}
          get '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status("200")
          expect(response.body).to_not eq('')
          
          orders = JSON.parse(response.body)

          expect(orders.count).to eq(0)
          
        end
      
    end

end
