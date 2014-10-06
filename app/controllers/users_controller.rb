class UsersController < ApplicationController
	before_action :require_login, only: [:edit, :settings, :update]
	before_action :correct_user, only: [:update]

	def show
		@user = User.find(params[:id])
	end

	def create
		@user = User.new create_params
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
		case params[:commit]
		when "Change password"
			if @user.authenticate(params[:user][:password])
				if params[:user][:new_pass] == params[:user][:pass_conf]
					if params[:user][:new_pass].blank?
						flash.now[:error] = "You didn't enter the new password!"
					elsif @user.update(password: params[:user][:new_pass],
						              password_confirmation: params[:user][:pass_conf])
						flash.now[:success] = "Your password is updated!"
					else
						flash.now[:error] = "You can't use that password. Please enter a valid password."
					end
				else
					flash.now[:error] = "You mistyped your new password. Try again."
				end
			else
				flash.now[:error] = "You entered an incorrect password. Try again."
			end
			render 'settings'

		when "Change email"
			if params[:user][:email] == @user.email
				flash.now[:notice] = "Your email address wasn't changed."
			elsif params[:user][:email].blank?
				flash.now[:error] = "You didn't enter any email address."
			elsif @user.update(email: params[:user][:email])
				flash.now[:success] = "Your email address is updated."
			else
				flash.now[:error] = "You can't use that email address. Please enter a valid email address."
			end
			render 'settings'

		when "Update profile"
			@user.month = birthday_params["birthday(2i)"]
			@user.day   = birthday_params["birthday(3i)"]
			@user.year  = birthday_params["birthday(1i)"]

			# update languages
			@user.languages.clear
			languages = params[:user][:languages].split(", ").map(&:capitalize)
			languages.each do |language|
				existing = Language.find_by(name: language)
				if existing then @user.languages << existing
				else @user.languages << Language.create(name: language)
				end
			end

			@user.update basic_params
			render 'edit'
		end
	end

private
	def create_params
		params.require(:user).permit(:first_name, :last_name, :email,
			:password, :password_confirmation)
	end

	def basic_params
		params.require(:user).permit(:first_name, :last_name, :sex, :relationship,
			                           :hometown)
	end

	def birthday_params
		params.require(:user).permit("birthday(1i)", "birthday(2i)", "birthday(3i)")
	end

	def require_login
		redirect_to root_url, notice: "Please sign in." unless signed_in?
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to root_url unless current_user?(@user)
	end
end
