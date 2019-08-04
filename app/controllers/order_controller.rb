class OrderController < ApplicationController


  def create
    
    unless params.keys.include? 'itemId' and params.keys.include? 'email'
      response = { "errors":  "itemId and email are required fields" }
      return render :json => response.to_json, :status => 400
    end

    head 201
  
    
    # @customer = Customer.create(order_params)
    # @customer.lastOrder = 0
    # @customer.lastOrder2 = 0
    # @customer.lastOrder3 = 0c
    # @customer.award = 0
    #
    # if @customer.save
    #   render json: @customer, status: 201
    # else
    #   render json: @customer.errors, status: 400
    # end
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
