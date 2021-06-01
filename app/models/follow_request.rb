# == Schema Information
#
# Table name: follow_requests
#
#  id           :integer          not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
class FollowRequest < ApplicationRecord

belongs_to(:sender, { :required => false, :class_name => "User", :foreign_key => "sender_id", :counter_cache => :sent_follow_requests_count })

belongs_to(:recipient, { :required => false, :class_name => "User", :foreign_key => "recipient_id", :counter_cache => :received_follow_requests_count })


end
