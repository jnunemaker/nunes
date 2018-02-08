module Spam
  class DetectorJob < ApplicationJob
    queue_as :default

    def perform(*posts)
      posts.detect do |post|
        post.title.include?("Buy watches cheap!")
      end
    end
  end
end
