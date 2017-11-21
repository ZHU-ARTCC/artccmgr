# frozen_string_literal: true

class CreateVatsimAtcs < ActiveRecord::Migration[5.1]
  def change
    create_table :vatsim_atcs, id: :uuid do |t|
      t.uuid      :user_id,     null: false
      t.uuid      :position_id, null: false
      t.string    :callsign,    null: false
      t.decimal   :frequency,   precision: 6, scale: 3, null: false
      t.decimal   :latitude,    precision: 8, scale: 5, null: false
      t.decimal   :longitude,   precision: 8, scale: 5, null: false
      t.string    :server,      null: false
      t.uuid      :rating_id,   null: false
      t.integer   :range,       null: false
      t.datetime  :logon_time,  null: false
      t.datetime  :last_seen
    end
  end
end
