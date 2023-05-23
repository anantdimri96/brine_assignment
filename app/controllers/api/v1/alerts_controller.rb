# frozen_string_literal: true
class Api::V1::AlertsController < ApplicationController
  def create
    @alert = Alert.new(alert_params)

    existing_alert = Alert.find_by(user_id: params[:user_id], cryptocurrency_id: params[:cryptocurrency_id],
                                   status: Alert::Status::ACTIVE, target_price: params[:target_price])
    if existing_alert
      render json: { success: false, error: 'User already has an active alert for this cryptocurrency' },
             status: :unprocessable_entity
      return
    end

    symbol = Cryptocurrency.find_by(id: params[:cryptocurrency_id])&.symbol
    current_price = CoingeckoService.fetch_latest_price(symbol)

    if current_price && @alert.target_price <= current_price
      render json: { success: false, error: 'Target price must be greater than the current price' }, status: :unprocessable_entity
      return
    end

    if @alert.save
      render json: @alert, status: :created
    else
      render json: @alert.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @alert = Alert.where(id: params[:id], status: Alert::Status::ACTIVE).last
    return render json: { error: 'Alert not found' }, status: :not_found unless @alert.present?

    # soft delete
    if @alert.update(status: Alert::Status::DELETED)
      render_success('Alert deleted successfully')
    else
      render_failure('Failed to delete alert')
    end
  end

  def index
    page = params[:page].to_i || 10
    per_page = params[:per_page].to_i || 10
    user_id = params[:user_id]

    # cache_key = "alerts_#{user_id}"
    # alerts = RedisWrapper.get(cache_key)

    # if alerts.nil?
    # If cache is empty, fetch alerts from the database
    alerts = Alert.where(user_id:)
                  .filter_by_status(params[:status])
                  .paginate(page:, per_page:)
    # Store alerts in cache with expiration of 5 minutes
    # byebug
    # RedisWrapper.set(cache_key, alerts, 1.minutes.to_i)
    # end

    render json: {
      alert: AlertSerializer.new(alerts, { meta: { pagination: { page:, per_page: } } }).serializable_hash
    }, status: :ok
  end

  private

  def alert_params
    params.require(:alert).permit(:user_id, :cryptocurrency_id, :target_price)
  end
end
