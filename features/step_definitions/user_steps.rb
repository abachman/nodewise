Given /^I am an active confirmed member$/ do
  @me = Factory(:member)  
  @me.confirm!
  @membership = Factory(:active_membership, :user => @me)
end

Given /^I am an active unconfirmed member$/ do
  @me = Factory(:member)  
  @membership = Factory(:active_membership, :user => @me)
end
