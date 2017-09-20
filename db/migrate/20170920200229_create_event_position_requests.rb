class CreateEventPositionRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :event_position_requests, id: :uuid do |t|
      t.uuid :signup_id, null: false
      t.uuid :position_id, null: false

      t.timestamps
    end
  end
end
