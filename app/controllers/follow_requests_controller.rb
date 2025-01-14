class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    user_followers = @current_user.followers
    recipient = User.where(:id => params.fetch("path_id")).at(0)
    recipient_followers = recipient.followers
    
    if recipient.private == true
    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = @current_user.id
    the_follow_request.recipient_id = recipient.id
    the_follow_request.status = "pending"
      if the_follow_request.valid?
        the_follow_request.save
        redirect_to("/", { :notice => "Follow request sent." })
      else
        redirect_to("/", { :alert => "Error. Failed to creat follow request." })
      end
    else
    the_follow_request = FollowRequest.new
    the_follow_request.sender_id = @current_user.id
    the_follow_request.recipient_id = recipient.id
    the_follow_request.status = "accepted"
      if the_follow_request.valid?
        the_follow_request.save
        redirect_to("/users/#{recipient.username}", { :notice => "You are now following #{recipient.username}." })
      else
        redirect_to("/", { :alert => "Follow request failed to create successfully." })
      end    
    end 
  end

  def accept_follow
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({:sender_id => the_id }).where({:recipient_id => @current_user.id}).at(0)

    the_follow_request.sender_id = the_id
    the_follow_request.recipient_id = @current_user.id
    the_follow_request.status = "accepted"

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/users/#{@current_user.username}", { :notice => "Accepted follow request."} )
    else
      redirect_to("/users/#{@current_user.username}", { :alert => "Follow request failed to update successfully." })
    end
  end

  def reject_follow
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({:sender_id => the_id }).where({:recipient_id => @current_user.id}).at(0)

    the_follow_request.sender_id = the_id
    the_follow_request.recipient_id = @current_user.id
    the_follow_request.status = "rejected"
    the_follow_request.save
    
    redirect_to("/users/#{@current_user.username}", { :notice => "Rejected follow request."} )

  end

  def destroy
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :recipient_id => the_id }).where({:sender_id => @current_user.id }).at(0)

    the_follow_request.destroy

    redirect_to("/", { :notice => "Successfully unfollowed #{User.where(:id => the_id).at(0).username}."} )
  end
end
