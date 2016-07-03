module Email
  extend ActiveSupport::Concern

  def error(message, body)
    email(to: 'byoung1018@gmail.com',
          subject: "Error: #{message}",
          body: body)
  end

  def email_update(name, state, country)
    email(to: 'byoung1018@gmail.com',
          subject: "Updated city: #{name}",
          body: "state: #{state}, country: #{country}")
  end

  def send_new_flights(flights)
    email(to: 'byoung1018@gmail.com',
          subject: "New Flights",
          body: flights.map{|flight| flight.to_s}.join("\n")
  end

  def email(options)
    unless ENV['RAILS_ENV'] == 'development'
      options = EMAIL_BASE.merge(options)
      binding.pry
      Pony.mail(options)
    end
  end
end