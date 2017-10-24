class CreateVatsimDataservers < ActiveRecord::Migration[5.1]
  def change
    create_table :vatsim_dataservers, id: :uuid do |t|
      t.string    :url, null: false
      t.datetime  :created_at
    end
  end
end
