class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create ]
  before_action :check_leader, only: [:show, :finalize]
  before_action :check_participant, only: [:dashboard]



  def index
    @projects = current_user.projects
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new()
  end

  def create
    @project = Project.new(project_params(params))
    if @project.save
      @participant = Participant.create(email: current_user.email, project: @project, user: current_user, is_leader: true)
      if params[:city_1] != "" && params[:city_1] != ""
        @city_1 = City.create(name: params[:city_1], project: @project)
        @city_2 = City.create(name: params[:city_2], project: @project)
        redirect_to project_path(@project.id)
      else
        redirect_to new_project_city_path(@project)
      end
    else
      render "new"
    end
  end

  def dashboard
    @project = Project.find(params[:id])
    @city1 = @project.cities.first
    @city2 = @project.cities.second
    @city1_restaurants = city_things_sort(@city1.restaurants)
    @city1_accommodations = city_things_sort(@city1.accommodations)
    @city1_activities = city_things_sort(@city1.activities)
    @city1_bars = city_things_sort(@city1.bars)
    @city2_restaurants = city_things_sort(@city2.restaurants)
    @city2_accommodations = city_things_sort(@city2.accommodations)
    @city2_activities = city_things_sort(@city2.activities)
    @city2_bars = city_things_sort(@city2.bars)
  end

  def finalize
    @project = Project.find(params[:id])
    participant = @project.get_participant(current_user)
    participant.is_leader = nil
    participant.save
    redirect_to project_city_path(@project, @project.cities.first)
  end

  private

  def project_params(params)
    begin
        start_date = Date.parse(params[:project][:start_date])
        end_date = Date.parse(params[:project][:end_date])
    rescue ArgumentError
        start_date = nil
        end_date = nil
    end
    {name: params[:project][:name], description: params[:project][:description],
     group_size: params[:project][:group_size].to_i, start_date: start_date,
     end_date: end_date, ongoing: true }
  end

  def check_leader
    project = Project.find(params[:id])
    unless project.is_leader?(current_user)
      redirect_to root_path
    end
  end

  def check_participant
    project = Project.find(params[:id])
    unless project.is_participant?(current_user)
      redirect_to root_path
    end
  end

  def city_things_sort(things)
    things.sort_by { |thing| thing.total_votes }.reverse
  end
end
