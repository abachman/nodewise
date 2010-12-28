require 'md5'

class User < ActiveRecord::Base
  include RoleModel
  roles_attribute :roles_mask
  roles :admin, :treasurer, :member, :guest

  ### username lockdown
  validates_presence_of :username
  validates_uniqueness_of :username, :case_sensitive => false
  # reserved usernames, so that we can use /:username as a shortlink to a user
  validates_exclusion_of :username,
    :in => %w[ users admin reports ads partners api issues votes finances ],
    :message => "%{value} is reserved."
  # username must look like...
  validates_format_of :username,
    :with => /^[a-zA-Z0-9_-]+$/,
    :message => "must contain only letters, numbers, -, and _"

  before_validation :clean_username
  def clean_username
    self.username = self.username.chomp.strip
  end

  after_create :generate_membership
  after_create :notify_admins

  def generate_membership
    if membership.nil?
      membership = Membership.new(
        :monthly_fee => Membership::DEFAULT_MONTHLY_FEE
      )
      membership.user_id = self.id
      membership.save
    end
  end

  def notify_admins
    UserMailer.user_created(self).deliver if User.having_role(:admin).count > 0
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model. All other fields
  # e.g., `admin` must be set manually.
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :bio, :links, :full_name, :image_url, :username, :receive_notifications,
                  :display_publicly

  has_one :membership
  
  # these could use some validation
  serialize :links

  before_save :generate_rendered_bio, :if => lambda { !(self.bio.nil? || self.bio.empty?) }

  def gravatar_hash
    hash = MD5.new(email.chomp.downcase)
  end

  def gravatar_url(size=128)
    "http://www.gravatar.com/avatar/#{ gravatar_hash }.png?s=#{size}&d=mm"
  end

  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end

  def self.with_username name
    where(['LOWER(username) = LOWER(?)', name]).first
  end

  def self.public
    where :display_publicly => true
  end

  # not an Arel relation!
  def self.admins
    all.select {|u| u.has_role? :admin}
  end

  def self.having_role role
    if User.valid_roles.include? role
      where "roles_mask & :role = :role", {:role => User.mask_for(role)}
    else
      where "1=0"
    end
  end

protected
  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

private 
  def generate_rendered_bio
    self.rendered_bio = RDiscount.new(self.bio).to_html
  end

end
