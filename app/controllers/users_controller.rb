class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new user_params
		if @user.save
		  flash[:success] = "Welcome to VK!"
		  redirect_to user_path(@user)	
		else
			render 'static_pages/index'
		end
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email,
			                           :password, :password_confirmation)
	end
end
