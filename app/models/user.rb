# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  private         :boolean
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many :country_hit_lists, :dependent => :destroy
  has_many :country_visits, :dependent => :destroy

  has_many :received_follow_requests, :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy
    has_many(:accepted_recieved_follow_requests, -> { where({ :status => "accepted" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })
    has_many(:pending_recieved_follow_requests, -> { where({ :status => "pending" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })
    has_many(:declined_recieved_follow_requests, -> { where({ :status => "declined" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })

  has_many :sent_follow_requests, :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy
    has_many(:accepted_sent_follow_requests, -> { where({ :status => "accepted" }) }, { :class_name => "FollowRequest", :foreign_key => "sender_id" })

  has_many :leaders, :through => :accepted_sent_follow_requests, :source => :recipient
  has_many :followers, :through => :accepted_recieved_follow_requests, :source => :sender
    has_many :pending_followers, :through => :pending_recieved_follow_requests, :source => :sender
end
