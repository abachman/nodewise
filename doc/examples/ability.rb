class Ability
  include CanCan::Ability

  def initialize(user)
    # All abilities are scoped to roles
    if user.is? :admin
      # can :do, Stuff
    end
    
    if user.is? :treasurer
      # can :do, Stuff
    end

    if user.is? :member
      # can :do, Stuff
    end
  end
end
