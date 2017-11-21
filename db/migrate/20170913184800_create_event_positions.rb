# frozen_string_literal: true

class CreateEventPositions < ActiveRecord::Migration[5.0]
  def change
    create_table :event_positions, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id
      t.uuid :position_id, null: false

      t.timestamps
    end
  end
end
