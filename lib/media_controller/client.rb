require "drb"

module MediaController
  class Client
    def initialize(uri = "drbunix:/tmp/mplayer.sock")
      @mplayer = DRbObject.new(nil, uri)
    end
  
    def method_missing(method, *args)
      @mplayer.send(method, *args)
    end    
  end
end
