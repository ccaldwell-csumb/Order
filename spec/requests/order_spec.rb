require 'rails_helper'

RSpec.describe 'Orders', type: :request do

  # describe 'PUT /customer/order' do
  #   before(:all) do
  #     @email = 'test@test.com'
  #     @firstName = 'John'
  #     @lastName = 'Doe'
  #   end
  #
  #   it 'updates customer with order data and return 204' do
  #
  #     @customer = Customer.create(
  #         email: @email,
  #         firstName: @firstName,
  #         lastName: @lastName
  #     )
  #     expect(@customer.save).to eq(true)
  #
  #     expect(@customer).to_not eq(nil)
  #     expect(@customer.lastOrder).to eq(nil)
  #     expect(@customer.award).to eq(nil)
  #     expect(@customer.id).to_not eq(nil)
  #
  #     price = 123.45
  #
  #     order = {
  #         id: 12345,
  #         itemId: 1,
  #         description: 'An Item',
  #         customerId: @customer.id,
  #         price: price,
  #         award: 0.0,
  #         total: price
  #     }
  #
  #     put '/customers/order', params: order
  #
  #     # expect status code 204
  #     expect(response.status).to eq(204)
  #     expect(response.body).to eq('')
  #   end
  #
  #   it 'returns 400 if error' do
  #     put '/customers/order', params: {}
  #     expect(response.status).to eq(400)
  #     expect(response.body).to eq('')
  #   end
  #
  #   it 'Customer gets award on the 4th buy for 10% of the avg last 3 orders' do
  #
  #     @customer = Customer.create(
  #         email: @email,
  #         firstName: @firstName,
  #         lastName: @lastName
  #     )
  #     expect(@customer.save).to eq(true)
  #
  #     expect(@customer).to_not eq(nil)
  #     expect(@customer.lastOrder).to eq(nil)
  #     expect(@customer.award).to eq(nil)
  #     expect(@customer.id).to_not eq(nil)
  #
  #     price = 123.45
  #
  #     order = {
  #         id: 12345,
  #         itemId: 1,
  #         description: 'An Item',
  #         customerId: @customer.id,
  #         price: price,
  #         award: 0.0,
  #         total: price
  #     }
  #
  #     # First Purchase
  #     put '/customers/order', params: order
  #     expect(response.status).to eq(204)
  #     @customer.reload
  #     expect(@customer.lastOrder).to eq(price)
  #     expect(@customer.lastOrder2).to_not eq(price)
  #     expect(@customer.lastOrder3).to_not eq(price)
  #     expect(@customer.award).to eq(nil)
  #
  #     # 2nd Purchase
  #     put '/customers/order', params: order
  #     expect(response.status).to eq(204)
  #     @customer.reload
  #     expect(@customer.lastOrder).to eq(price)
  #     expect(@customer.lastOrder2).to eq(price)
  #     expect(@customer.lastOrder3).to_not eq(price)
  #     expect(@customer.award).to eq(nil)
  #
  #     # 3nd Purchase
  #     put '/customers/order', params: order
  #     expect(response.status).to eq(204)
  #     @customer.reload
  #     expect(@customer.lastOrder).to eq(price)
  #     expect(@customer.lastOrder2).to eq(price)
  #     expect(@customer.lastOrder3).to eq(price)
  #     expect(@customer.award).to eq(price * 3 / 3 * 0.1)
  #
  #     # 4th Purchase
  #     put '/customers/order', params: order
  #     expect(response.status).to eq(204)
  #     @customer.reload
  #     expect(@customer.lastOrder).to eq(0)
  #     expect(@customer.lastOrder2).to eq(0)
  #     expect(@customer.lastOrder3).to eq(0)
  #     expect(@customer.award).to eq(0)
  #
  #   end
  #
  #
  # end
  #
  #
  # describe 'GET /customers?email=:email' do
  #   before(:all) do
  #     @email = 'test@test.com'
  #     @firstName = 'John'
  #     @lastName = 'Doe'
  #   end
  #
  #   it 'gets the right customer with data for the id and returns 200 status' do
  #     # Add customer to database
  #     @customer = Customer.create(
  #         email: @email,
  #         firstName: @firstName,
  #         lastName: @lastName
  #     )
  #     expect(@customer.save).to eq(true)
  #
  #     # retrieve customer
  #     email = @email
  #     get '/customers/:email', params: { email: email }
  #
  #     # expect status code 200
  #     expect(response.status).to eq(200)
  #     json = JSON.parse(response.body)
  #
  #     # ensure customer is right one with right data
  #     expect(json['email']).to eq(email)
  #     expect(json['id']).to_not eq(nil)
  #     expect(json['id']).to eq(1)
  #     expect(json.keys).to contain_exactly(
  #                              'id',
  #                              'email',
  #                              'lastName',
  #                              'firstName',
  #                              'lastOrder',
  #                              'lastOrder2',
  #                              'lastOrder3',
  #                              'award'
  #                          )
  #
  #   end
  #
  #   it "returns 404 for customer not found" do
  #     # retrieve non-existant customer
  #     get '/customers/:email', params: { email: 'steve@mail.com' }
  #
  #     #expect status code 404 not found
  #     expect(@response.status).to eq(404)
  #   end
  # end
  #
  #
  # describe "GET /customers?id=:id" do
  #   before(:all) do
  #     @email = 'test@test.com'
  #     @firstName = 'John'
  #     @lastName = 'Doe'
  #   end
  #
  #   it 'gets the right customer with data for the id and returns 200 status' do
  #     # Add customer to database
  #     @customer = Customer.create(
  #         email: @email,
  #         firstName: @firstName,
  #         lastName: @lastName
  #     )
  #     expect(@customer.save).to eq(true)
  #
  #     # retrieve customer
  #     id = @customer.id
  #     get "/customers/#{id}"
  #
  #     # expect status code 200
  #     expect(response.status).to eq(200)
  #     json = JSON.parse(response.body)
  #
  #     # ensure customer is right one with right data
  #     expect(json['id']).to eq(id)
  #     expect(json.keys).to contain_exactly(
  #                              'id',
  #                              'email',
  #                              'lastName',
  #                              'firstName',
  #                              'lastOrder',
  #                              'lastOrder2',
  #                              'lastOrder3',
  #                              'award')
  #   end
  #
  #   it "returns 404 for customer not found" do
  #     # retrieve non-existant customer
  #     get '/customers/545454'
  #
  #     #expect status code 404 not found
  #     expect(@response.status).to eq(404)
  #   end
  # end
  #
  #
  # describe "POST /customers" do
  #   before(:all) do
  #     @email = 'test@test.com'
  #     @firstName = 'John'
  #     @lastName = 'Doe'
  #   end
  #
  #   it "can create a new customer with customer data, and 201 status" do
  #
  #     post "/customers", :params => { email: @email, firstName: @firstName, lastName: @lastName }
  #
  #     expect(response.status).to eq(201)
  #     json = JSON.parse(response.body)
  #
  #     expect(json['email']).to eq(@email)
  #     expect(json['firstName']).to eq(@firstName)
  #     expect(json['lastName']).to eq(@lastName)
  #     expect(json.keys).to include('id', 'email', 'firstName', 'lastName', 'lastOrder', 'lastOrder2', 'lastOrder3', 'award')
  #     expect(json['id']).to_not eq(nil)
  #
  #   end
  #
  #   it "returns 400 for missing email with error message" do
  #     post "/customers", :params => {customer: { :firstName => @firstName, :lastName => @lastName} }
  #
  #     expect(response.status).to eq(400)
  #     json = JSON.parse(response.body)
  #
  #     expect(json['email']).to include("can't be blank")
  #
  #   end
  #
  #   it "returns 400 for invalid email with error message" do
  #     post "/customers", :params => {customer: { email: 'NotAnEmail', firstName: @firstName, lastName: @lastName} }
  #
  #     expect(response.status).to eq(400)
  #     json = JSON.parse(response.body)
  #
  #     expect(json['email']).to include("Must be valid email address")
  #
  #   end
  # end

end
