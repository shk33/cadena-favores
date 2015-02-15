# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

############################
# Users
############################
User.create!(name:  "Admin",
             email: "admin@admin.com",
             password:              "123456",
             password_confirmation: "123456")


User.create!(name:  "valid",
             email: "valid@valid.com",
             password:              "123456",
             password_confirmation: "123456")


48.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@cadenafavores.org"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

############################
#Balances 
############################
users = User.order(:created_at).take(2)
#Only Admin and Valid have money
users.each do |user|
  user.balance.usable_points = 400
  user.balance.frozen_points = 0
  user.balance.total_points  = 400
  user.balance.save
end

############################
# Tags 
############################
Tag.create!( name:        "Programación",
             description: "Habilidades para programar")

Tag.create!( name:        "Diseño",
             description: "Una hablidad creativa")

Tag.create!( name:        "Domésticas",
             description: "Habilidades para realizar labores domésticas")

Tag.create!( name:        "Educativa",
             description: "Habilidades para la enseñanza")

Tag.create!( name:        "Transporte",
             description: "Trasladarse a distintos lugares")

Tag.create!( name:        "Decorativa",
             description: "Habilidades para la decoración de todo tipo")

############################
# Service Requests
############################
users = User.all

users.each do |user|
  #Every user has 5 ServiceRequests
  # 3 Open services requests and 2 closed
  5.times do |n|
    request = ServiceRequest.new
    request.user = user
    request.tags = [Tag.find(rand(1..6))]

    service = Service.new( title:       Faker::Lorem.sentence(1),
                           description: Faker::Lorem.sentence(5),
                           cost:        0)
    request.service = service
    #First and second services requests are closed
    if n == 1 || n == 2 
      request.open = false 
    end
    request.save
  end
end

############################
# Offers
############################
requests = ServiceRequest.all

requests.each do |request|
  #Every ServiceRequests has 5 offers
  5.times do |n|
    user = User.find rand(1..50)
    offer = Offer.new
    offer.user    = user
    offer.service_request = request
    offer.save
  end
end

############################
# Service Arrangements
############################
requests = ServiceRequest.where open: false

requests.each do |request|
  service    = request.service.dup
  start_date = 7.day.from_now
  end_date   = 14.day.from_now
  client     = request.user
  server     = request.offers[0].user
  sa = ServiceArrangement.create!(
                         service: service,
                         client:  client,
                         server:  server,
                         start_date: start_date,
                         end_date:   end_date)

  #Make half of service arrangements completed
  if sa.id%2 == 0
    sa.completed = true
    sa.save
  end

end
  
############################
# Points Transactions
############################
arrangements = ServiceArrangement.where completed: true

arrangements.each do |arrangement|
  sender   = arrangement.client
  receiver = arrangement.server
  amount   = arrangement.service.cost
  PointsTransaction.create!( service_arrangement: arrangement,
                            sender:   sender,
                            receiver: receiver,
                            amount:   amount,
                            )
end