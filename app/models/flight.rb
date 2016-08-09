class Flight < ActiveRecord::Base
  has_many :destinations
  has_many :origins
  has_many :destination_cities, through: :destinations, source: :city
  has_many :origin_cities, through: :origins, source: :city

  include FlightRetrievalService
  include Email

  validates_presence_of :destinations, :origins, :price, :title, :url

  def self.normalize_and_save(raw_flight)
    norm_flight = {}
    norm_flight[:price] = raw_flight[:price]
    norm_flight[:url] = raw_flight[:url]
    norm_flight[:title] = raw_flight[:title]
    norm_flight[:destination_cities] = [City.get(
        raw_flight[:destination_city], raw_flight[:destination_country])]
    norm_flight[:origin_cities] = raw_flight[:origin_cities].map do |city|
      City.get(city, raw_flight[:origin_state])
    end

    flight = self.new(norm_flight)
    $messages[:errors] << "Couldn't save flight: #{flight}" unless flight.save

    flight
  end

  def to_s
    title
  end

end
