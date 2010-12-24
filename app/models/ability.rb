#ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? :admin
      can :manage, User
      can :read, :all 
      can [:edit, :update, :change_status], Membership
      can [:create, :read], Invoice
      # can [:edit, :update], Membership, :user_id => user.id
    end

    if user.is? :treasurer
      can :manage, Membership
      can :change_fee, Membership
      can :manage, Invoice
      can :manage, Payment
      can :manage, Finance
    end

    can :read, Membership, :user_id => user.id

    can :read, Invoice, :membership_id => user.membership.id
    ## ONLY WHEN WE HAVE MERCHANT APIs
    # can [:pay, :read], Invoice, :membership_id => user.membership.id
    # can :create, Payment
    # can :read, Payment do |payment|
    #   user.membership.invoices.select {|inv|
    #     inv.payment.id == payment.id
    #   }.size > 0
    # end

    can :manage, User, :id => user.id
    can :read, User
  end
end
