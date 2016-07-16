class AddEmailedColumnToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :sent_email, :boolean, default: false, null: false
  end
end
