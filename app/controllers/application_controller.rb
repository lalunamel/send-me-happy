class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def routing_error
  	respond_to do |format|
  		format.json { render status: :bad_request }
  	end
  end
end
