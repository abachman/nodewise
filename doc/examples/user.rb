# in your Gemfile:
#
#    gem 'role_model'
#

require 'role_model'

class User < ActiveRecord::Base
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :treasurer, :member, :guest

  def self.having_role role
    if User.valid_roles.include? role
      where "roles_mask & :role = :role", {:role => User.mask_for(role)}
    else
      where "1=0"
    end
  end
end
