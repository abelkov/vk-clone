class Language < ActiveRecord::Base
	has_and_belongs_to_many :users, -> { uniq }
	before_create do
		self.name = name.capitalize
	end
end
