class AddDataToAirports < ActiveRecord::Migration[5.1]
  def change
    add_column :airports, :latitude,  :decimal, precision: 9, scale: 6
    add_column :airports, :longitude, :decimal, precision: 9, scale: 6
    add_column :airports, :elevation, :integer, limit: 2
  end
end
