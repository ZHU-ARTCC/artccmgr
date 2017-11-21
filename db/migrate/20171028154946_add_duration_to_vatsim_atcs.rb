# frozen_string_literal: true

class AddDurationToVatsimAtcs < ActiveRecord::Migration[5.1]
  def change
    add_column :vatsim_atcs, :duration, :float, precision: 3, scale: 1, null: false
  end
end
