class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions, id: :uuid do |t|
      t.string :name, null: false, unique: true
    end
  end
end
