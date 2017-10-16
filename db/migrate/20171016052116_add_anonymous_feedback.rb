class AddAnonymousFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :feedbacks, :anonymous, :boolean, default: false
    change_column :feedbacks, :cid, :integer, null: true
    change_column :feedbacks, :name, :string, null: true
    change_column :feedbacks, :email, :string, null: true
    change_column :feedbacks, :callsign, :string, null: true
  end
end
