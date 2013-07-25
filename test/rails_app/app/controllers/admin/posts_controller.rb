class Admin::PostsController < ApplicationController
  # Use fake post for controller as I don't want active record to mingle here.
  Post = Struct.new(:title)

  def index
    @posts = [
      Post.new('First'),
      Post.new('Second'),
    ]
    respond_to do |format|
      format.html { render }
      format.json { render :json => @posts }
    end
  end

  def new
    head :forbidden
  end
end
