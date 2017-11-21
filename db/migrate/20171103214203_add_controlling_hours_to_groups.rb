# frozen_string_literal: true

class AddControllingHoursToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :min_controlling_hours, :decimal, precision: 3, scale: 1, default: 0
  end
end
