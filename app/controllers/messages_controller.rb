class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :get_messages

  def index
    byebug
  end

  def create
    message = current_user.messages.build(message_params)
    if message.save
      ActionCable.server.broadcast 'room_channel',
                                   content:  message.content,
                                   username: message.user.email


      # redirect_to messages_url
    # else
    #   render 'index'
    end
  end

  private

  def logged_in_user
    current_user
  end

    def get_messages
      @messages = Message.for_display
      @message  = current_user.messages.build
    end

    def message_params
      params.require(:message).permit(:content)
    end
end
