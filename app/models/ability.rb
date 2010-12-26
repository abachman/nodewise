#ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is? :admin
      can :manage, User
      can [:read, :show], :all 
      can [:change_fee, :activate, :edit, :update, :change_status], Membership
      can [:create, :read], Invoice
    end

    if user.is? :treasurer
      can [:send_overdue], User
      can [:manage, :change_fee], Membership
      can :manage, Invoice
      can :manage, Payment
      can :manage, Finance
    end

    can [:read, :show], Membership, :user_id => user.id

    can [:read, :show], Invoice, :membership_id => user.membership.id

    ## ONLY WHEN WE HAVE MERCHANT APIs
    # can [:pay, :read], Invoice, :membership_id => user.membership.id
    # can :create, Payment
    # can :read, Payment do |payment|
    #   user.membership.invoices.select {|inv|
    #     inv.payment.id == payment.id
    #   }.size > 0
    # end
    
    ## VOTING

    can :manage, User, :id => user.id
    can :show, User
  end
end
