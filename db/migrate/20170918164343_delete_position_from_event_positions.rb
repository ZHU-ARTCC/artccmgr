# frozen_string_literal: true

class DeletePositionFromEventPositions < ActiveRecord::Migration[5.1]
  def change
    remove_column :event_positions, :position_id, :uuid
    add_column :event_positions, :callsign, :string
  end
end
