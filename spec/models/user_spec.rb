require 'spec_helper'

describe User do
	before do
		@user = User.new(first_name: 'John', last_name: 'Doe', email: 'jd@ex.com',
			               password: 'foobar', password_confirmation: 'foobar')
	end

	subject { @user }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }

	describe "first name" do
		describe "not present" do
			before { @user.first_name = " " }
			it { should_not be_valid }
		end

		describe "too long" do
			before { @user.first_name = "a" * 51 }
			it { should_not be_valid }
		end

		describe "in lowercase" do
			before do
				@user.first_name = 'john'
				@user.save
			end
			its(:first_name) { should eq 'John' }
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

		describe "in lowercase" do
			before do
				@user.last_name = 'doe'
				@user.save
			end
			its(:last_name) { should eq 'Doe' }
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

		describe "already taken" do
			before do
				user_with_same_email = @user.dup
				user_with_same_email.email = @user.email.upcase
				user_with_same_email.save
			end
			it { should_not be_valid }
		end
	end

	describe "password" do

		describe "not present" do
			before do
				@user = User.new(first_name: 'John', last_name: 'Doe',
					               email: 'jd@ex.com', password: ' ',
					               password_confirmation: ' ')
			end
			it { should_not be_valid }
		end

		describe "doesn't match confirmation" do
			before { @user.password = 'mismatch' }
			it { should_not be_valid }
		end

		describe "too short" do
			before { @user.password = @user.password_confirmation = 'a' * 5 }
			it { should_not be_valid }
		end

		describe "too long" do
			before { @user.password = @user.password_confirmation = 'a' * 33 }
			it { should_not be_valid }
		end
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			it { should_not eq found_user.authenticate("mismatch") }
		end
	end
end
