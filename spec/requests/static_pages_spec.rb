require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "index page" do
		before { visit root_path }

		it { should have_title("Welcome") }
		
		it { should have_selector("#login") }
		it { should have_selector("#index_signup") }
		it { should have_selector("#description") }

		it { should have_content("VK") }
		it { should have_content("Welcome") }

		it { should have_link("password") } # ex. Forgot your password?
		it { should have_link("about") }
		it { should have_link("terms") }
		it { should have_link("people") }
		it { should have_link("communities") }
		it { should have_link("developers") }
	end
end
