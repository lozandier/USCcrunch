class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => 'User'
  attr_accessible :user_id,:receiver_id, :body,:document,:reply,:tweet_id
  validates :body, :presence => true
  has_attached_file :document, :styles => {:medium => "300x300>", :thumb => "100x100>"}
  has_one :favorite, :dependent => :destroy
end
