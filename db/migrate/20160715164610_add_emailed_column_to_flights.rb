class AddEmailedColumnToFlights < ActiveRecord::Migration[4.2]
  def change
    add_column :flights, :sent_email, :boolean, default: false, null: false
  end
end
