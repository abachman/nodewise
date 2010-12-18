Given /^I am an? logged in (member|administrator|treasurer)$/ do |level|
  Given "I am a #{ level }"
  steps %Q[
    And   I am on the new user session page
    When  I fill in "Email" with "#{@me.email}"
    And   I fill in "Password" with "password"
    And   I press "Sign in"
  ]
end

Given /^I am an? (member|administrator|treasurer)$/ do |level|
  @me = Factory(level.to_sym)  
  @me.confirm!
  @membership = Factory(:active_membership, :user => @me)
end


Given /^some members exist$/ do
  member = nil
  5.times do 
    member = Factory(:member)
    member.confirm!
    Factory(:active_membership, :user => member)
  end

  @a_member = member
end

When /^I follow "([^"]*)" for a user$/ do |link|
  selector = "#edit_member_#{ @a_member.id }"
  with_scope(selector) do
    click_link(link)
  end
end

Given /^I am an active unconfirmed member$/ do
  @me = Factory(:member)  
  @membership = Factory(:active_membership, :user => @me)
end

When /^I fill in "([^"]*)" with my (.*)$/ do |field, attr|
  Given %Q[I fill in "#{field}" with "#{ @me.send(attr.to_sym) }"]
end

