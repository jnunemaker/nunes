# frozen_string_literal: true

module Nunes
  class ApplicationController < ActionController::Base
    around_action :untrace_request

    private

    def untrace_request
      Nunes.untraced { yield }
    end
  end
end
