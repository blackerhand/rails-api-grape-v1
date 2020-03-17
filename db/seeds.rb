# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u1 = User.find_or_initialize_by email: '1@1.com', nickname: 'user1'
u1.update_attributes password: '123123123'

u2 = User.find_or_initialize_by email: '2@1.com', nickname: 'user2'
u2.update_attributes password: '123123123'

u3 = User.find_or_initialize_by email: '3@1.com', nickname: 'user3'
u3.update_attributes password: '123123123'
