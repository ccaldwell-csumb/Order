class OrderController < ApplicationController

  include HTTParty
  @headers = { 'Content-Type' => 'application/json',
                'ACCEPT' => 'application/json'}
                
  @order_uri = 'http://localhost:8080'            
  @customer_uri = 'http://localhost:8081'
  @item_uri = 'http://localhost:8082'

  itemCall = double(itemCall)
  
  @item = {"id"=>1, "description"=>"Diamond Ring", "price"=>"999.99", "stockQty"=>3} 

  allow(itemCall).to receive(:itemId).and_return(render json: @item, status: :ok)


  def create
    
    unless params.keys.include? 'itemId' and params.keys.include? 'email'
      response = { "errors":  "itemId and email are required fields" }
      return render :json => response.to_json, :status => 400
    end

    
   @order = Order.create(params)

    item = itemCall(params['itemId'])
    head 201

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
  
        
      
    # if params.keys.include? 'email'
    #   key = 'email'
    # elsif params.keys.include? 'id'
    #   key = 'id'
    # else
    #   render json: { error: 'No key specified' }, status: 404
    # end
    #
    # @customer = Customer.where("#{key} = '#{params[key]}'").first
    #
    # if @customer
    #   render json: @customer, status: 200
    # else
    #   head 404
    # end

  end


  def find

    # if params.keys.include? 'email'
    #   key = 'email'
    # elsif params.keys.include? 'id'
    #   key = 'id'
    # else
    #   render json: { error: 'No key specified' }, status: 404
    # end
    #
    # @customer = Customer.where("#{key} = '#{params[key]}'").first
    #
    # if @customer
    #   render json: @customer, status: 200
    # else
    #   head 404
    # end

  end












  private

  def order_params
    params.permit(:itemId, :email)
  end

  def select_without(columns)
    select(column_names - columns.map(&:to_s))
  end

end
