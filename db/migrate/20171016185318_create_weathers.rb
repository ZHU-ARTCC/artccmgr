class CreateWeathers < ActiveRecord::Migration[5.1]
  def change
    create_table :weathers, id: :uuid do |t|
      t.uuid :airport_id,   null: false
      t.string  :rules,      null: false
      t.string  :wind,       null: false
      t.decimal :altimeter,  null: false, precision: 4, scale: 2
      t.string  :metar,      null: false

      t.timestamps
    end
  end
end
