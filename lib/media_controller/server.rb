require 'drb'

module MediaController
  class Server
    MPLAYER=`which mplayer`.chomp
  
    attr_reader :paused
  
    def initialize()
      @semaphore = Mutex.new
      @mplayer = nil
      @paused = false
    end
  
    def play(file, options = ["-fs"])
      lock do
        _stop
        @paused = false
        rd, wr = IO.pipe
        @mplayer = fork do
          STDIN.reopen(rd)
          ops = [MPLAYER, "-slave"] + options + [file]
          exec(*ops)
        end

        @mplayer_pipe = wr
        
        puts "Started #{@mplayer} playing #{file}"
        @currently_playing = file
      end
    end
  
    def pause
      lock do
        @mplayer_pipe.puts "p" if @mplayer
        @paused = !@paused
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

