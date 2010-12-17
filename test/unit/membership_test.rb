require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  setup do 
    @member = Factory(:user)
    @membership = Factory(:membership, :user => @member)
  end
end
