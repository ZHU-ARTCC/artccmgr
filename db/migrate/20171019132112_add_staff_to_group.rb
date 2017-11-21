# frozen_string_literal: true

class AddStaffToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :staff, :boolean, default: false
  end
end
