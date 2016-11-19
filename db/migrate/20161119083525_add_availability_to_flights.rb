class AddAvailabilityToFlights < ActiveRecord::Migration
  def change
    add_column :flights, :availability, :string
  end
end
