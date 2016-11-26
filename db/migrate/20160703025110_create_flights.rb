class CreateFlights < ActiveRecord::Migration[4.2]
  def change
    create_table :flights do |t|
      t.string :url, null: false
      t.string :price, null: false
      t.string :title, null: false
      t.timestamps null: false
    end
  end
end
