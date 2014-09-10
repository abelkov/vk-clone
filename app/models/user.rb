class User < ActiveRecord::Base
	has_and_belongs_to_many :languages
	has_attached_file :avatar, styles: { :medium => "232x232>",
		thumb: "50x50>" }, default_url: ":style/missing.gif"
  validates_attachment :avatar, size: { in: 0..1.megabytes }
  validates_attachment_content_type :avatar, :content_type => /\Aimage/
  validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
  do_not_validate_attachment_file_type :avatar

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
		self.hometown.capitalize! unless hometown.nil?
	end

	before_create :create_remember_token

	def User.digest (token)
		Digest::SHA1::hexdigest(token.to_s)
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end
end
