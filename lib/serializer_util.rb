module SerializerUtil 
	def self.serialize_to_json(target, options = {})
		target.active_model_serializer.new(target, options).to_json
	end

	def self.serialize_to_hash(target, options = {})
		target.active_model_serializer.new(target, options).serializable_hash
	end
end