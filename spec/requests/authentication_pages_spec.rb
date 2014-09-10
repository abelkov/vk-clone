require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signup page" do
		before { visit root_path }
		it { should have_content("Sign up") }
	end

	describe "signing up" do
		before { visit root_path }

		describe "with invalid information" do
			it "should not create the user" do
				expect { click_button "Sign up" }.not_to change(User, :count)
			end
			describe "displaying error message" do
				before { click_button "Sign up" }
			  it { should have_selector(".alert-error") }
			end
		end
		describe "with valid information" do
			before do
				fill_in "Your first name", with: 'alexey'
				fill_in "Your last name", with: 'belkov'
				fill_in "Your email", with: 'knots@ya.ru'
				fill_in "Your password", with: 'secret'
				fill_in "Confirm your password", with: 'secret'
			end

			it "should create the user" do
				expect { click_button "Sign up" }.to change(User, :count).by(1)
			end

			describe "congratulating new user on profile page" do
				before { click_button "Sign up" }
				it { should have_title('Alexey Belkov') }
				it { should have_selector(".alert-success") }
			end
		end
	end

	describe "logging in" do
		before { visit root_path }

		describe "with invalid information" do
			before { click_button "Log in" }
			it { should have_title("Welcome") }
			it { should have_selector(".alert-error") }
			describe "after visiting another page" do
				before { visit root_path }
				it { should_not have_selector(".alert-error") }
			end
		end
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Log in"
			end

			it { should have_link("log out", href: logout_path) }
			it { should have_title(user.name) }

			describe "followed by logout" do
				before { click_link "Log out" }
				# redirects to root
				it { should have_content("Welcome") }
				it { should have_selector(".login") }
			end
		end
	end
end
