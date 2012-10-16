class Invitation < ActiveRecord::Base
  attr_accessible :user_id, :email,:body,:username
  belongs_to :user

  validates :email, :presence => true
  before_validation :email_valide

  def email_valide
    email = self.email.split(/\s+,\s+/)
    email.each do |email|
      self.errors.add(:email, "invalid email") unless email=~ /([^\s]+)@([^\s]+)/
    end
    self.email = email.join(",")
  end


end
