require 'date'

namespace :data do
  desc "Load sandbox data"
  task :load => :environment do

    # Regular User
    puts "load member"
    create_active_member('')

    # A bunch of regular users
    25.times do |n|
      create_active_member(n)
    end

    # Admin
    puts "load admin"
    user = User.new(
      :email                 => "admin@email.com",
      :password              => "password",
      :password_confirmation => 'password',
      :full_name             => "Hackerspace Admin",
      :username              => "administrator",
      :bio                   => "I am the most powerful user in the system."
    )
    user.roles = [:admin, :member]
    user.skip_confirmation!
    user.save

    generate_membership(user)

    # Treasurer
    puts "load treasurer"
    user = User.new(
      :email                 => "treasurer@email.com",
      :password              => "password",
      :password_confirmation => 'password',
      :full_name             => "Hackerspace Treasurer",
      :username              => "treasurer",
      :bio                   => "I control the **money**."
    )
    user.roles = [:treasurer, :member]
    user.skip_confirmation!
    user.save

    generate_membership(user)
  end
end

def create_active_member(tag)
  user = User.new(
    :email                 => "member#{ tag }@email.com",
    :password              => "password",
    :password_confirmation => 'password',
    :full_name             => "Hackerspace Member#{ tag }",
    :username              => "member#{tag}",
    :bio                   => get_bio
  )
  user.roles = [:member]
  user.skip_confirmation!
  user.save

  generate_membership(user)
end

def generate_membership(user)
  now          = DateTime.now
  month_offset = rand(20 + 2)
  start_date   = now - month_offset.months

  mbr = Membership.create(
    :user => user,
    :monthly_fee => "50.00",
    :next_payment_due => Date.new(2011, 5, 1),
    :member_since => start_date
  )
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
  Invoice.create(
    :amount => mbr.monthly_fee,
    :reason => "dues",
    :due_by => Membership.next_payment_date,
    :paid   => false,
    :membership_id => mbr.id
  )
end

def get_bio
  Faker::Lorem.sentences(5).join(" ")
end
