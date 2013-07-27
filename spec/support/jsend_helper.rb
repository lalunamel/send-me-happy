module JsendHelper
	def expected_jsend(status, data, message = nil)
		hash = {
			status: status
		}
		hash[:data] = data if data
		hash[:message] = message if message
		JSON(hash)
	end
end