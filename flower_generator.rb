require 'pry'
require_relative 'web_scraper'
require_relative 'information_validator'

class FlowerGenerator
  def initialize(web_address, location = "")
    @location = location
    @scraper = Scraper.new(web_address)
  end

  def create
    @scraper.get_plant_info
    validator = InformationValidator.new(@scraper.flower_array)
    clean_data = validator.clean_data
    clean_data
  end
end

flower = FlowerGenerator.new("https://coloradoplants.jeffco.us/parksearch.do?name=11&parkname=")
flower.create
