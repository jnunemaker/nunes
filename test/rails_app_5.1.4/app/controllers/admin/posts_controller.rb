class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all

    respond_to do |format|
      format.html { render }
      format.json { render :json => @posts }
    end
  end

  def new
    head :forbidden
  end
end
