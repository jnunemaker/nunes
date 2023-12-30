module Nunes
  class RequestsController < ApplicationController
    def index
      request_ids = Nunes.adapter.requests_index.first(30)
      @requests = Nunes.adapter.get_multi(request_ids).map { |_, span|
        Middleware::Presenters::Request.new(span)
      }
    end

    def show
      span = Nunes.adapter.get(params[:id])
      @request = Middleware::Presenters::Request.new(span)
    end
  end
end
