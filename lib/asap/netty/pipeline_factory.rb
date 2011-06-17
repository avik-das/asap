module Asap
  module Netty
    class PipelineFactory
      include org.jboss.netty.channel.ChannelPipelineFactory

      attr_reader :callback

      def initialize(callback)
        @callback = callback
      end

      def get_pipeline
        org.jboss.netty.channel.Channels.pipeline.tap do |pipeline|
          pipeline.add_last("codec", org.jboss.netty.handler.codec.http.HttpClientCodec.new)
          pipeline.add_last("handler", Asap::Netty::HttpResponseHandler.new(callback))
        end
      end
    end
  end
end
