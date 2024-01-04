module Nunes
  class RequestsController < ApplicationController
    def index
      @requests = Nunes.adapter.all.map do |span|
        Middleware::Presenters::Request.new(span)
      end
    end

    def show
      spans = Nunes.adapter.get(params[:id])
      if spans.blank?
        render :not_found, status: :not_found
        return
      end

      root = spans.detect { |span| span.parent_id.nil? } || raise("No root span found for #{params[:id]}")
      @spans = spans.sort_by!(&:started_at).map do |span|
        Middleware::Presenters::Request.new(span)
      end

      @request = Middleware::Presenters::Request.new(root)
    end
  end
end
