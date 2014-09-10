require 'spec_helper'

describe "User pages" do

	subject { page }

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
				user.update_attribute(:sex, nil)
				visit user_path(user)
			end
			it { should_not have_content("Sex:") }
		end

		describe "without relationship" do
			before do
				user.update_attribute(:relationship, nil)
				visit user_path(user)
			end
			it { should_not have_content("Relationship:") }
		end

		describe "without birthday" do
			before do
				user.update_attribute(:birthday, nil)
				visit user_path(user)
			end
			it { should_not have_content("Birthday:") }
		end

		describe "without hometown" do
			before do
				user.update_attribute(:hometown, nil)
				visit user_path(user)
			end
			it { should_not have_content("Hometown:") }
		end

		describe "without languages" do
			before do
				user.languages.delete_all
				visit user_path(user)
			end
			it { should_not have_content("Languages:") }
		end
	end
end