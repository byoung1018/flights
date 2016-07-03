module FlightRetrievalService
    extend ActiveSupport::Concern
    URL = 'http://www.theflightdeal.com/category/flight-deals/sfo/'
    EMAIL_BASE = {
        via: :smtp,
        via_options: {
            address: 'smtp.sendgrid.net',
            port: '587',
            domain: 'heroku.com',
            user_name: ENV['SENDGRID_USERNAME'],
            password: ENV['SENDGRID_PASSWORD'],
            authentication: :plain,
            enable_starttls_auto: true
        }
    }
    def flights_page
      Nokogiri::HTML(open(URL))
    end

    def email(options)
      Pony.mail(EMAIL_BASE.merge(options))
    end

    def run
      flights = new_flights
      # save new flights
      # email new flights
    end



    def new_flights
      recent_flights.each do |flight|
        # see if flight exists in database based on url
    #   maybe use reject?
      end
    end

    def recent_flights
      postings = flights_page.css(".post-title > a")
      postings.map do |posting|
        title = posting.attribute("title").value
        flight = parse_title(title)
        flight[:url] = posting.attribute('href').value

        flight
      end
    end

    def parse_title(title)
      flight = {airlines: []}
      title = "Permanent Link: Norwegian – $295: Los Angeles / Oakland, California – Stockholm, Sweden. Roundtrip, including all Taxes"
      colon_parsed = title.split(': ')

      airline_prices = colon_parsed[1].split(" - ")
      airline_prices.each do |airline_price|
        if airline_price.include?('$')
          flight[:airlines] << airline_price
        else
          flight[:price] = airline_price
        end
      end

      cities = colon_parsed[2].split (' - ')
      from_cities = cities[0]
      citiest_states = from_cities.split(', ')
      error if citiest_states.count > 2
      flight[:from_state] = citiest_states[1]
      flight[:from_cities] = citiest_states.split(' / ')

      to_location = cities[0].split('.').first.split(', ')
      flight[:to_city] = to_location[0]
      flight[:to_country] = to_location[1]

      flight
    end

    def error
      puts "figure out what to do"
    end

end