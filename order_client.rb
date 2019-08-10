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

      body = { itemId: args[0], email: args[1]}
      response = HTTParty.post(
        @order_uri + '/orders',
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      )
  
      puts "status code " + response.code.to_s
      puts response.body
  end

  def self.retrieveByCustomerEmail(args)
    body = { email: args }
    response = HTTParty.get(
        @order_uri + '/orders',
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.retrieveByOrderId(args)
    body = { id: args}
    response = HTTParty.get(
        @order_uri + "/orders/#{args}",
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.retrieveByCustomerId(args)
    body = { customerId: args }
    response = HTTParty.get(
        @order_uri + '/orders',
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end

  def self.registerNewCustomer(args)
    body = { email: args[2], firstName: args[1], lastName: args[0]}
    response = HTTParty.post(
        @customer_uri + "/customers",
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.lookupCustomerById(args)
    body = { id: args}
    response = HTTParty.get(
        @customer_uri + "/customers",
        :body => body.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.lookupCustomerByEmail(args)
    response = HTTParty.get(
        @customer_uri + "/customers?email=#{args[0]}",
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.createNewItem(args)
    response = HTTParty.post(
        @item_uri + '/items',
        :body => args.to_json,
        :headers => {'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
  
  def self.lookupItemById(args)
    response = HTTParty.get(
        @item_uri + "/items/#{args}",
        :headers => @headers
    )
    puts "status code " + response.code.to_s
    puts response.body
  end
end



command = ''

while command != 'quit'

  puts 'What do you want to do?'
  puts ''
  puts '0 = (quit)'
  puts '1 = create (order)' 
  puts '2 = (retrieve) order'
  puts '3 = (register) customer'
  puts '4 = find customer by (email)'
  puts '5 = find customer by (id)'
  puts '6 = (create) new item'
  puts '7 = (lookup) item by id'
  puts ''
  print '>'
  
  command = gets.chomp!

  case command.downcase
  when 'order', '1'
    puts 'enter itemID, and email for new order'
    args = gets.chomp!.split(' ')
    OrderClient.createNewOrder(args)
  when 'retrieve', '2'
    puts 'Search orders by: id, customerId or email'
    orderFind = gets.chomp!
    case orderFind.downcase
      when 'id'
        puts 'enter order id'
        args = gets.chomp!
        OrderClient.retrieveByOrderId(args)
      when 'customerid'
        puts 'enter customer id'
        args = gets.chomp!
        OrderClient.retrieveByCustomerId(args)
      when 'email'
        puts 'enter email'
        args = gets.chomp!
        OrderClient.retrieveByCustomerEmail(args)
    end
  when 'register', '3'
    puts 'enter lastName, firstName and email for new customer'
    args = gets.chomp!.split(' ')
    OrderClient.registerNewCustomer(args)
  when 'email', '4'
    puts 'enter email'
    args = gets.chomp!.split(' ')
    OrderClient.lookupCustomerByEmail(args)
  when 'id', '5'
    puts 'enter id'
    args = gets.chomp!
    OrderClient.lookupCustomerById(args)
  when 'create', '6'
    args = Hash.new
    puts 'enter description'
    args[:description] = gets.chomp!
    puts 'enter price'
    args[:price] = gets.chomp!
    puts 'enter stockQty'
    args[:stockQty] = gets.chomp!
    OrderClient.createNewItem(args)
  when 'lookup', '7'
    puts 'enter item id'
    args = gets.chomp!
    OrderClient.lookupItemById(args)
  when 'quit', '0'
    return
  end
  puts ''
end


