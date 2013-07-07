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

  # POST users/register_and_send_code?phone=
  def register_and_send_code
    user = User.new(phone: params.require(:phone))
    if user.save
      two_factor_service = TwoFactorAuthService.new(user)
      message_sent = two_factor_service.send_verification_code

      if message_sent
        respond_to do |format|
          format.json { render_jsend(success: true) }
        end
      else
        respond_to do |format|
          format.json { render_jsend(error: "The message failed to send") }
        end
      end
    else
      respond_to do |format|
        format.json { render_jsend(fail: user.errors) }
      end
    end
  end
end
