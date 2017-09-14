class AddCertificationToPosition < ActiveRecord::Migration[5.0]
  def change
    add_column :positions, :certification_id, :uuid
  end
end
