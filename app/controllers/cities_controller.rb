class CitiesController < ApplicationController

  before_action :set_city, only: [:show, :new_restaurants, :new_accommodations, :new_bars, :new_activities]

  def index
    @cities = City.all
  end

  def new
    @project = Project.find(params[:project_id])
    @city = City.new
  end

  def create
    @city = City.new(city_params)
    @project = Project.find(params[:project_id])
    @city.project = @project
    if @city.save
      redirect_to project_city_path(@project, @city)
    else
      @error = @city.errors
      render :new
    end
  end

  def show
  end

  def new_restaurants
  end

  def new_accommodations
    @house_listing = scrape_to_thing(airbnb_scraper(5))
  end

  def new_bars
  end

  def new_activities
  end

  private


  def set_city
    @city = City.find(params[:id])
  end


  def city_params
    params.require(:city).permit(:name)
  end
end
