module FlightRetrievalService
    extend ActiveSupport::Concern
    include Email
    URL = 'http://www.theflightdeal.com/category/flight-deals/'
    SF_URL = 'http://www.theflightdeal.com/category/flight-deals/sfo'
    def new_sf_flights
      new_flight_data(CALI_URL)
    end

    def new_flight_data(url)
      postings = Nokogiri::HTML(open(url)).css(".post-title > a")

      still_new = false
      postings.map do |posting|
        url = posting.attribute('href').value
        if Flight.where(url: url).count == 0
          title = posting.attribute("title").value.gsub('Permanent Link: ', '')
          flight = parse_title(title)
          flight[:title] = title
          flight[:url] = url

          flight
        else
          still_new = false
          nil
        end
      end.compact
    end

    end

    def all_new_flights
      new_flight_data(URL).map do |new_flight|
        Flight.normalize_and_save(new_flight)
      end
    end

    def parse_title(title)
      flight = {airlines: []}
      title = title.gsub(' (and vice versa)', '')
      title = title.split('.')[0...-1].join('.')
      colon_parsed = title.split(': ')

      airline_prices = colon_parsed[0].split(' – ')
      flight[:price] = airline_prices[1]
      flight[:airlines] = airline_prices[0].split(' / ')

      cities = colon_parsed[1].split (' – ')
      origin_cities = cities[0]
      cities_states = origin_cities.split(', ')
      $messages[:error] << "Multiple cities/states: #{origin_cities}" if cities_states.count > 2
      flight[:origin_state] = cities_states[1]
      flight[:origin_cities] = cities_states[0].split(' / ')

      destination_location = cities[1].split(', ')
      flight[:destination_city] = destination_location[0]
      flight[:destination_country] = destination_location[1]

      flight
    end

end