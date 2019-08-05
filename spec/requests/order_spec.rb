require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  
  $headers = { "ACCEPT" => "application/json"}
  
  $order_uri = 'http://localhost:8080'            
  $customer_uri = 'http://localhost:8081'
  $item_uri = 'http://localhost:8082'
  
  $mockItem = {"id"=>1, "description"=>"Diamond Ring", "price"=> 999.99, "stockQty"=>3} 
  $mockCustomer = {
     'id' => 1,
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
          mock_item_response = double(:code => :success, :body => $mockItem.to_json)
          allow(HTTParty).to receive(:get).with($item_uri + "/items/#{$mockItem['id']}").and_return(mock_item_response)
          
          # make double for customer find
          mock_customer_response = double(:code => :success, :body => $mockCustomer.to_json)
          allow(HTTParty).to receive(:get).with(
            $customer_uri + "/customers/#{$mockCustomer['email']}", any_args).and_return(mock_customer_response)
          
          # make doubles for updates to item and customer services
          allow(HTTParty).to receive(:put).with($item_uri + "/items/order", any_args).and_return(double(:code => 204))
          allow(HTTParty).to receive(:put).with($customer_uri + "/customers/order", any_args).and_return(double(:code => 204))
          
          
          # response = double(:body => newOrder.to_json)
          params = { itemId: $mockItem['id'], email: $mockCustomer['email'] }
          post '/orders', params: params, headers: $headers
          
          expect(response).to have_http_status("201")
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
          get '/orders/3', headers: headers
          expect(response).to have_http_status(:not_found)
          
        end
        
        
      end
    
    # describe "POST /items" do
    #     # it 'post of new item should return item information' do
    #     #   headers = { "CONTENT_TYPE" => "application/json" ,
    #     #               "ACCEPT" => "application/json"}    # Rails 4
    #     #   item_new = {description: '14k Gold Wedding Band', price: 277.99, stockQty: 3} 
    #     #   post '/items',  params: item_new.to_json, headers: headers
    #     #   expect(response).to have_http_status(201)
    #     #   item = JSON.parse(response.body) 
    #     #   expect(item.keys).to include( 
    #     #     'id',
    #     #     'description',
    #     #     'price',
    #     #     'stockQty')
    #     #   expect(item['description']).to eq '14k Gold Wedding Band'
    #     #   expect(item['price']).to eq '277.99'
    #     #   expect(item['stockQty']).to eq 3
          
    #     #   # check that database has been updated
    #     #   itemdb = Item.find(item['id'])
    #     #   expect(itemdb.description).to eq '14k Gold Wedding Band'
    #     #   expect(itemdb.price).to eq 277.99
    #     #   expect(itemdb.stockQty).to eq 3
    #     end 
        
      #   it 'post of new item missing price information should return 400 and error msg' do
      #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
      #   #   #             "ACCEPT" => "application/json"}    # Rails 4
      #   #   # item_new = {description: '14k Gold Wedding Band', stockQty: 3} 
      #   #   # post '/items',  params: item_new.to_json, headers: headers
      #   #   # expect(response).to have_http_status(400)
      #   #   # item = JSON.parse(response.body) 
      #   #   # expect(item.keys).to include('price')
      #   #   # expect(item['price']).to eq ["can't be blank", "is not a number"]
      #   # end 
        
      #   # it 'post of new item missing stock information should return 400 and error msg' do
      #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
      #   #   #             "ACCEPT" => "application/json"}    # Rails 4
      #   #   # item_new = {description: '14k Gold Wedding Band', price: 3.99} 
      #   #   # post '/items',  params: item_new.to_json, headers: headers
      #   #   # expect(response).to have_http_status(400)
      #   #   # item = JSON.parse(response.body) 
      #   #   # expect(item.keys).to include('stockQty')
      #   #   # expect(item['stockQty']).to eq ["can't be blank", "is not a number"]
      #   # end 
        
      #   # it 'post of new item missing description information should return 400 and error msg' do
      #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
      #   #   #             "ACCEPT" => "application/json"}    # Rails 4
      #   #   # item_new = {price: 3.99, stockQty: 5} 
      #   #   # post '/items',  params: item_new.to_json, headers: headers
      #   #   # expect(response).to have_http_status(400)
      #   #   # item = JSON.parse(response.body) 
      #   #   # expect(item.keys).to include('description')
      #   #   # expect(item['description']).to eq ["can't be blank"]
      #   # end 
        
      #   # it 'post of new item should with non numeric stockQty should return 400 and error' do
      #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
      #   #   #             "ACCEPT" => "application/json"}    # Rails 4
      #   #   # item_new = {description: '14k Gold Wedding Band', price: 5.99, stockQty: 'a'} 
      #   #   # post '/items',  params: item_new.to_json, headers: headers
      #   #   # expect(response).to have_http_status(400)
      #   #   # item = JSON.parse(response.body)
      #   #   # expect(item['stockQty']).to eq ["is not a number"]
      #   # end
        
      #   # it 'post of new item should with non numeric price should return 400 and error' do
      #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
      #   #   #             "ACCEPT" => "application/json"}    # Rails 4
      #   #   # item_new = {description: '14k Gold Wedding Band', price: 'a', stockQty: 3} 
      #   #   # post '/items',  params: item_new.to_json, headers: headers
      #   #   # expect(response).to have_http_status(400)
      #   #   # item = JSON.parse(response.body)
      #   #   # expect(item['price']).to eq ["is not a number"]
      #   # end
        
      # end
    
    # describe "PUT /items/" do
    #   # it 'update of a item should return updated item information' do
    #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
    #   #   #             "ACCEPT" => "application/json"}    # Rails 4
    #   #   # item_new = {description: '15k Gold Wedding Band', price: 999.99, stockQty: 5}
    #   #   # post '/items',  params: item_new.to_json, headers: headers
    #   #   # expect(response).to have_http_status(201)
    #   #   # item = JSON.parse(response.body)   
    #   #   # # update the item price and issue http put
    #   #   # item['price']= 799.99
    #   #   # put '/items', params: item.to_json, headers: headers 
    #   #   # expect(response).to have_http_status(200)
    #   #   # item_returned = JSON.parse(response.body)
    #   #   # expect(item_returned['price']).to eq item['price'].to_s
        
    #   #   # # verify db change
    #   #   # itemdb = Item.find(item['id'])
    #   #   # expect(itemdb.price).to eq item['price']
    #   # end 
      
    #   # it 'update of non existant item should return 404' do
    #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
    #   #   #             "ACCEPT" => "application/json"}    # Rails 4
    #   #   # item_update = {id: 3, description: '24k Platinum Band', price: 1999.99, stockQty: 1}
    #   #   # put '/items', params: item_update.to_json, headers: headers
    #   #   # expect(response).to have_http_status(404)
    #   # end
    # end
    
    # describe "PUT /items/order" do
    #   # it 'Place item order for item 1' do
    #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
    #   #   #             "ACCEPT" => "application/json"} 
    #   #   # item = Hash.new
    #   #   # item[:id] = 1
    #   #   # put  '/items/order', params: item.to_json, headers: headers
    #   #   # expect(response).to have_http_status(204)
    #   #   # itemdb = Item.find(1)
    #   #   # expect(itemdb.stockQty).to eq 4
    #   # end
      
    #   # it 'Place item order for non existent item returns 404' do
    #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
    #   #   #             "ACCEPT" => "application/json"} 
    #   #   # item = Hash.new
    #   #   # item[:id] = 3
    #   #   # put  '/items/order', params: item.to_json, headers: headers
    #   #   # expect(response).to have_http_status(404)
    #   #   # begin
    #   #   #   itemdb = Item.find(3)
    #   #   # rescue ActiveRecord::RecordNotFound => e
    #   #   #   itemdb = nil
    #   #   # end
    #   #   # expect(itemdb).to eq nil
    #   # end
      
    #   # it 'Place item order for item that has no stock returns 400' do
    #   #   # Item.create(description: '11k Gold Wedding Band', price: 1277.99, stockQty: 0 )
    #   #   # headers = { "CONTENT_TYPE" => "application/json" ,
    #   #   #             "ACCEPT" => "application/json"} 
    #   #   # item = Hash.new
    #   #   # item[:id] = 2
    #   #   # put  '/items/order', params: item.to_json, headers: headers
    #   #   # expect(response).to have_http_status(400)
    #   # end
    # end

end
