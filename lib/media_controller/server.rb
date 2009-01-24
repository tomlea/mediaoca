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
        kill_mplayer!
        rd, wr = IO.pipe
        
        @mplayer = fork do
          STDIN.reopen(rd)
          ops = [MPLAYER, "-slave"] + options + [file]
          exec(*ops)
        end
        
        Process::detach(@mplayer)
        @mplayer_pipe = wr
        puts "Started #{@mplayer} playing #{file}"
        @currently_playing = file
        update_currently_playing_status!
      end
    end

    def pause
      lock do
        if @mplayer
          @mplayer_pipe.puts "p"
          @paused = !@paused
        end
      end
    end

    def stop
      lock do
        kill_mplayer!
      end
    end

    def currently_playing
      lock do
        update_currently_playing_status!
        @currently_playing
      end
    end

  private
    def update_currently_playing_status!
      clean_up_all_traces_of_mplayer! unless mplayer_is_running?
    end

    def clean_up_all_traces_of_mplayer!
      @currently_playing = nil
      @paused = false
      @mplayer_pipe.close rescue nil
      @mplayer = nil
    end

    def mplayer_is_running?
      @mplayer and `ps x -p #{@mplayer}`.lines.count > 1
    end

    def lock(&block)
      @semaphore.synchronize(&block)
    end

    def kill_mplayer!
      return unless @mplayer
      Process.kill("TERM", @mplayer)
      clean_up_all_traces_of_mplayer!
    end

  end
end
