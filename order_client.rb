require 'httparty'


# o	create a new order
# o	retrieve an existing order by orderId, customerId, or customer email
# o	register a new customer
# o	lookup a customer by id or by email
# o	create a new item
# o	lookup an item by item id


class OrderClient
  include HTTParty

  # default_options.update(verify: false) # Turn off SSL
  @headers = { 'Content-Type' => 'application/json',
                'ACCEPT' => 'application/json'}
                
  @order_uri = 'http://localhost:8080'            
  @customer_uri = 'http://localhost:8081'
  @item_uri = 'http://localhost:8082'

  def self.createNewOrder(args)

    body = { email: args[2], firstName: args[1], lastName: args[0] }
    response = HTTParty.post(
      'http://localhost:3000/customers',
      :body => body.to_json,
      :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )

    puts "status code " + response.code.to_s
    puts response.body
  end

  def self.retrieveBy(args)
    body = { email: args[0] }
    response = HTTParty.get(
        'http://localhost:3000/customers/:email',
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end

  def self.registerCustomer(args)
    body = { id: args[0] }
    response = HTTParty.get(
        "http://localhost:3000/customers/#{args[0]}",
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.lookupCustomerBy(args)
    body = { id: args[0] }
    response = HTTParty.get(
        "http://localhost:3000/customers/#{args[0]}",
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.createNewItem(args)
    body = { id: args[0] }
    response = HTTParty.get(
        "http://localhost:3000/customers/#{args[0]}",
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.lookupItemById(args)
    body = { id: args[0] }
    response = HTTParty.get(
        "http://localhost:3000/customers/#{args[0]}",
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
end



command = ''

while command != 'quit'

  puts 'What do you want to do: register, email, id or quit'
  command = gets.chomp!

  case command.downcase
  when 'register'
    puts 'enter lastName, firstName and email for new customer'
    args = gets.chomp!.split(' ')
    OrderClient.registerRequest(args)
  when 'email'
    puts 'enter email'
    args = gets.chomp!.split(' ')
    OrderClient.emailRequest(args)
  when 'id'
    puts 'enter id'
    args = gets.chomp!
    OrderClient.idRequest(args)
  when 'quit'
    return
  end
  puts ''
end


