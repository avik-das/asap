require 'asap/fetch_context'

def Asap *args, &blk
  context = Asap::FetchContext.new
  context.instance_exec *args, &blk
  context.join
  context.result
end
