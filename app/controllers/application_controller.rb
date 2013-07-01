class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::ParameterMissing, with: :rescue_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_record_invalid

  def routing_error
  	respond_to do |format|
  		format.json { render_jsend(fail: ["missing required parameter"]) }
  	end
  end

  def rescue_parameter_missing(e)
  	# { "id" : "An id is required" }
  	error_hash = { e.param.to_s => "#{e.param.to_s} is required".indefinitize.capitalize }
  	respond_to do |format|
  		format.json { render_jsend({fail: error_hash, render: {status: 400}}) }
  	end
  end

  def rescue_record_invalid(e)
  	error_hash = {}
  	e.record.errors.messages.each { |k, msgs|  msgs.each { |msg| error_hash[k.to_s] = msg.to_s } }
  	respond_to do |format|
  		format.json { render_jsend({fail: error_hash, render: {status: 400}}) }
  	end
  end
end
