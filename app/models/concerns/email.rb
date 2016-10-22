module Email
  extend ActiveSupport::Concern
  BASE_EMAIL = {
      from: 'flights@scrapyscrapy.com',
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
    Email.new.email(
        subject: "Error: #{message}",
        body: body)
  end

  def email_update(name, state, country)
    email(
        subject: "Updated city: #{name}",
        body: "state: #{state}, country: #{country}")
  end

  def send_flights(flights, email_addresses, messages)
    body = flights.map { |flight| flight.to_s } + messages[:errors] + messages[:updates]
    body = body.unshift("Flights:")

    email_addresses.each do |email_address|

      email(
          to: email_address,
          subject: "New Flights",
          body: body.join("\n\n")
      )
    end

    flights.each { |flight| flight.update_attribute :sent_email, true }
  end


  #expects to:, subject:, body:
  def email(options)
    puts "sending to #{options}"
    Pony.mail(BASE_EMAIL.merge(options))
  end
end