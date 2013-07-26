class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::ParameterMissing, with: :rescue_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_record_not_found

  def routing_error
  	respond_to do |format|
  		format.json { render_jsend(fail: ["missing required parameter"]) }
  	end
  end

  def rescue_parameter_missing(e)
    if(e.param == :phone)
      error_hash = { :phone => "Please enter a valid number" }
    else
     	error_hash = { e.param.to_s => "can't be blank" }
   end
  	respond_to do |format|
  		format.json { render_jsend({fail: error_hash, render: {status: 400}}) }
  	end
  end

  def rescue_record_invalid(e)
  	error_hash = {}
  	e.record.errors.messages.each { |attribute, msgs|  msgs.each { |msg| error_hash[attribute.to_s] = msg.to_s } }
  	respond_to do |format|
  		format.json { render_jsend({fail: error_hash, render: {status: 400}}) }
  	end
  end

  def rescue_record_not_found(e)
    respond_to do |format|
      format.json { render_jsend({error: e.message, render: {status: 404}}) }
    end
  end
end
