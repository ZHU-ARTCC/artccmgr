class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions, id: :uuid do |t|
      t.string  :name,           null: false
      t.string  :frequency,      null: false, size: 7
      t.string  :callsign,       null: false
      t.string  :identification, null: false
      t.string  :beacon_codes,   size: 9
      t.boolean :major,          null: false, default: false

      t.timestamps
    end
  end
end
