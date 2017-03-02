class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
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
end
