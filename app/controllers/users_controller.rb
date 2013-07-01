class UsersController < ApplicationController
  require "serializer_util"
  
	# GET users/1
  def show
    user = User.find params.require(:id)
  	respond_to do |format|
  		format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
  	end
  end

  # POST users/1
  def create
  	user = User.create!(params.permit(:phone, :message_frequency))
  	respond_to do |format|
  		format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
  	end
  end

  # PUT users/1
  def update
    user = User.find(params.require(:id))
    if user.update_attributes params.permit(:phone, :message_frequency)
      respond_to do |format|
        format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
      end
    end
  end
end
