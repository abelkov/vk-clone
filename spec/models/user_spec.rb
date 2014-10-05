require 'spec_helper'

describe User do

	let(:user) { FactoryGirl.create(:user) }
	subject { user }

	describe "attribute list" do
		it { should respond_to(:first_name) }
		it { should respond_to(:last_name) }
		it { should respond_to(:full_name) }
		it { should respond_to(:email) }
		it { should respond_to(:password_digest) }
		it { should respond_to(:password) }
		it { should respond_to(:password_confirmation) }
		it { should respond_to(:remember_token) }

		it { should respond_to(:authenticate) }
		it { should respond_to(:status) }
		it { should respond_to(:sex) }
		it { should respond_to(:relationship) }
		it { should respond_to(:birthday) }
		it { should respond_to(:hometown) }
		it { should respond_to(:languages) }
	end

	describe "primary attributes" do
		describe "first name" do
			describe "not present" do
				before { user.first_name = " " }
				it { should_not be_valid }
			end
			describe "too long" do
				before { user.first_name = "a" * 51 }
				it { should_not be_valid }
			end
			describe "in lowercase" do
				before do
					user.first_name = 'alexey'
					user.save
				end
				its(:first_name) { should eq 'Alexey' }
			end
		end

		describe "last name" do
			describe "not present" do
				before { user.last_name = " " }
				it { should_not be_valid }
			end
			describe "too long" do
				before { user.last_name = "a" * 51 }
				it { should_not be_valid }
			end
			describe "in lowercase" do
				before do
					user.last_name = 'belkov'
					user.save
				end
				its(:last_name) { should eq 'Belkov' }
			end
		end

		describe "full name" do
			before { user.save }
			its(:full_name) { should eq "Alexey Belkov" }
		end

		describe "email" do
			describe "not present" do
				before { user.email = " " }
				it { should_not be_valid }
			end
			describe "too long" do
				before { user.email = "a" * 45 + "@b.com" }
				it { should_not be_valid }
			end
			describe "invalid" do
				it "should not be valid" do
					invalid = %w[user@foo,com foo@bar..com user_at_foo.org
						           example.user@foo.foo@bar_baz.com foo@bar+baz.com]
					invalid.each do |email|
						user.email = email
						expect(user).not_to be_valid
					end
				end
			end
			describe "valid" do
				it 'should be valid' do
					valid = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
					valid.each do |email|
						user.email = email
						expect(user).to be_valid
					end
				end
			end
			describe "already taken" do
				it "should raise" do
					expect do
						user_with_same_email = FactoryGirl.create(:user)
						user_with_same_email.email = user.email.upcase
					end.to raise_error(ActiveRecord::RecordInvalid)
				end
			end
		end

		describe "password" do
			describe "not present" do
				it "should raise" do
				  expect do
				  	FactoryGirl.create(:user, password: ' ', password_confirmation: ' ')
				  end.to raise_error(ActiveRecord::RecordInvalid)
				end
			end
			describe "doesn't match confirmation" do
				before { user.password = 'mismatch' }
				it { should_not be_valid }
			end
			describe "too short" do
				before { user.password = user.password_confirmation = 'a' * 5 }
				it { should_not be_valid }
			end
			describe "too long" do
				before { user.password = user.password_confirmation = 'a' * 33 }
				it { should_not be_valid }
			end
		end

		describe "remember token" do
			before { user.save }
			its(:remember_token) { should_not be_blank }
		end
	end

	describe "secondary attributes" do
		describe "status" do
		end

		describe "sex" do
			describe "valid" do
				it 'should be valid' do
					valid = SEX + ["", nil]
					valid.each do |sex|
						user.sex = sex
						expect(user).to be_valid
					end
				end
			end
			describe "invalid" do
				before { user.sex = 'invalid' }
				it { should_not be_valid }
			end
		end

		describe "relationship" do
			describe "valid" do
				it 'should be valid' do
					valid = RELATIONSHIP + ["", nil]
					valid.each do |rel|
						user.relationship = rel
						expect(user).to be_valid
					end
				end
			end

			describe "invalid" do
				before { user.relationship = 'invalid' }
				it { should_not be_valid }
			end
		end

		describe "birthday" do
		end

		describe "hometown" do
			describe "too long" do
				before { user.hometown = "a" * 51 }
				it { should_not be_valid }
			end
		end

		describe "languages" do
		end
	end

	describe "return value of authenticate method" do
		before { user.save }
		let(:found_user) { User.find_by(email: user.email) }
		describe "with valid password" do
			it { should eq found_user.authenticate(user.password) }
		end
		describe "with invalid password" do
			it { should_not eq found_user.authenticate("mismatch") }
		end
	end
end
