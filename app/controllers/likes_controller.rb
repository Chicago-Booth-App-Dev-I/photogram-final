class LikesController < ApplicationController
  def index
    matching_likes = Like.all

    @list_of_likes = matching_likes.order({ :created_at => :desc })

    render({ :template => "likes/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_likes = Like.where({ :id => the_id })

    @the_like = matching_likes.at(0)

    render({ :template => "likes/show.html.erb" })
  end

  def create
    photo_id = params.fetch("path_id")
    the_photo = Photo.where(:id => photo_id).at(0)
    photo_owner = the_photo.owner

    the_like = Like.new
    the_like.fan_id = photo_owner.id
    the_like.photo_id = params.fetch("path_id")

    if the_like.valid?
      the_like.save
      redirect_to("/photos/#{photo_id}", { :notice => "Like created successfully." })
    else
      redirect_to("/photos/#{photo_id}", { :notice => "Like failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_like = Like.where({ :id => the_id }).at(0)

    the_like.fan_id = params.fetch("query_fan_id")
    the_like.photo_id = params.fetch("query_photo_id")

    if the_like.valid?
      the_like.save
      redirect_to("/likes/#{the_like.id}", { :notice => "Like updated successfully."} )
    else
      redirect_to("/likes/#{the_like.id}", { :alert => "Like failed to update successfully." })
    end
  end

  def destroy
    the_photo_id = params.fetch("path_id")
    the_like = Like.where({ :photo_id => the_photo_id }).where({:fan_id => @current_user.id }).at(0)

    the_like.destroy

    redirect_to("/photos/#{the_photo_id}", { :notice => "Like deleted successfully."} )
  end
end
