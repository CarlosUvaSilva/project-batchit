class MessagesController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    content = params[:content]
    participant = @project.get_participant(current_user)
    @message = Message.create(content: content, participant: participant, project: @project)
    respond_to do |format|
      format.html { redirect_to project_dashboard(@project)}
      format.js  # <-- will render `app/views/messages/create.js.erb`
    end
  end
end
