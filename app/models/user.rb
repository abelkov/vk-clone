class User < ActiveRecord::Base
	has_and_belongs_to_many :languages

	validates :first_name, presence: true, length: { maximum: 50 }
	validates :last_name, presence: true, length: { maximum: 50 }
	Email_regex = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 50 },
	                  format: { with: Email_regex },
	                  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { in: 6..32 }
	validates :sex, inclusion: { in: %w(Male Female) }, allow_blank: true
	validates :relationship, inclusion: { in: ["Single", "In a relationship",
		"Engaged", "Married", "In love", "It's complicated", "Actively searching"] },                     allow_blank: true
	validates :hometown, length: { maximum: 50 }

	before_save do 
		self.email.downcase!
		self.first_name.capitalize!
		self.last_name.capitalize!
		self.full_name = "#{self.first_name} #{self.last_name}"
		self.hometown.capitalize!
	end
end
