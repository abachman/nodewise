#ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.is? :admin
      can :manage, User
      can :read, :all 
    end

    if user.is? :treasurer
      can :manage, Membership
    end

    can :manage, User
    can :read, :all 
  end
end
