require 'asap/netty'

require 'open-uri'

def Asap &blk
  Asap.execute blk
end

module Asap
  class << self
    def execute blk, *args
      context = Asap::FetchContext.new
      context.instance_exec *args, &blk
      context.join
      context.result
    end
  end

  class FetchContext
    def initialize
      @result = []
      @index   = 0
    end

    def get url, &blk
      #@result[@index] = open(url) {|r| r.read}

      res = open(url) {|r| r.read}
      if block_given?
        nested = Asap.execute blk, res
        res = [res, nested]
      end

      @result[@index] = res
      @index += 1
    end

    def join
      # no threading yet
    end

    attr_reader :result
  end
end
