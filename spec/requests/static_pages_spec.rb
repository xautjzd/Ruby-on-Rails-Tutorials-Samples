require 'spec_helper'

describe "Static Pages" do
  subject { page }
 
  shared_examples_for "all static pages" do
	it { should have_content(heading) }
	it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
	before { visit root_path }
	let (:heading) { 'Sample App' }
	let (:page_title) { '' }

	it { should_not have_title('Home') }
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
  
  describe "should have the right links on the layout" do
	  visit root_path
	  clicklink 'About'
	  expect(page).to have_title(full_title(About Us))
	  clicklink 'Help'
	  expect(page).to
	  clicklink 'About'
	  expect(page).to
	  clicklink 'Contact'
	  expect(page).to
	  clicklink 'Home'
	  expect(page).to
	  clicklink 'Sign Up'
	  expect(page).to
	  clicklink 'sample app'
	  expect(page).to
  end
end
