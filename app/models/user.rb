class User < ActiveRecord::Base
  #  extend FriendlyId
  #  friendly_id :username, use: :slugged
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me,:username,:avatar,:school_id,:bio,:state,:major,:website
  has_many :tweets, :dependent => :destroy, :order => "created_at DESC"
  has_attached_file :avatar, :styles => {:medium => "300x300>", :thumb => "100x100>"}, :default_url => "/assets/avatar.png"
  validates :username,:presence => true
  has_many :sent_follows, :class_name => "Follow", :foreign_key => :user_id, :dependent => :destroy
  has_many :received_follows, :class_name => 'Follow', :foreign_key => :receiver_id,:dependent => :destroy
  has_many :favorites, :dependent => :destroy

  def favorite_for(tweet)
    self.favorites.find_by_tweet_id(tweet)
  end
end
