module JsendHelper
	def generate_jsend_json(status, data, message = nil)
		hash[:data] = data if data
		hash[:status] = status if status
		hash[:message] = message if message
		JSON hash
	end
end