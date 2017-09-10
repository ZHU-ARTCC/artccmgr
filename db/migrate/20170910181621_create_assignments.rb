class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments, id: :uuid do |t|
      t.uuid :group_id, foreign_key: true
      t.uuid :permission_id, foreign_key: true
    end
  end
end
