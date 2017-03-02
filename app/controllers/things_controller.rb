require 'json'
require 'open-uri'

class ThingsController < ApplicationController
  before_action :set_city, only: [:show]

  def create_restaurant
    create_thing("restaurant")
  end

  def create_bar
    create_thing("bar")
  end

  def create_accommodation
    create_thing("accommodation")
  end


  def create_activity
    create_thing("activity")
  end

  def index
    @things = Thing.all
  end

  def new_scraper
    @house_listing = scrape_to_thing(airbnb_scraper(4))
  end

  private

  def set_thing
    @thing = City.find(params[:id])
  end


  def thing_params
    params.require(:thing).permit(:name,:description, :price_range, :address, :link, :tag)
  end


  def create_thing(type)
    @thing = Thing.new(thing_params)
    @city = City.find(params[:id])
    @thing.thing_type = type
    @thing.city = @city
    if @thing.save
      @city.send(type.pluralize).first.destroy if @city.send(type.pluralize).size > 3
      respond_to do |format|
        format.html { redirect_to send("new_city_" + type.pluralize + "_path"), notice: " Successfully created" }
        format.js  # <-- will render `app/views/things/create_activity.js.erb`
      end
    else
      respond_to do |format|
        format.html { render ('cities/new_' + type.pluralize) }
        format.js  # <-- idem
      end
    end
  end
end
