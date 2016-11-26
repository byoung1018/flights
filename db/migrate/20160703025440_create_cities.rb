class CreateCities < ActiveRecord::Migration[4.2]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :state
      t.string :country
      t.timestamps null: false
    end
  end
end
