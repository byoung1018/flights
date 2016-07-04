class City < ActiveRecord::Base
  include Email
  STATES = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
            "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
            "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
            "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
            "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska",
            "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York",
            "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
            "Pennsylvania", "Rhode Island"]
  def self.get(name, state_or_country)
    city = where(name: name).last
    if city.nil?
      city = City.new(name: name)
      city.save
      city.reload
    end
    if state_or_country && city.country.nil?
      city.save_state_or_country(state_or_country)
    end

    city
  end

  def save_state_or_country(state_or_country)
    if STATES.include?(state_or_country)
      self.state = state_or_country
      self.country = "US"
    else
      self.country = state_or_country
    end
    $messages[:updates] << "#{self.name}, #{self.state}, #{self.country}"
    self.save

    self.reload
  end
end
