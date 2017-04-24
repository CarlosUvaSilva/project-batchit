class MessagesController < ApplicationController
  def index
    project = Project.find(params[:project_id])
    @messages = project.messages.last(50)
  end

  def create
    @project = Project.find(params[:project_id])
    content = params[:content]
    participant = @project.get_participant(current_user)
    @message = Message.create(content: content, participant: participant, project: @project)
    @message_previous = Message.find(@message.id - 1)
    respond_to do |format|
      format.html { redirect_to project_dashboard(@project)}
      format.js  # <-- will render `app/views/messages/create.js.erb`
    end
  end
end
