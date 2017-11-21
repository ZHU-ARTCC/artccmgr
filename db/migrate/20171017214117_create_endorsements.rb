# frozen_string_literal: true

class CreateEndorsements < ActiveRecord::Migration[5.1]
  def change
    create_table :endorsements, id: :uuid do |t|
      t.uuid   :certification_id, null: false
      t.uuid   :user_id,          null: false
      t.boolean :solo,            default: false
      t.string :instructor,       null: false
    end

    drop_table :user_certifications do
    end
  end
end
