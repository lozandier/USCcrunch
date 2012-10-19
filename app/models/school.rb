require 'digest/sha2'
class School < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
    :recoverable
  attr_accessible :school_name, :email,:first_name,:last_name,:password,:password_confirmation,:reset_password_token
  validates :school_name, :email,:first_name,:last_name, :presence => true
  has_many :students, :dependent => :destroy
  has_many :teachers, :dependent => :destroy
  validates :password, :presence =>true,
    :length => { :minimum => 6, :maximum => 15 },
    :confirmation =>true, :unless => lambda {|u| u.password.nil? },:on => :update
  validates_uniqueness_of :school_name, :email


  def generate_password_reset_code
    self.reset_password_token = Digest::SHA2.hexdigest(Time.now.to_s)
    self.reset_password_sent_at = Time.now
    save
  end
end