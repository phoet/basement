task :cron => :environment do
  # just trigger page to set cache
  p "triggering site at #{Time.now}"
  HTTParty.get('http://www.phoet.de')
end
