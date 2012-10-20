class Student < ActiveRecord::Base
  attr_accessible :email, :school_id,:name,:first_name,:date_of_birth
  belongs_to :school_admin
  #  before_validation :email_valide
  #
  #  def email_valide
  #    email = self.email.split(/\s+,\s+/)
  #    email.each do |email|
  #      self.errors.add(:email, "invalid email") unless email=~ /([^\s]+)@([^\s]+)/
  #    end
  #    self.email = email.join(",")
  #  end
  #validates_uniqueness_of :email
end
