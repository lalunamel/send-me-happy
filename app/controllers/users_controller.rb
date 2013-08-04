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
  	
    two_factor_service = TwoFactorAuthService.new(user)
    message_sent = two_factor_service.send_verification_code

    if message_sent
      respond_to do |format|
        format.json { render_jsend(success: SerializerUtil::serialize_to_hash(user)) }
      end
    else
      respond_to do |format|
        format.json { render_jsend(error: "Your message failed to send. Please try again") }
      end
    end
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

  # POST users/1/verify
  def verify
    params.require(:verification_token)
    
    user = User.find(get_id)

    two_factor_service = TwoFactorAuthService.new(user)
    token_is_valid = two_factor_service.valid_token?(params.require(:verification_token))

    if token_is_valid
      respond_to do |format|
        format.json { render_jsend(success: token_is_valid) }
      end
    else
      respond_to do |format|
        format.json { render_jsend(error: "The verification code you entered is not correct or is too old. Please request a new code") }
      end
    end
  end
end
