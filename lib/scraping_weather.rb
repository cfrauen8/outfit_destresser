require 'nokogiri'
require 'open-uri'


class WeatherScrape

  def initialize

    html = open("http://www.weather.com/weather/hourbyhour/graph/06831")
    @nokogiri = Nokogiri::HTML(html)
    precip_html = open ("http://www.weather.com/weather/today/Greenwich+CT+06831:4:US")
    @nokogiri_precip = Nokogiri::HTML(precip_html)

  end

  def scrape_weather
    weather_hash = {}

    @nokogiri.css("div.wx-timepart").each do |time|
        weather_hash[time.children.children.first.text] = time.children.children.children.children[3].text.gsub("\n","")
    end
    weather_hash
  end 

  def scrape_precip
    @nokogiri_precip.css("div.wx-data")[1].text
  end

end


class WeatherShow

  attr_accessor :hour, :weather, :precip

  def self.avg_weather
    scraping = WeatherScrape.new
    x = 0
    scraping.scrape_weather.each do |time, temp|
      x += 1
      a = x
      a = WeatherShow.new
      a.hour= time
      a.weather= temp
      a.precip = scraping.scrape_precip
    end

  end

  def self.all 
    ObjectSpace.each_object(self).to_a
  end

  def self.avg_temp
    y = 0
    WeatherShow.all.each do |obj|
      y += obj.weather.to_i
    end

    avg_temp = y/WeatherShow.all.size
  end

  def self.chance_of_rain
    if WeatherShow.all.first.precip.delete("%").to_i > 50
      "And you may want to bring a raincoat and some rainboots!!"
    else 
      ""
    end
  end

end