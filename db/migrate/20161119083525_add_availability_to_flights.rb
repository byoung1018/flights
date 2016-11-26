class AddAvailabilityToFlights < ActiveRecord::Migration[4.2]
  def change
    add_column :flights, :availability, :string
  end
end
