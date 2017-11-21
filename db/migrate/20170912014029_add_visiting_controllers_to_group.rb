# frozen_string_literal: true

class AddVisitingControllersToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :visiting_controllers, :boolean, default: false
  end
end
