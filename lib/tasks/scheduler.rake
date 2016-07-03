desc "This ta.sk is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Starting Task"
  puts Country.last
  puts "done."
end

task :send_new_flights => :environment do
  f = Flight.new
  f.send_new_flights(f.new_flights)
end