# frozen_string_literal: true

class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :cryptocurrency

  validates :user_id, presence: true
  validates :cryptocurrency_id, presence: true
  validates :target_price, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[active deleted triggered] }

  scope :active, -> { where(status: Status::ACTIVE) }
  scope :filter_by_status, ->(status) { where(status:) if status.present? }

  after_initialize :set_default_status, if: :new_record?

  module Status
    ACTIVE = 'active'
    DELETED = 'deleted'
    TRIGGERED = 'triggered'
  end

  private

  def set_default_status
    self.status = Status::ACTIVE
  end
end
