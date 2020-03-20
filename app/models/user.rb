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

  has_many :country_hit_lists, :class_name => "CountryHitList", :foreign_key => "user_id", :dependent => :destroy
  has_many :country_visits, :class_name => "CountryVisit", :foreign_key => "user_id", :dependent => :destroy

  has_many :received_follow_requests, :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy
    has_many(:accepted_recieved_follow_requests, -> { where({ :status => "accepted" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })
    has_many(:pending_recieved_follow_requests, -> { where({ :status => "pending" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })
    has_many(:declined_recieved_follow_requests, -> { where({ :status => "declined" }) }, { :class_name => "FollowRequest", :foreign_key => "recipient_id" })

  has_many :sent_follow_requests, :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy
    has_many(:accepted_sent_follow_requests, -> { where({ :status => "accepted" }) }, { :class_name => "FollowRequest", :foreign_key => "sender_id" })

  has_many :leaders, :through => :accepted_sent_follow_requests, :source => :recipient
  has_many :followers, :through => :accepted_recieved_follow_requests, :source => :sender
    has_many :pending_followers, :through => :pending_recieved_follow_requests, :source => :sender

  has_many :feed_visits, :through => :leaders, :source => :country_visits
  has_many :discover_hit_list, :through => :leaders, :source => :country_hit_lists

  def country_count
    return self.country_visits.count
  end
end
