require 'foursquare2'
require 'pry'
require 'pry-nav'
require 'colorize'

client = Foursquare2::Client.new(:client_id => 'ZMSRRVG0L5B52LA5H34ZYE1N4WFUKVAC42SX2C5V3L2D0YZ3', :client_secret => 'CKO4NBZKL32FTGN3NAVML3XAJPYIJDIHMDJPO1OWDTUWYP2H')

venues_data = client.search_venues(:ll => '37.762414, -122.419108', :query => 'restaurant')
venues = venues_data.groups[0].items

venue_details = []

venues.each do |v|
  the_venue = client.venue(v.id)
  venue_details << the_venue
  #Adding all tips to our venues
  v.the_tips = the_venue.tips.groups[0].items
end

# this is sorting by _stats.checkinsCount
venues.sort! do |b, a|
  a.stats.checkinsCount <=> b.stats.checkinsCount
end

## outputting stuff
#venues.each do |v|
#  puts "#{v.name} #{v.stats.checkinsCount}".red
#  v.the_tips.each do |tip|
#    puts "#{tip.text}".blue
#  end
#end

# Magic Search Engine
the_request = 'bacon'
results = []
venues.each do |v|
  v.the_tips.each do |tip|
    if tip.text.match(the_request)
      the_result = Hashie::Mash.new
      the_result.venue = v
      the_result.tip = tip
      
      results << the_result
    end
  end
end

# SORT THE RESULTS
results.sort! do |b, a|
  a.venue.stats.checkinsCount <=> b.venue.stats.checkinsCount
end

# RESULTS OUTPUT

results.each do |r|
  puts "#{r.venue.name} #{r.venue.stats.checkinsCount}".blue
  puts "#{r.tip.text}".green
end

binding.pry