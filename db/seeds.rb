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
