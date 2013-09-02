require 'spec_helper'

describe User do
	#测试用例之前执行
	before do 
		@user = User.new(
			name: "xautjzd", 
			email: "xautjzd@126.com",
			password: "xautjzd",
			password_confirmation: "xautjzd"
		)
	end

	#设置测试用例默认的测试对象
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }

	it { should be_valid }
	it { should_not be_admin }

	describe "with admin attribute set to 'true'" do
		before do 
			@user.save!
			#toggle change the admin attribute from false to true
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when name was not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end
	
	describe "when email was not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = 'a' * 51 }
		it { should_not be_valid }
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before do 
			@user = User.new(
				name: "xautjzd",
				email: "xautjzd@163.com",
				password: " ",
				password_confirmation: " "
			)
		end
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch"}
		it { should_not be_valid }
	end


	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		#定义局部变量，代码块的返回值赋值给let方法中的symbol
		let(:found_user) { User.find_by(email: @user.email) }
		
		#测试@user和found_user是否为同一用户
		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid passowrd" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "micropost association" do
		before { @user.save }
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right microposts in the right order" do
			expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
		end

		it "should destroy associated microposts" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		describe "status" do
			let(:unfollowed_post) do
				FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end
			let(:followed_user) { FactoryGirl.create(:user) }

			before do
				@user.follow!(followed_user)
				3.times { followed_user.microposts.create!(content: "xautjzd's micropost") }
			end

			its(:feed) { should include(newer_micropost) }
			its(:feed) { should include(older_micropost) }
			its(:feed) { should_not include(unfollowed_post) }
			its(:feed) do
				followed_user.microposts.each do |micropost|
					should include(micropost)
				end
			end
		end
	end

	describe "following" do
		let(:other_user) { FactoryGirl.create(:user) }
		before do
			@user.save
			@user.follow!(other_user)
		end
		
		it { should be_following(other_user) }
		its(:followed_users) { should include(other_user) }

		describe "unfollowing" do
			before { @user.unfollow!(other_user) }

			it { should_not be_following(other_user) }
			its(:followed_users) { should_not include(other_user) }
		end
	end
end
