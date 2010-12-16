namespace :data do
  desc "Load sandbox data"
  task :load => :environment do

    # Regular User
    puts "load member"
    user = User.create(
      :email                 => "member@email.com",
      :password              => "password",
      :password_confirmation => 'password',
      :full_name             => "Hackerspace Member",
      :username              => "member",
      :bio                   => "I've been a member for long enough to know the difference between wrong and right.",
      :links                 => ["http://google.com", "http://hackerspaces.org"]
    )
    user.update_attribute :roles, [:member]
    user.confirm!

    mbr = Membership.create(
      :user => user,
      :monthly_fee => "50.00",
      :next_payment_due => Date.new(2011, 5, 1),
      :member_since => Date.new(2009, 4, 1)
    )
    mbr.activate!

    # Admin
    puts "load admin"
    user = User.create(
      :email => "admin@email.com",
      :password => "password",
      :password_confirmation => 'password',
      :full_name => "Hackerspace Admin",
      :username              => "administrator",
      :bio => "I am the most powerful user in the system.",
      :links => ["http://google.com", "http://hackerspaces.org"]
    )
    user.update_attribute :roles, [:admin, :member]
    user.confirm!

    mbr = Membership.create(
      :user => user,
      :monthly_fee => "50.00",
      :next_payment_due => Date.new(2011, 5, 1),
      :member_since => Date.new(2009, 4, 1)
    )
    mbr.activate!

    # Treasurer
    puts "load treasurer"
    user = User.create(
      :email => "treasurer@email.com",
      :password => "password",
      :password_confirmation => 'password',
      :full_name => "Hackerspace Treasurer",
      :username              => "treasurer",
      :bio => "I control the **money**.",
      :links => ["http://google.com", "http://hackerspaces.org"]
    )
    user.update_attribute :roles, [:treasurer, :member]
    user.confirm!

    mbr = Membership.create(
      :user => user,
      :monthly_fee => "50.00",
      :next_payment_due => Date.new(2011, 5, 1),
      :member_since => Date.new(2009, 4, 1)
    )
    mbr.activate!
  end
end
