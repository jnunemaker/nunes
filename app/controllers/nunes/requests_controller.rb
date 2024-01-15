# frozen_string_literal: true

module Nunes
  class RequestsController < ApplicationController
    def index
      @requests = Nunes.adapter.all.map do |span|
        Presenters::Request.new(span)
      end
    end

    def show
      spans = Nunes.adapter.get(params[:id])
      render(:not_found, status: :not_found) && return if spans.blank?

      spans = spans.map { |span| Presenters::Span.new(span) }
      @waterfall = Presenters::Waterfall.new(spans)
    end
  end
end
