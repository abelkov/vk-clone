class User < ActiveRecord::Base
	before_save do 
		self.email.downcase!
		self.first_name.capitalize!
		self.last_name.capitalize!
	end
	validates :first_name, presence: true, length: { maximum: 50 }
	validates :last_name, presence: true, length: { maximum: 50 }
	Email_regex = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 50 },
	                  format: { with: Email_regex },
	                  uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { in: 6..32 }
end
