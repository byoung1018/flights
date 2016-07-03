class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :to_city_id, null: false
      t.integer :from_city_id, null: false
      t.timestamps null: false
    end
  end
end
