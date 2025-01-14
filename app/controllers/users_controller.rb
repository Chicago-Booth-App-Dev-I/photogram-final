class UsersController < ApplicationController
#skip_before_action(:force_user_sign_in, { :only => [:index] })

def index
  @list_of_users = User.all.order(:username)
  render({:template => "/users/index.html.erb"})
end 

def show
  user = params.fetch("path_id")
  @the_user = User.where(:username => user).at(0)
  render({:template => "/users/show.html.erb"})
end

def feed
  user = params.fetch("path_id")
  @the_user = User.where(:username => user).at(0)

  user_followers = @the_user.followers

  render({:template => "/users/feed.html.erb"})
end

def discover
  user = params.fetch("path_id")
  @the_user = User.where(:username => user).at(0)

  user_followers = @the_user.followers

  render({:template => "/users/discover.html.erb"})
end

def not_permitted
  user = params.fetch("path_id")
  @the_user = User.where(:username => user).at(0)
  redirect_to("/", { :alert => "You are not authorized for that." })
end

end