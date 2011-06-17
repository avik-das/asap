require 'asap/netty'

module Asap
  class FetchContext
    def initialize
      @result = []
      @semaphore = java.util.concurrent.Semaphore.new(0)
    end

    def get(url, &blk)
      target_index = @result.size
      @result << nil
      Asap::Netty.get(url) do |result|
        if blk
          Thread.new do
            nested = Asap(result, &blk)
            @result[target_index] = [result, nested]
            @semaphore.release
          end
        else
          @result[target_index] = result
          @semaphore.release
        end
      end
    end

    def join
      @semaphore.acquire(@result.size)
    end

    attr_reader :result
  end
end
