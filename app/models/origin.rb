class Origin < ActiveRecord::Base
  belongs_to :flight
  belongs_to :city
end
