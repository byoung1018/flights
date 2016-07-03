class Flight < ActiveRecord::Base
  belongs_to :to_city, class_name: 'City'
  belongs_to :from_city, class_name: 'City'
  has_one :to_country, through: :to_city, source: :country
  has_one :to_state, through: :to_city, source: :state
  has_one :from_country, through: :from_city, source: :country
  has_one :from_state, through: :from_city, source: :state
end
