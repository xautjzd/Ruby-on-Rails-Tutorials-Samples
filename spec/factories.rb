FactoryGirl.define do
	# factory :user do
	# 	name	"xautjzd"
	# 	email	"xautjzd@gmail.com"
	# 	password	"xautjzd"
	# 	password_confirmation "xautjzd"
	# end
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@gmail.com" }
		password "xautjzd"
		password_confirmation "xautjzd"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "xautjzd's posts"
		user
	end
end
