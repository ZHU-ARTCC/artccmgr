# frozen_string_literal: true

class CreateEventPilots < ActiveRecord::Migration[5.0]
  def change
    create_table :event_pilots, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
