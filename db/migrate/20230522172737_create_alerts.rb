# frozen_string_literal: true

class CreateAlerts < ActiveRecord::Migration[6.1]
  def change
    create_table :alerts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :cryptocurrency_id
      t.decimal :target_price
      t.string :status

      t.timestamps
    end
  end
end
