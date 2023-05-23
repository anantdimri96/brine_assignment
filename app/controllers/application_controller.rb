# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def render_success(message = 'Success', data=[])
    render json: { success: true, message: message, data: data}
  end

  def render_failure(message = 'Failure', status = :unprocessable_entity)
    render json: { success: false, message: message}, status: status
  end
end
