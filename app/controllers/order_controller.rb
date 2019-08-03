class OrderController < ApplicationController


  def create
    # @customer = Customer.create(customer_params)
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
    params.permit(:email, :firstName, :lastName)
  end

  def select_without(columns)
    select(column_names - columns.map(&:to_s))
  end

end
