class School < ActiveRecord::Base
  attr_accessible :school_name, :email
  validates :school_name, :email, :presence => true
  has_many :students, :dependent => :destroy
  has_many :teachers, :dependent => :destroy

  validates_uniqueness_of :school_name, :email
end
