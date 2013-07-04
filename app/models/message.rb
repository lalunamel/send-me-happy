class Message < ActiveRecord::Base
	belongs_to :user
	belongs_to :template
	
	validates :user, presence: true
	validates :template, presence: true
end
