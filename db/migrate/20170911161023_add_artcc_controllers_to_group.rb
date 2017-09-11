class AddArtccControllersToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :artcc_controllers, :boolean, default: false
  end
end
