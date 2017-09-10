class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks, id: :uuid do |t|
      t.integer :cid,         null: false
      t.string  :name,        null: false
      t.string  :callsign,    null: false
      t.string  :controller
      t.string  :position,    null: false
      t.string  :comments,    null: false

      t.timestamps
    end
  end
end
