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
    end

    can :manage, User, :id => user.id
    can :read, :all 
  end
end
