# frozen_string_literal: true

require_relative 'base'

module Nunes
  module Presenters
    class Span < Base
      def span
        __getobj__
      end

      def title
        case name
        when 'sql.active_record'
          span[:name].presence || name
        else
          name
        end
      end

      def preview
        case name
        when 'process_action.action_controller'
          span[:controller] + '#' + span[:action]
        when 'sql.active_record'
          span[:sql]
        else
          ''
        end
      end
    end
  end
end
