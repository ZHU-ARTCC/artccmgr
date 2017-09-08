class DeviseCreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: :uuid do |t|
      ## User attributes
      t.integer :cid,         null: false
      t.string  :name_first,  null: false
      t.string  :name_last,   null: false
      t.string  :email,       null: false, default: ''

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email,  unique: true
  end
end
