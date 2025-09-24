require 'open-uri'
require 'nokogiri'
require 'json'
require 'google_drive'

class Scrapper
  LISTING_URL = "https://lannuaire.service-public.fr/navigation/ile-de-france/val-d-oise/mairie"

  def initialize
    @emails = {}
  end

  def perform
    listing_page = Nokogiri::HTML(URI.open(LISTING_URL))
    links = listing_page.xpath('//*[@id="main"]/div/div/div/article/div[3]/ul//a')

    links.each do |link|
      href = link['href']
      url = href.start_with?('http') ? href : "https://lannuaire.service-public.fr#{href}"

      town_page = Nokogiri::HTML(URI.open(url))

      ville = town_page.xpath('//h1').text.strip
      email = town_page.xpath('//*[@id="contentContactEmail"]/span[2]/a').text.strip rescue ""

      @emails[ville] = email unless ville.empty?
    end

    @emails
  end

  def save_as_json(file_path = "db/emails.json")
    File.open(file_path, "w") do |f|
        f.write(JSON.pretty_generate(@emails))
end
end
end