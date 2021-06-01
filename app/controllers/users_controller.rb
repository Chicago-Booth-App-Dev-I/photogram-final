class UsersController < ApplicationController

def index
  @list_of_users = User.all.order(:username)
  render({:template => "/users/index.html.erb"})
end 

end