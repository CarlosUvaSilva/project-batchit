class CitiesController < ApplicationController

  before_action :set_city, only: [:show, :new_restaurants, :new_accommodations, :new_bars, :new_activities]

  def index
    @cities = City.all
  end

  def new
    @project = Project.find(params[:project_id])
    @city = City.new
    if @project.cities.size >= 2
      redirect_to project_path(@project.id)
    end
  end

  def create
    @city = City.new(city_params)
    @project = Project.find(params[:project_id])
    @city.project = @project
    if @city.save
      redirect_to new_project_city_path(@project)
    else
      @error = @city.errors
      render :new
    end
  end

  def show
  end

  def new_restaurants
    @things = RestaurantScraper.zomato_restaurants(@city.name)
  end

  def new_accommodations
    @house_listing = scrape_to_thing(airbnb_scraper(5))
  end

  def new_bars
  end

  def new_activities
    @activities = StoredActivity.get_things(@city.name)
  end

  private


  def set_city
    @city = City.find(params[:id])
  end


  def city_params
    params.require(:city).permit(:name)
  end
end
