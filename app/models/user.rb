class User < ActiveRecord::Base
	attr_accessor :month, :day, :year

	has_and_belongs_to_many :languages, -> { uniq }
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
	validates :password,
    length: { in: 6..32, if: :validate_password? },
    confirmation: { if: :validate_password? }

	validates :sex, inclusion: { in: SEX }, allow_blank: true
	validates :relationship, inclusion: { in: RELATIONSHIP },                       allow_blank: true
	validates :hometown, length: { maximum: 50 }

	include ActiveModel::Validations
	validate :validate_birthday, on: :update

	before_save do 
		self.email.downcase!
		self.first_name.capitalize!
		self.last_name.capitalize!
		self.full_name = "#{self.first_name} #{self.last_name}"
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

		def validate_password?
	    password.present? || password_confirmation.present?
	  end

		def convert_birthday
			if [self.try(:month), self.try(:day), self.try(:year)].count(nil) == 3
				true
		  else
		  	begin
			    self.birthday = Date.civil(self.year.to_i, self.month.to_i,
			    	                         self.day.to_i)
			  rescue ArgumentError
			    false
		  	end
		  end
		end

		def validate_birthday
		  errors.add("Birthday date", "is invalid.") unless convert_birthday
		end
end
