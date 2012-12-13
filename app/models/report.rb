class Report < ActiveRecord::Base
  attr_accessible :user_id,:receiver_id,:status, :body
  belongs_to :user
  validates :body, :presence => true
end
