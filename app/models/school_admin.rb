class SchoolAdmin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:first_name,:last_name,:school_name,:reset_password_token
  validates :school_name, :email,:first_name,:last_name, :presence => true
  validates_uniqueness_of :school_name, :email
  has_many :students, :dependent => :destroy
  has_many :teachers, :dependent => :destroy
  validates :password, :presence =>true,
    :length => { :minimum => 6, :maximum => 15 },
    :confirmation =>true, :unless => lambda {|u| u.password.nil? },:on => :update
  # attr_accessible :title, :body

  def generate_password_reset_code
    self.reset_password_token = Digest::SHA2.hexdigest(Time.now.to_s)
    self.reset_password_sent_at = Time.now
    save
  end
end
