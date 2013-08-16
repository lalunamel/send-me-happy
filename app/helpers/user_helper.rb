module UserHelper
	def get_id
		if params[:id].present?
			params.require(:id)
		elsif session[:user_id].present?
			session[:user_id]
		else
			params.require(:id)
		end
	end

	# Custom route helpers
	def users_send_verification_code_path(id = nil)
		id_ = "/#{id}" unless id == nil
		"/users#{id_}/send_verification_code"
	end

	def users_verify_path(id = nil)
		id_ = "/#{id}" unless id == nil
		"/users#{id_}/verify"
	end
end
