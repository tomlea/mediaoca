require 'drb'

module MediaController
  class Server
    MPLAYER="/usr/bin/mplayer"
    # MPLAYER="/opt/local/bin/mplayer"
  
    def initialize()
      @semaphore = Mutex.new
      @mplayer = nil
    end
  
    def play(file, options = ["-fs"])
      lock do
        _stop
        @mplayer = fork do
          ops = [MPLAYER, "-slave"] + options + [file]
          exec(*ops)
          exit
        end
        
        puts "Started #{@mplayer} playing #{file}"
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
      p "Killing: #{@mplayer}"
      return unless @mplayer
      Process.kill("TERM", @mplayer)
      Process.waitpid(@mplayer)
      @mplayer = nil
      @currently_playing = nil
    end
  end
end

