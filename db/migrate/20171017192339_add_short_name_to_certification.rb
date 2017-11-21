# frozen_string_literal: true

class AddShortNameToCertification < ActiveRecord::Migration[5.1]
  def change
    add_column :certifications, :short_name, :string, limit: 5, null: false
    add_column :certifications, :show_on_roster, :boolean, default: true
    add_column :certifications, :major, :boolean, default: false
  end
end
