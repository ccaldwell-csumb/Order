class OrderController < ApplicationController

  include HTTParty
  $headers = { 'Content-Type' => 'application/json',
                'ACCEPT' => 'application/json'}
                
  $order_uri = 'http://localhost:8080'            
  $customer_uri = 'http://localhost:8081'
  $item_uri = 'http://localhost:8082'
  headers $headers

  def create
    
    unless params.keys.include? 'itemId' and params.keys.include? 'email'
      response = { "errors":  "itemId and email are required fields" }
      return render :json => response.to_json, :status => 400
    end
    
    # Find item by itemId
    itemId = params[:itemId]
    item_response = HTTParty.get(
      $item_uri + "/items/#{itemId}")
      
      
    unless item_response.code == 200
      response = { "errors": "could not find item with id #{itemId}" }
      return render :json => response, :status => 400
    end
    
    item = JSON.parse(item_response.body)
    
    # check that item is in stock
    unless item['stockQty'] > 0
      response = { "errors": "The item is out of stock." }
      return render :json => response, :status => 400
    end
      
      
    # Find customer by email
    email = params[:email]
    customer_response = HTTParty.get(
      $customer_uri + "/customers?email=#{email}")
      
    unless customer_response.code == 200
      response = { "errors": "could not find customer with email #{email}" }
      return render :json => response, :status => 400
    end
    
    customer = JSON.parse(customer_response.body)
  
    
    # create order
    @order = Order.new
    @order.itemId = item['id']
    @order.description = item['description']
    @order.customerId = customer['id']
    @order.price = item['price']
    @order.award = customer['award']
    @order.total = @order.price - @order.award
    
    unless @order.save
      response = { "errors": "There was an internal error" }
      return render :json => response, :status => 400
    end
    
    # refresh order with id and timestamps
    @order.reload
    
    # send order info to Customer service
    customer_response = HTTParty.put $customer_uri + '/customers/order', 
    :body => {'customerId' => @order.customerId, 'price' => @order.price}
    
    
    unless customer_response.code == 204
      response = { "errors": "There was a problem notifying the customer service about the order." }
      return render :json => response, :status => 400
    end
    
    # send order info to Item service
    item_response = HTTParty.put $item_uri + '/items/order', :body => {'itemId' => @order.itemId}
    
    unless item_response.code == 204
      response = { "errors": "There was a problem notifying the item service about the order." }
      return render :json => response, :status => 400
    end
    
    # Success!
    return render :json => @order, :status => 201
    
  end



  def show
    if params.keys.include? 'id'
      begin
        @order = Order.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        @order = nil
      end
      
      if @order.nil?
        head :not_found
      else
        render json: @order, status: :ok
      end
      
    end
  end


  def find
    
    if params.keys.include? 'customerId'
      
      customerId = params['customerId']
      
    elsif params.keys.include? 'email'
    
      # Find customer by email
      email = params[:email]
      customer_response = HTTParty.get(
      $customer_uri + "/customers?email=#{email}")
      unless customer_response.code == 200
        return render :json => [], :status => 200
      end
    
      customer = JSON.parse(customer_response.body)
      customerId = customer['id']
    end
    
    @orders = Order.where("customerId = '#{customerId}'")
    
    if @orders
      render json: @orders, status: 200
    else
      head 404
    end

  end



  private

  def order_params
    params.permit(:itemId, :email)
  end

  def select_without(columns)
    select(column_names - columns.map(&:to_s))
  end

end
