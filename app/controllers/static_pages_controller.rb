class StaticPagesController < ApplicationController
	def index
		if signed_in?
			redirect_to user_path(current_user)
		else
			@user = User.new
		end
	end

	def restore
	end

	def about
	end

	def terms
	end
	
	def people
	end

	def communities
	end

	def developers
	end
end
