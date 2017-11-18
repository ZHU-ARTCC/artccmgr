class GroupRefactor < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :atc,      :boolean, default: false
    add_column :groups, :visiting, :boolean, default: false

    remove_column :groups, :artcc_controllers, :boolean
    remove_column :groups, :visiting_controllers, :boolean
  end
end
