# frozen_string_literal: true

class CreateAirportCharts < ActiveRecord::Migration[5.1]
  def change
    create_table :airport_charts, id: :uuid do |t|
      t.uuid   :airport_id, null: false
      t.string :category,   null: false
      t.string :name,       null: false
      t.string :url,        null: false
    end
  end
end
