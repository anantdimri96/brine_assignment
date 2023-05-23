# frozen_string_literal: true

class AlertJob < ApplicationJob
  def perform
    AlertEmailWorker.perform_async
  end
end
