# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admin user
User.create(username: 'elikem', email: 'elikem@gmail.com', password: 'elikem123', password_confirmation: 'elikem123', admin: true).confirm!

# Standard user
User.create(username: 'janet', email: 'janet@example.com', password: 'janet123', password_confirmation: 'janet123').confirm!
