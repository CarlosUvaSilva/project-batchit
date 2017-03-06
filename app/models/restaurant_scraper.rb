require "open-uri"
require "json"

class RestaurantScraper
  def self.zomato_restaurants(location, category = "nightlife")
    geo = RestaurantScraper.zomato_location(location)
    url = "https://developers.zomato.com/api/v2.1/search?entity_type=city&lat=#{geo[:lat]}&lon=#{geo[:lon]}&category=#{category}"
    file =  JSON.parse(open(url,
            "Accept" => "application/json",
            "user-key" => ENV["ZOMATO_KEY"]).read)
    result_array = []
    file["restaurants"].each do |restaurant|
      name = restaurant["restaurant"]["name"]
      address = restaurant["restaurant"]["location"]["address"]
      price_range = restaurant["restaurant"]["average_cost_for_two"]/2
      link = restaurant["restaurant"]["url"]
      photo_link = restaurant["restaurant"]["thumb"]
      tag = "<li><strong>Cuisines:</strong> " + restaurant["restaurant"]["cuisines"]+ "</li>"
      tag += "<li><strong>Rating:</strong> " + restaurant["restaurant"]["user_rating"]["rating_text"]+ "</li>"
      result_array << Thing.new(name: name, address: address, price_range: price_range, link: link, tag: tag, thing_type: "restaurant", photo_link: photo_link)
    end
    result_array
  end

  def self.zomato_location(location)
    url =  "https://developers.zomato.com/api/v2.1/locations?query=#{location}"
    file = JSON.parse(open(url,
       "Accept" => "application/json",
       "user-key" => ENV["ZOMATO_KEY"]).read)
    {lat: file["location_suggestions"][0]["latitude"], lon: file["location_suggestions"][0]["longitude"]}
  end

end
