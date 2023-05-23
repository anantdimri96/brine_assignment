# frozen_string_literal: true

class Cryptocurrency < ApplicationRecord
  has_many :alerts

  validates :name, presence: true, uniqueness: true
  validates :symbol, presence: true, uniqueness: true
end

# user = User.create(name: "John Doe", email: "john@example.com")
# cryptocurrency = Cryptocurrency.create(name: "Bitcoin", symbol: "BTC")
# alert = Alert.create(user_id: 1, cryptocurrency_id: cryptocurrency.id, target_price: 33000, status: "active")
