class BoomJob < ApplicationJob
  queue_as :default

  def perform
    raise
  end
end
