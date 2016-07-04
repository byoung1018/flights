desc "This task is called by the Heroku scheduler add-on"
task update_feed: :environment do
  puts "Starting Task"
  puts Country.last
  puts "done."
end

task send_new_flights: :environment do
  $messages = {errors: ["Errors:"], updates: ["Updates:"]}
  f = Flight.new
  new_flights = f.new_flights
  f.send_new_flights(new_flights, $messages) unless new_flights.empty?
end

task test_email: :environment do
  Flight.new.email subject: "test email", body: "line1 \n line2"
end