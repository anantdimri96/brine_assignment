# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a user
user = User.create(name: 'user 1', email: 'user1@example.com')
user2 = User.create(name: 'user 2', email: 'user2@example.com')

# Create cryptocurrencies
bitcoin = Cryptocurrency.create(name: 'Bitcoin', symbol: 'BTC')
ethereum = Cryptocurrency.create(name: 'Ethereum', symbol: 'ETH')

# Create alerts
Alert.create(user:, cryptocurrency: bitcoin, target_price: 33_000, status: 'active')
Alert.create(user:, cryptocurrency: bitcoin, target_price: 32_000, status: 'active')
Alert.create(user:, cryptocurrency: bitcoin, target_price: 31_000, status: 'active')
Alert.create(user:, cryptocurrency: bitcoin, target_price: 30_000, status: 'active')
Alert.create(user:, cryptocurrency: bitcoin, target_price: 34_000, status: 'active')

Alert.create(user: user2, cryptocurrency: ethereum, target_price: 2000, status: 'active')
Alert.create(user: user2, cryptocurrency: ethereum, target_price: 3000, status: 'active')
Alert.create(user: user2, cryptocurrency: ethereum, target_price: 4000, status: 'active')
Alert.create(user: user2, cryptocurrency: ethereum, target_price: 5000, status: 'active')
Alert.create(user: user2, cryptocurrency: ethereum, target_price: 6000, status: 'active')
