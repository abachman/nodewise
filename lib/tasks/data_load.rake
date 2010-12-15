namespace :data do
  desc "Load sandbox data"
  task :load => :environment do

    first = User.create(
      :email => "user@email.com",
      :password => "password",
      :password_confirmation => 'password',
      :full_name => "Hackerspace Member",
      :bio => "I've been a member for long enough to know the difference between wrong and right.",
      :links => ["http://google.com", "http://hackerspaces.org"]
    )
    first.confirm!

    Membership.create(
      :user => first,
      :status => "ACTIVE",
      :monthly_fee => "50.00",
      :next_payment_due => Date.new(2011, 5, 1),
      :member_since => Date.new(2009, 4, 1)
    )
  end
end
