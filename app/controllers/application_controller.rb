require 'json'
require 'open-uri'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private
  # TODO CHANGE IT TO CITIES_CONTROLLER!!
  def airbnb_scraper(limit)
    city = City.find(params[:id])
    # Create AIRBNB URL with city name and group size defined when you create a project
    url = "https://api.airbnb.com/v2/search_results?client_id=3092nxybyb0otqw18e8nh5nty&location=#{city.name}&_limit=#{limit.to_s}&min_beds=#{city.project.group_size}"
    # Parse the results retrieve from the API
    accommodations = JSON.parse(open(url).read)
    listing_array = []
    # Save only the ID from the listing to get the details after
    accommodations["search_results"].each do |result|
      listing_array << [ result["listing"]["id"] ]
    end
    # Using the listing ID retrieved before, fetch all the information from said listing
    house_listing = []
    listing_array.each do |listing|
      listing_url = "https://api.airbnb.com/v2/listings/#{listing.first}?client_id=3092nxybyb0otqw18e8nh5nty&_format=v1_legacy_for_p3"
      house = JSON.parse(open(listing_url).read)
      # IF LAST REVIEWS ARE NEEDED
      # review: house["listing"]["recent_review"]["review"]["comments"],
      # reviewer: house["listing"]["recent_review"]["review"]["reviewer"]["user"]["first_name"],
      house_listing <<  {  id:house["listing"]["id"],
                            name:house["listing"]["name"],
                            price:house["listing"]["price_formatted"].gsub('$','').strip.to_i,
                            description: house["listing"]["description"],
                            beds:house["listing"]["beds"],
                            amenities: amenities_list(house["listing"]["amenities"]),
                            address: house["listing"]["smart_location"],
                            link: "https://www.airbnb.pt/rooms/#{house["listing"]["id"]}",
                            pictures:{
                                        pic1:house["listing"]["picture_urls"][0],
                                        pic2:house["listing"]["picture_urls"][1],
                                        pic3:house["listing"]["picture_urls"][2]
                                      }

                          }
    end
    house_listing
  end


  def amenities_list(amenities)
    result = ""
    amenities.each do |amen|
      result << "<li>" + amen + "</li>"
    end
    result
  end

  def scrape_to_thing(scraping_result)
    result_array = []
    scraping_result.each do |acc|
      result_array << Thing.new(name: acc[:name], description: acc[:description], address: acc[:address], price_range: acc[:price], thing_type: "accommodation", link: acc[:link], tag: acc[:amenities])
    end
    result_array
  end
end
