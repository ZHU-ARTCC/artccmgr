class CreatePositionCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :position_categories, id: :uuid do |t|
      t.string  :name,      null: false
      t.string  :short,     null: false, uniq: true
      t.boolean :can_solo,  default: false
    end

    add_column :positions, :category_id, :uuid
  end
end
