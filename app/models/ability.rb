#ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? :admin
      can :manage, User
      can :read, :all 
      can [:edit, :update], Membership, :user_id => user.id
    end

    if user.is? :treasurer
      can :manage, Membership
      can :change_fee, Membership
      can :manage, Invoice
      can :manage, Payment
    end

    can :manage, User, :id => user.id
    can :read, Invoice, :membership_id => user.membership.id
    can :read, Payment do |payment|
      user.membership.invoices.select {|inv|
        inv.payment.id == payment.id
      }.size > 0
    end
    # can :read, :all 
  end
end
