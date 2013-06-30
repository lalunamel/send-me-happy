class UsersController < ApplicationController

	# GET users/1
  def show
  	respond_to do |format|
  		format.json { render json: User.find(params[:id]) }
  	end
  end

  # POST users/1
  def create
  	user = User.create(params.permit(:phone, :message_frequency))
  	respond_to do |format|
  		format.json { render json: user }
  	end
  end

  # PUT users/1
  def update
    user = User.find(params[:id])
    if user.update_attributes params.permit(:phone, :message_frequency)
      respond_to do |format|
        format.json { render json: user }
      end
    end
  end
end
