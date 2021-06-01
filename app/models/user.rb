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


end
