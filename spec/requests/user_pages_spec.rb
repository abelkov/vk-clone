require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit root_path }
		it { should have_content("Sign up") }
	end

	describe "profile page" do
		before { visit user_path(user) }
		it { should have_title(user.full_name) }
		it { should have_content(user.full_name) }
	end
end