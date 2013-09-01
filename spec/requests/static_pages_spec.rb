require 'spec_helper'

describe "Static Pages" do
  subject { page }
 
  shared_examples_for "all static pages" do
		it { should have_content(heading) }
		it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
		before { visit root_path }
    
		it { should have_content('Sample App') }
		it { should have_title(full_title('')) }
		it { should_not have_title('| Home') }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "today is 2013-08-30")
				FactoryGirl.create(:micropost, user: user, content: "tomorrow is another day!")
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
				end
			end
		end
  end

  describe "Help page" do
	  before { visit help_path }
	
	  # let (:heading) { 'Help' }
	  # let (:page_title) { 'Help' }
	  it { should have_content('Help') }
	  it { should have_title(full_title('Help')) }
  end

  describe "About page" do
	  before { visit about_path }
		
	  # let (:heading) { 'About' }
	  # let (:page_title) { 'About' }
	  it { should have_content('About') }
	  it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
	  before { visit contact_path }

	  it { should have_content('Contact') }
	  it { should have_title(full_title('Contact')) }
  end
  
  it "should have the right links on the layout" do
	  visit root_path 
	  click_link 'About'
	  expect(page).to have_title(full_title('About Us'))
	  click_link 'Help'
	  expect(page).to have_title(full_title('Help'))
	  click_link 'Contact'
	  expect(page).to have_title(full_title('Contact'))
	  click_link 'Home'
	  expect(page).to  have_title('')
	  click_link 'Sign up now!'
	  expect(page).to have_title(full_title('Sign Up'))
	  click_link 'sample app'
	  expect(page).to have_title('')
  end
end
