module UserHelper
	def get_id
		if(params[:id].present? && session[:user_id].blank?)
			params.require(:id)
		elsif session[:user_id].present?
			session[:user_id]
		else
			params.require(:id)
		end
	end
end
