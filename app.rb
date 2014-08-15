require 'bundler'
Bundler.require
require_relative './lib/scraping_weather.rb'


get '/' do
  WeatherShow.avg_weather
  @average = WeatherShow.avg_temp
  @rain = WeatherShow.chance_of_rain
  erb :index 
end