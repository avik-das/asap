require 'asap/netty'

require 'open-uri'

def Asap &blk
  context = Asap::FetchContext.new
  context.instance_eval &blk
  context.join
  context.result
end

module Asap
  class FetchContext
    def initialize
      @result = []
      @index   = 0
    end

    def get url
      @result[@index] = open(url) {|r| r.read}
      @index += 1
    end

    def join
      # no threading yet
    end

    attr_reader :result
  end
end
