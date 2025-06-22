# frozen_string_literal: true

module Nunes
  class RequestsController < ApplicationController
    def index
      @requests = Span.requests.order(created_at: :desc).map do |span|
        Presenters::Request.new(span)
      end
    end

    def show
      spans = Span.where(trace_id: params[:id])
      render(:not_found, status: :not_found) && return if spans.blank?

      spans = spans.map { |span| Presenters::Span.new(span) }
      @waterfall = Presenters::Waterfall.new(spans)
    end
  end
end
