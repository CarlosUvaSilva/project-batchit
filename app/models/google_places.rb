require "open-uri"
require "json"

class GooglePlaces

  def self.to_things(params)
    params[:type].nil? ? type = "restaurant" : type = params[:type]
    params[:limit].nil? ? limit = 20 : limit = params[:limit]
    params[:keyword].nil? ? keyword = "lounge" : keyword = params[:keyword]
    lat = params[:city].latitude
    lon = params[:city].longitude
    result_array = []
    max_width = 400 # Of picture
    id_array = GooglePlaces.thing_ids(lat, lon, type, keyword)
    id_array[0..limit].each do |place_id|
      details = JSON.parse(open("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{ENV["GOOGLE_API_SERVER_KEY"]}").read)
      unless details["result"]["photos"].nil? || details["result"]["reviews"].nil?
        photo_ref = details["result"]["photos"][0]["photo_reference"]
        photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=#{max_width}&photoreference=#{photo_ref}&key=#{ENV["GOOGLE_API_SERVER_KEY"]}"
        open(photo_url) do |resp|
          @photo_link = resp.base_uri.to_s
        end # SAVES THE DESTINATION URL TO PICTURE
        address = details["result"]["formatted_address"]
        description = details["result"]["reviews"][0]["text"]
        name = details["result"]["name"]
        tag = "<li><strong>Rating: </strong>" + details["result"]["rating"].to_s + "</li>"
        link = details["result"]["url"]
        result_array << Thing.new(name: name, address: address, link: link, description: description, tag: tag, thing_type: GooglePlaces.thing_type(type), photo_link: @photo_link)
      end
    end
    result_array
  end

  private

  def self.thing_ids(lat, lon, type, keyword)
    radius = 50000
    type = type
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lon}&radius=#{radius}&type=#{type}&keyword=#{keyword}&key=#{ENV["GOOGLE_API_SERVER_KEY"]}"
    document = JSON.parse(open(url).read)
    id_array = []
    document["results"].each do |result|
      id_array << result["place_id"]
    end
    id_array
  end


  def self.thing_type(type)
    if type == "restaurant"
      "restaurant"
    elsif type == "night_club" || type == "bar"
      "bar"
    elsif type == "lodging"
      "accommodation"
    end
  end
end
