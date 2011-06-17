module Asap
  module Netty
    class HttpResponseHandler < org.jboss.netty.channel.SimpleChannelUpstreamHandler
      attr_reader :callback

      def initialize(callback)
        super()
        @callback = callback
      end

      def messageReceived(ctxt, e)
        response = e.get_message
        if response.get_status.get_code == 200
          callback.call(response.get_content.to_string(org.jboss.netty.util.CharsetUtil::UTF_8))
        else
          raise "Request failed with #{response.get_status.get_code}"
        end
      end
    end
  end
end
