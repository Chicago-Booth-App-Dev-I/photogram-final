class UsersController < ApplicationController
skip_before_action(:force_user_sign_in, { :only => [:index] })

def index
  @list_of_users = User.all.order(:username)
  render({:template => "/users/index.html.erb"})
end 

def show
render({:template => "/users/show.html.erb"})
end

end