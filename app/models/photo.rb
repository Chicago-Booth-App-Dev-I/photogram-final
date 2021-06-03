# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :string
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

validates(:owner_id, { :presence => true })


belongs_to(:owner, { :required => false, :class_name => "User", :foreign_key => "owner_id", :counter_cache => :own_photos_count })

has_many(:likes, { :class_name => "Like", :foreign_key => "photo_id", :dependent => :destroy })

has_many(:comments, { :class_name => "Comment", :foreign_key => "photo_id", :dependent => :destroy })

has_many(:fans, { :through => :likes, :source => :user })

has_many(:followers, { :through => :owner, :source => :recipients })

has_many(:fan_followers, { :through => :fans, :source => :recipients })

def list_of_likes
    the_photo_id = self.id
    list_of_likes = Like.where(:photo_id => the_photo_id)
    
    likes_ids = Array.new

    list_of_likes.each do |a_like|
    likes_ids.push(a_like.fan_id)
    end

    return likes_ids
  
end


end
