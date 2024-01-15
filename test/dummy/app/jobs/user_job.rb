# frozen_string_literal: true

class UserJob < ApplicationJob
  queue_as :default

  def perform
    User.all.load
  end
end
