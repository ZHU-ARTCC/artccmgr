class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string    :name, null: false
      t.datetime  :start_time, null: false
      t.datetime  :end_time, null: false
      t.text      :description, null: false

      t.timestamps
    end
  end
end
