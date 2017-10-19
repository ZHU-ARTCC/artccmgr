class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings, id: :uuid do |t|
      t.integer :number,     null: false
      t.string  :short_name, null: false
      t.string  :long_name,  null: false
    end

    remove_column :users, :rating,    :integer
    add_column    :users, :rating_id, :uuid, null: false
  end
end
