module Nunes
  class RequestsController < ApplicationController
    def index
      @requests = Nunes.adapter.all.map { |span|
        Middleware::Presenters::Request.new(span)
      }
    end

    def show
      span = Nunes.adapter.get(params[:id])
      @request = Middleware::Presenters::Request.new(span)
    end
  end
end
