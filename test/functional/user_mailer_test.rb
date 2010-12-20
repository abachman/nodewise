require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = Factory(:member)
    membership = Factory(:active_membership, :user => @user)
    Factory(:invoice, :membership => membership)
  end

  test "dues_reminder" do
    mail = UserMailer.dues_reminder @user
    assert_equal "Dues reminder", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["membership@baltimorenode.org"], mail.from
    assert_match /Your next membership dues payment is due by/, mail.body.encoded
  end

  test "dues_overdue" do
    mail = UserMailer.dues_overdue @user
    assert_equal "Dues overdue", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["membership@baltimorenode.org"], mail.from
    assert_match /Your current membership dues payment is overdue/, mail.body.encoded
  end

end
