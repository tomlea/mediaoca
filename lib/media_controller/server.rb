require 'drb'
module MediaController
  class Server
    MPLAYER="/usr/bin/mplayer"
  
    def initialize()
      @semaphore = Mutex.new
      @mplayer = nil
    end
  
    def play(file, options = "-fs")
      lock do
        _stop
        @mplayer = IO.popen("#{MPLAYER} -slave #{options} '#{file}'")
        @currently_playing = file
      end
    end
  
    def stop
      lock do
        _stop
      end
    end
  
    def currently_playing
      lock do
        @currently_playing
      end
    end
  
  private
    def lock(&block)
      @semaphore.synchronize(&block)
    end
  
    def _stop
      return unless @mplayer
      Process.kill("TERM", @mplayer.pid)
      Process.waitpid(@mplayer.pid)
      @mplayer = nil
      @currently_playing = nil
    end
  end
end

if File.expand_path($0) == File.expand_path(__FILE__)
  DRb.start_service("drbunix:/tmp/mplayer.sock", MediaController::Server.new())
  DRb.thread.join
end
