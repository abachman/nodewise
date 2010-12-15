class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model. All other fields
  # e.g., `admin` must be set manually.
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :bio, :links, :full_name, :image_url

  has_one :membership

  serialize :links

  before_save :generate_rendered_bio

private 
  def generate_rendered_bio
    self.rendered_bio = RDiscount.new(self.bio).to_html
  end
end
