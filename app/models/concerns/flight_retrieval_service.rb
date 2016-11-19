module FlightRetrievalService
    extend ActiveSupport::Concern
    include Email
    URL = 'http://www.theflightdeal.com/category/flight-deals/'
    SF_URL = 'http://www.theflightdeal.com/category/flight-deals/sfo'
    def new_sf_flights
      new_flight_data(URL)
    end

    def new_flight_data(url)
      postings = Nokogiri::HTML(open(url)).css(".post-title > a")

      flights = postings.map do |posting|
        url = posting.attribute('href').value
        if Flight.where(url: url).count == 0
          title = posting.attribute("title").value.gsub('Permanent Link: ', '')
          flight = parse_title(title)
          flight[:title] = title
          flight[:url] = url

          flight.merge!(parse_detailed_flight_page(url))
          Flight.normalize_and_save(flight)
        end
      end.compact
    end

    def parse_detailed_flight_page(url)
      page = Nokogiri::HTML(open(url))

      flight = {}
      flight[:availability] = page.css("li:contains('Valid for travel')")
                                  .map{ |element| element.text}
                                  .join("\n")
      flight
    end

    def all_new_flights
      new_flight_data(URL)
    end

    def parse_title(title)
      flight = {airlines: []}
      title.gsub!('. Roundtrip, including all Taxes', '')
      title = title.gsub(' (and vice versa)', '')

      flight[:price] = title[/\d+.?\d+/]

      colon_parsed = title.split(': ')

      airline_prices = colon_parsed[0].split(' – ')

      flight[:airlines] = airline_prices[0].split(' / ')
      cities =  if colon_parsed[1].include?(' to ')
        colon_parsed[1].split (' to ')
      else
        colon_parsed[1].split (' – ')
      end
      origin_cities = cities[0]
      cities_states = origin_cities.split(', ')
      $messages[:errors] << "Multiple cities/states: #{origin_cities}" if cities_states.count > 2
      flight[:origin_state] = cities_states[1]
      flight[:origin_cities] = cities_states[0].split(' / ')

      destination_location = cities[1].split(', ')
      flight[:destination_city] = destination_location[0]
      flight[:destination_country] = destination_location[1]
      flight
    end
end