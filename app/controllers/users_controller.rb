class UsersController < ApplicationController
  require "serializer_util"
  include UserHelper
  
	# GET users/1
  def show
    user = User.find get_id
  	respond_to do |format|
  		format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
  	end
  end

  # POST users/1
  def create
    params.require(:phone)
  	user = User.create!(params.permit(:phone, :message_frequency))
    session[:user_id] = user.id

    send_verification_code
  end

  # PUT users/1
  def update
    user = User.find(get_id)
    if user.update_attributes params.permit(:phone, :message_frequency)
      respond_to do |format|
        format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
      end
    end
  end

  # POST users/1/send_verification_code
  def send_verification_code
    user = User.find(get_id)

    two_factor_service = TwoFactorAuthService.new(user)
    message_sent = two_factor_service.send_verification_code

    if message_sent
      respond_to do |format|
        format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
      end
    else
      respond_to do |format|
        format.json { render_jsend(error: "Your message failed to send. Please try again", render: {status: 500})}
      end
    end
  end

  # POST users/1/verify
  def verify
    params.require(:verification_token)
    user = User.find(get_id)

    two_factor_service = TwoFactorAuthService.new(user)
    error = two_factor_service.valid_token?(params.require(:verification_token))

    if error == ''
      respond_to do |format|
        format.json { render_jsend(success: true) }
      end
    else
      respond_to do |format|
        format.json { render_jsend(fail: {verification_token: error}, render: {status: 400}) }
      end
    end
  end
end
