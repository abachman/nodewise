##############
## USERS
Factory.define :member, :class => User do |u|
  u.email     'member@email.com'
  u.full_name 'Hackerspace Member'
  u.username  'member'
  u.password  'password'
  u.password_confirmation 'password'
  u.bio  "I've been a member for long enough to know the difference between wrong and right."
  u.links ["http://google.com", "http://hackerspaces.org"]
  u.roles     [:member]
end

Factory.define :admin, :parent => :member do |u|
  u.email     'admin@email.com'
  u.full_name 'Hackerspace Admin'
  u.username  'admin'
  u.roles     [:admin, :member]
end

Factory.define :treasurer, :parent => :member do |u|
  u.email     'admin@email.com'
  u.full_name 'Hackerspace Treasurer'
  u.username  'treasurer'
  u.roles     [:treasurer, :member]
end

##############
## MEMBERSHIP

Factory.define :membership do |m|
  m.association :user, :factory => :user
  m.monthly_fee "50.00"
  m.next_payment_due Date.new(2011, 5, 1)
  m.member_since Date.new(2009, 4, 1)
end

Factory.define :active_membership, :parent => :membership do |m|
  m.state 'active'
end

Factory.define :inactive_membership, :parent => :membership do |m|
  m.state 'inactive'
end
