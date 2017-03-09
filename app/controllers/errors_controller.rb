class ErrorsController < ApplicationController

  skip_before_action :authenticate_user!, only: [ :not_found, :internal_server_error ]

  def not_found
    @disable_nav = true
    render(:status => 404)
  end

  def internal_server_error
    @disable_nav = true
    render(:status => 500)
  end
end
