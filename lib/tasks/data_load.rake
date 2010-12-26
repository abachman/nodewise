require 'date'

namespace :data do
  desc "Load sandbox data"
  task :load => [:environment] do

    # Regular User
    puts "load member"
    create_active_member('')

    # A bunch of regular users
    20.times do |n|
      create_active_member(n)
    end

    # Admin
    puts "load admin"
    user = User.new(
      :email                 => "admin@example.com",
      :password              => "password",
      :password_confirmation => 'password',
      :full_name             => "Hackerspace Admin",
      :username              => "administrator",
      :bio                   => "I am the most powerful user in the system.",
      :receive_notifications => false
    )
    user.roles = [:admin, :member]
    user.skip_confirmation!
    user.save

    generate_membership(user)

    # Treasurer
    puts "load treasurer"
    user = User.new(
      :email                 => "treasurer@example.com",
      :password              => "password",
      :password_confirmation => 'password',
      :full_name             => "Hackerspace Treasurer",
      :username              => "treasurer",
      :bio                   => "I control the **money**.",
      :receive_notifications => false
    )
    user.roles = [:treasurer, :member]
    user.skip_confirmation!
    user.save

    generate_membership(user)
  end
end

def create_active_member(tag)
  user = User.new(
    :email                 => "member#{ tag }@example.com",
    :password              => "password",
    :password_confirmation => 'password',
    :full_name             => "Hackerspace Member#{ tag }",
    :username              => "member#{tag}",
    :bio                   => get_bio,
    :display_publicly      => rand() > 0.5, 
    :receive_notifications => false
  )
  user.roles = [:member]
  user.skip_confirmation!
  user.save

  generate_membership(user)
end

def generate_membership(user)
  user.reload

  now          = DateTime.now
  month_offset = rand(20) + 2
  start_date   = now - month_offset.months

  mbr = user.membership
  if mbr.nil?
    mbr = Membership.create(
      :user => user,
      :monthly_fee => "50.00",
      :member_since => start_date
    )
  else
    mbr.update_attributes(
      :monthly_fee => "50.00",
      :member_since => start_date
    )
  end
  mbr.activate!

  (month_offset).times do |n|
    invoice = Invoice.create(
      :amount        => mbr.monthly_fee,
      :reason        => "dues",
      :due_by        => Membership.next_payment_date(start_date + n.months),
      :paid          => true,
      :membership_id => mbr.id
    )
    Payment.create(:amount => 50, :invoice_id => invoice.id)
  end
  
  # current
  mbr.generate_dues_invoice!
end

def get_bio
  Faker::Lorem.sentences(5).join(" ")
end
