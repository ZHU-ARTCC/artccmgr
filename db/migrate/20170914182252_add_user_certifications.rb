# frozen_string_literal: true

class AddUserCertifications < ActiveRecord::Migration[5.0]
  def change
    create_table :user_certifications, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :certification_id, null: false

      t.timestamps
    end
  end
end
