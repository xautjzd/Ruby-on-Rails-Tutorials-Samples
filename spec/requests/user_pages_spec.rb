require 'spec_helper'

describe "UserPages" do
  subject { page }
  describe "Sign Up page" do
	before { visit users_new_path }

	it { should have_content('Sign Up') }
	it { should have_title(full_title('Sign Up')) }
  end
end
