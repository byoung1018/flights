module Email
  extend ActiveSupport::Concern
  EMAIL_BASE = {
      to: 'byoung1018@gmail.com',
      via: :smtp,
      via_options: {
          address: 'smtp.sendgrid.net',
          port: '587',
          domain: 'heroku.com',
          user_name: ENV['SENDGRID_USERNAME'],
          password: ENV['SENDGRID_PASSWORD'],
          authentication: :plain,
          enable_starttls_audestination: true
      }
  }
  def error(message, body)
    email(
          subject: "Error: #{message}",
          body: body)
  end

  def email_update(name, state, country)
    email(
          subject: "Updated city: #{name}",
          body: "state: #{state}, country: #{country}")
  end

  def send_new_flights(flights, messages)
    body = flights.map{|flight| flight.to_s}
            + messages[:errors]
            + messages[:updates]

    email(
          subject: "New Flights",
          body: body.join("\n\n")
    )
  end

  def email(options)
    unless ENV['RAILS_ENV'] == 'development'
      options = EMAIL_BASE.merge(options)
      Pony.mail(options)
    end
  end
end