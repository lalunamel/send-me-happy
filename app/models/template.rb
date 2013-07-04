class Template < ActiveRecord::Base
	validates :text, presence: :true
end
