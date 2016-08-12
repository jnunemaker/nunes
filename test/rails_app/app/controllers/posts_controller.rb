class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def some_data
    data = Rails.root.join('app', 'assets', 'images', 'rails.png').read
    send_data data, filename: 'rails.png', type: 'image/png'
  end

  def some_file
    send_file Rails.root.join('app', 'assets', 'images', 'rails.png')
  end

  def some_redirect
    redirect_to posts_path
  end

  def some_boom
    raise "boom!"
  end
end
