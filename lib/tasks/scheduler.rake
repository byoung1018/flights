desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Starting Task"
  puts Country.last
  puts "done."
end
