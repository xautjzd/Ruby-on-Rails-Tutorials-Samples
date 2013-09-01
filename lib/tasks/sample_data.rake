namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name: "xautjzd",
								email: "xautjzd@gmail.com",
								password: "xautjzd",
								password_confirmation: "xautjzd",
								admin: true)

		100.times do |n|
			name = Faker::Name.name
			email = "test-#{n+1}@gmail.com"
			password = "xautjzd"
			User.create!(name: name,
									email: email,
									password: password,
									password_confirmation: password)
		end

		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end
