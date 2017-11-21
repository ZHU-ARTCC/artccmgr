# frozen_string_literal: true

class AddCallsignToEventPilots < ActiveRecord::Migration[5.1]
  def change
    add_column :event_pilots, :callsign, :string, null: false
  end
end
