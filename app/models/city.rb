class City < ActiveRecord::Base
  belongs_to :country
  belongs_to :state
  has_many :flights

end
