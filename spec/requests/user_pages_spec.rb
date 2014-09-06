require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit root_path }
		it { should have_content("Sign up") }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_title(user.full_name) }
		it { should have_content(user.full_name) }
		it { should have_content(user.status) }
		it { should have_content("Sex:") }
		it { should have_content(user.sex) }
		it { should have_content("Relationship:") }
		it { should have_content(user.relationship) }
		it { should have_content("Birthday:") }
		it { should have_content(user.birthday.strftime("%B %-d, %Y")) }
		it { should have_content("Hometown:") }
		it { should have_content(user.hometown) }
		it { should have_content("Languages:") }
		it { should have_content(user.languages.map(&:name).join(", ")) }

		describe "without sex" do
			before do
				user.sex = nil
				visit user_path(user)
			end
			it { should_not have_content("Sex:") }
		end
	end
end