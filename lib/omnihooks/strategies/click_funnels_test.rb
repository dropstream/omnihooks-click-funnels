require 'omnihooks'
require 'multi_json'

module OmniHooks
  module Strategies

    #
    # When creating a WebHook in ClickFunnels, their system will make an HTTP POST request to the URL funnel_webhooks/test in an effort to validate 
    #
    # @author Karl Falconer <karl@getdropstream.com>
    #
    class ClickFunnelsTest
      include OmniHooks::Strategy
      option :name, 'funnel_webhooks/test'

      event do
        raw_info
      end

      event_type do
        raw_info['event']
      end

      private

      def raw_info
        @raw_info ||= MultiJson.decode(request.body)
      end
    end
  end
end