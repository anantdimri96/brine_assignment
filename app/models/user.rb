# frozen_string_literal: true

class User < ApplicationRecord
  has_many :alerts

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
