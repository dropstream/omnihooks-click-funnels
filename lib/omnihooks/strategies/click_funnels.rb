require 'omnihooks'
require 'multi_json'

module OmniHooks
  module Strategies
    class ClickFunnels
      include OmniHooks::Strategy
      option :name, 'click-funnels'

      event do
        raw_info
      end

      event_type do
        entity = raw_info.keys.first
        "#{entity}_#{raw_info['event']}"
      end

      private

      def raw_info
        @raw_info ||= MultiJson.decode(request.body)
      end
    end
  end
end