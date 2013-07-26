class UserSerializer < ActiveModel::Serializer
  attributes :id, :phone, :message_frequency
end
