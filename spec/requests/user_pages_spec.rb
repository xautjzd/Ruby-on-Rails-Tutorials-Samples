require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }
		
		it { should have_content('Sign Up') }
		it { should have_title(full_title('Sign Up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it {should have_content(user.name) }
		it { should have_title(user.name) }
	end

	describe 'signup' do

		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should no create a user" do
			expect{ click_button submit }.not_to change(User,:count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", with: 'xautjzd'
				fill_in "Email", with: 'xautjzd@gmail.com'
				fill_in "Password", with: 'xautjzd'
				fill_in "Confirmation", with: 'xautjzd'
			end

			it "should create a user" do
				expect do
					click_button submit
				end.to change(User,:count)
			end
		end
	end
end
