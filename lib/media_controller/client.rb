require "drb"

module MediaController
  class Client
    def initialize(uri = "drbunix:/tmp/mplayer.sock")
      @mplayer = DRbObject.new(nil, uri)
    end
  
    def method_missing(method, *args)
      MediaController::CONTROLLER.connect do
        begin
          @mplayer.send(method, *args)
        rescue
          raise Errno::ECONNREFUSED, "Connection refused"
        end
      end
    end    
  end
end
