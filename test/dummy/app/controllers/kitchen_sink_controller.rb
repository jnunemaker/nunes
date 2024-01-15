class KitchenSinkController < ApplicationController
  def boom
    raise "boom"
  end

  def boom_job
    BoomJob.perform_later
    render plain: "ok"
  end

  def enqueue_job
    UserJob.perform_later
    render plain: "ok"
  end
end
