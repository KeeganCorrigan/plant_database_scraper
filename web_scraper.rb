require 'HTTParty'
require 'Nokogiri'
require 'pry'

class Scraper
  attr_reader :flower_array

  def initialize(web_address)
    doc = HTTParty.get("#{web_address}")
    @parsed_page = Nokogiri::HTML(doc)
    @flower_array = []
  end

  def get_plant_info
    get_names.map do |name|
      image_info = Nokogiri::HTML(HTTParty.get("https://coloradoplants.jeffco.us/plantdetail.do?sna=#{name}&image=1")).css("#imVrSlide")
      flower_info = Nokogiri::HTML(HTTParty.get("https://coloradoplants.jeffco.us/plantdetail.do?sna=#{name}&image=1")).css("#jeffco_content").each do |name|
        temp_flower_array = []
        temp_flower_array << image_info.attr('src').value if image_info.length > 0
        flower_information = name.css("table").css("tr").text.split("\r")
        flower_information.each_with_index do |data, i|
          temp_flower_array << flower_information[i + 1] if data.include?("Common Name")
          temp_flower_array << flower_information[i + 1] if data.include?("Scientific Name")
          temp_flower_array << flower_information[i + 1] if data.include?("Species Characteristics")
          temp_flower_array << flower_information[i + 1] if data.include?("Season of Bloom")
          temp_flower_array << flower_information[i + 1] if data.include?("Habitat")
          @flower_array << temp_flower_array if temp_flower_array.length >= 7
          break if temp_flower_array.length >= 7
        end
      end
    end
  end

  private

  def get_names
    plant_container.css(".row0").css("td:nth-child(2)").map do |name|
      name.text.tr("\r\n", "").gsub(" ", "%20")
    end.compact
  end

  def plant_container
    @parsed_page.css("#jeffco_content")
  end
end
