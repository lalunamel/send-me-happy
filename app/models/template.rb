class Template < ActiveRecord::Base
	validates :text, presence: true
	validates :classification, presence: true
	validate :classification_types

private
	def classification_types
		if self.classification.present?
			errors.add(:classification, "can only be system or user") unless %w(system user).include? self.classification
		end
	end
end
