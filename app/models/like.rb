# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :integer
#  photo_id   :integer
#
class Like < ApplicationRecord

validates(:photo_id, { :presence => true })
validates(:fan_id, { :presence => true })

belongs_to(:user, { :required => false, :class_name => "User", :foreign_key => "fan_id" })

belongs_to(:photo, { :required => false, :class_name => "Photo", :foreign_key => "photo_id", :counter_cache => true })


end
