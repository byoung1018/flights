desc "This task is called by the Heroku scheduler add-on"
task update_feed: :environment do
  puts "Starting Task"
  puts Country.last
  puts "done."
end

# rake send_new_sf_flights['email1@gmail.com;email2@hotmail.com']
task :send_new_sf_flights, [:email_addresses] => :environment do |t, args|
  email_addresses = args[:email_addresses].split(';')
  begin
    $messages = {errors: ["Errors:"], updates: ["Updates:"]}
    f = Flight.new
    new_flights = f.new_sf_flights
    if new_flights.empty?
      puts "no flights"
    else
      puts "sending flights"
      f.send_flights(new_flights, email_addresses, $messages) unless new_flights.empty?
    end
  rescue Exception => e
    puts "error"
    puts e.message
    puts e.backtrace
    Email.new.error(e.message, e.backtrace)
  end
end

task test_email: :environment do
  Flight.new.email subject: "test email", body: "line1 \n line2"
end