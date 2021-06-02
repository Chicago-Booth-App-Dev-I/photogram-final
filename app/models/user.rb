# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  comments_count                 :integer
#  email                          :string
#  likes_count                    :integer
#  own_photos_count               :integer
#  password_digest                :string
#  private                        :boolean
#  received_follow_requests_count :integer
#  sent_follow_requests_count     :integer
#  username                       :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class User < ApplicationRecord
  validates(:username, { :presence => true })
  validates(:username, { :uniqueness => true })
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password

  has_many(:likes, { :class_name => "Like", :foreign_key => "fan_id", :dependent => :destroy })
  
  has_many(:comments, { :class_name => "Comment", :foreign_key => "author_id", :dependent => :destroy })
  
  has_many(:sent_follow_requests, { :class_name => "FollowRequest", :foreign_key => "sender_id", :dependent => :destroy })

  has_many(:received_follow_requests, { :class_name => "FollowRequest", :foreign_key => "recipient_id", :dependent => :destroy })

  has_many(:own_photos, { :class_name => "Photo", :foreign_key => "owner_id", :dependent => :destroy })

  has_many(:recipients, { :through => :sent_follow_requests, :source => :recipient })

  has_many(:received_follow_requests, { :through => :received_follow_requests, :source => :sender })

  has_many(:liked_photos, { :through => :likes, :source => :photo })

  has_many(:feed, { :through => :recipients, :source => :own_photos })

  has_many(:activity, { :through => :recipients, :source => :liked_photos })

  def followers
    user_id = self.id
    list_of_followers = FollowRequest.where(:recipient_id => user_id).where(:status => "accepted").order(:recipient_id => :asc)
    
    followers_ids = Array.new

    list_of_followers.each do |a_follower|
    followers_ids.push(a_follower.sender_id)
    end

    return followers_ids

  end

  def following
    user_id = self.id
    following_list = FollowRequest.where(:sender_id => user_id).where(:status => "accepted").order(:recipient_id => :asc)
    
    following_ids = Array.new

    following_list.each do |a_following|
    following_ids.push(a_following.recipient_id)
    end

    return following_ids 
  end 
  
  def request_pending
    user_id = self.id
    pending_requests = FollowRequest.where(:sender_id => user_id).where(:status => "pending")

    pending_ids = Array.new

    pending_requests.each do |pending|
    pending_ids.push(pending.recipient_id)
    end

    return pending_ids 
  end

end
