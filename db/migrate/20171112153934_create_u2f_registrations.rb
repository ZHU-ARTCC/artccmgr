class CreateU2fRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :u2f_registrations, id: :uuid do |t|
      t.string  :name
      t.text    :certificate
      t.string  :key_handle
      t.string  :public_key
      t.integer :counter
      t.uuid    :user_id
      t.timestamps
    end
  end
end
