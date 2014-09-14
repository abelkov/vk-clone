class UsersController < ApplicationController
	before_action :require_login, only: [:edit, :settings, :update]
	before_action :correct_user, only: [:update]

	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new user_params
		if @user.save
			sign_in @user
		  flash[:success] = "Welcome to VK!"
		  redirect_to @user
		else
			render 'static_pages/index'
		end
	end

	def edit
		@user = current_user
	end

	def settings
		@user = current_user
	end

	def update
		
	end

	private

		def user_params
			params.require(:user).permit(:first_name, :last_name, :email,
				                           :password, :password_confirmation)
		end

		def require_login
			redirect_to root_url, notice: "Please sign in." unless signed_in?
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to root_url unless current_user?(@user)
		end
end
