# frozen_string_literal: true

class AlertEmailWorker
  include Sidekiq::Worker

  def perform
    p '==========AlertEmailWorker==========='
    alerts = Alert.active.includes(:user, :cryptocurrency)
    alerts.each do |alert|
      symbol = alert.cryptocurrency.symbol
      target_price = alert.target_price

      latest_price = CoingeckoService.fetch_latest_price(symbol)

      next unless latest_price && latest_price >= target_price

      # Trigger the email alert for the user
      alert.update(status: Alert::Status::TRIGGERED)
      user = alert.user
      Rails.logger.info('========SENDING EMAIL TO THE USER FOR THE ALERT=========')
      AlertMailer.price_alert_email(user, alert.cryptocurrency, latest_price).deliver_now
    end
  rescue StandardError => e
    # Handle any exceptions that occurred during the request
    Rails.logger.error("Failed AlertEmailWorker::perform error: #{e}")
    # notify sentry or airbrake
    nil
  end
end
