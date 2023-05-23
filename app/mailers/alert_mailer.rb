# frozen_string_literal: true

class AlertMailer < ApplicationMailer
  def price_alert_email(user, cryptocurrency, target_price)
    @user = user
    @cryptocurrency = cryptocurrency
    @target_price = target_price

    Rails.logger.error("====EMAIL SENT TO THE USER: #{@user.id} , target_price: #{target_price}, crypto: #{cryptocurrency.name}=========")

    #UNCOMMENT TO SEND EMAIL
    # mail(to: @user.email, subject: 'Price Alert: Target Price Reached')
  end
end
