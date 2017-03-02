class ParticipantsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @participants = @project.participants
    @participant = Participant.new()
  end

  def create
    @participant = Participant.new(participant_params)
    @project = Project.find(params[:project_id])
    @participant.project = @project
    if @participant.save
      respond_to do |format|
        format.html { redirect_to project_path(@project) }
        format.js  # <-- will render `app/views/participants/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'index' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
  end

  private

  def participant_params
    params.require(:participant).permit(:email)
  end
end
