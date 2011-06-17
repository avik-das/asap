require 'asap/netty'

module Asap
  class FetchContext
    def initialize
      @result = []
      @index  = 0
    end

    def get(url, &blk)
      res = Asap::Netty.get(url)

      if block_given?
        nested = Asap(res, &blk)
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
