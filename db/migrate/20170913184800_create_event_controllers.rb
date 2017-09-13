class CreateEventControllers < ActiveRecord::Migration[5.0]
  def change
    create_table :event_controllers, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :user_id
      t.uuid :position_id, null: false

      t.timestamps
    end
  end
end
