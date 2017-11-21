# frozen_string_literal: true

class AddPrimaryToPositions < ActiveRecord::Migration[5.1]
  def change
    add_column :positions, :primary, :boolean, null: false, default: false
  end
end
