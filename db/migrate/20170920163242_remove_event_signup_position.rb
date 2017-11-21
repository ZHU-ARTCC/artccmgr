# frozen_string_literal: true

class RemoveEventSignupPosition < ActiveRecord::Migration[5.1]
  def change
    remove_column :event_signups, :position_id, :uuid
  end
end
