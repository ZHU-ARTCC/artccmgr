# frozen_string_literal: true

class CreateAirports < ActiveRecord::Migration[5.1]
  def change
    create_table :airports, id: :uuid do |t|
      t.string :icao, limit: 4, null: false, unique: true
      t.string :name, null: false
      t.boolean :show_metar, default: false
    end
  end
end
