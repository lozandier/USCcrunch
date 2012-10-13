class Tweet < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id,:receiver_id, :body,:document
  validates :body, :presence => true
  has_attached_file :document, :styles => {:medium => "300x300>", :thumb => "100x100>"}
end
