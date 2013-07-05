class Message < ActiveRecord::Base
	after_initialize :after_initialize

	belongs_to :user
	belongs_to :template

	validates :user, presence: true
	validates :template, presence: true
	validates :text, presence: true, if: lambda { |message| message.template.present? }

private
	def after_initialize()
		self.text = self.template.text if self.template.present?
	end
	
end
