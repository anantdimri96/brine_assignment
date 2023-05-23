# frozen_string_literal: true

class AlertSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :target_price, :status

  def status
    object.status.capitalize
  end
end
