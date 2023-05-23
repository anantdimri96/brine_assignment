# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def render_success(message = 'Success')
    render json: { success: true, message: }
  end

  def render_failure(message = 'Failure', status = :unprocessable_entity)
    render json: { success: false, message: }, status:
  end
end
