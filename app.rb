require 'bundler'
Bundler.require

require_relative 'lib/scrapper'  # Chemin relatif vers lib/scrapper.rb

scrapper = Scrapper.new
emails = scrapper.perform
scrapper.save_as_json

puts "Scrapping enregistrer en JSON"

# emails.each do |ville, email|
#   puts "#{ville} -- #{email}"
# end