class CitiesController < ApplicationController

  before_action :set_city, only: [:show, :new_restaurants, :new_accommodations, :new_bars, :new_activities, :new_things]
  before_action :check_leader, only: [:new_restaurants, :new_accommodations, :new_bars, :new_activities, :new_things]
  before_action :check_participant, only: [:show]

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
    @restaurants = @city.restaurants
    @accommodations = @city.accommodations
    @activities = @city.activities
    @bars = @city.bars
  end


  def new_things
    @restaurants = @city.restaurants
    @accommodations = @city.accommodations
    @activities = @city.activities
    @bars = @city.bars
  end

  private


  def set_city
    @city = City.find(params[:id])
  end


  def city_params
    params.require(:city).permit(:name)
  end

  def check_leader
    project = @city.project
    unless project.is_leader?(current_user)
      redirect_to root_path
    end
  end

  def check_participant
    project = @city.project
    unless project.is_participant?(current_user)
      redirect_to root_path
    end
  end
end
