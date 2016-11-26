class CreateDestinations < ActiveRecord::Migration[4.2]
  def change
    create_table :destinations do |t|
      t.integer :city_id, null: false
      t.integer :flight_id, null: false
      t.timestamps null: false
    end
  end
end
