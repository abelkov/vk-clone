require 'spec_helper'

describe User do
	before do
		@user = User.new(first_name: 'John', last_name: 'Doe', email: 'jd@ex.com')
	end

	subject { @user }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }

	describe "first name" do
		describe "not present" do
			before { @user.first_name = " " }
			it { should_not be_valid }
		end

		describe "too long" do
			before { @user.first_name = "a" * 51 }
			it { should_not be_valid }
		end
	end

	describe "last name" do
		describe "not present" do
			before { @user.last_name = " " }
			it { should_not be_valid }
		end

		describe "too long" do
			before { @user.last_name = "a" * 51 }
			it { should_not be_valid }
		end
	end

	describe "email" do
		describe "not present" do
			before { @user.email = " " }
			it { should_not be_valid }
		end

		describe "too long" do
			before { @user.email = "a@b.com" * 10 }
			it { should_not be_valid }
		end

		describe "invalid" do
			it "should not be valid" do
				invalid = %w[user@foo,com foo@bar..com user_at_foo.org
					           example.user@foo.foo@bar_baz.com foo@bar+baz.com]
				invalid.each do |email|
					@user.email = email
					expect(@user).not_to be_valid
				end
			end
		end

		describe "valid" do
			it 'should be valid' do
				valid = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
				valid.each do |email|
					@user.email = email
					expect(@user).to be_valid
				end
			end
		end
	end
end
