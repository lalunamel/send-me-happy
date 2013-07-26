module JsendHelper
	def generate_jsend_json(status, data)
		JSON({ status: status, data: data })
	end
end