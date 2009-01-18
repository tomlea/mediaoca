require 'drb'

class Server
  MPLAYER="/opt/local/bin/mplayer"
  
  def initialize()
    @semaphore = Mutex.new
    @mplayer = nil
  end
  
  def start_playing(file, options = "-fs")
    lock do
      _stop
      @mplayer = IO.popen("#{MPLAYER} #{options} '#{file}'")
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

DRb.start_service("drbunix:/tmp/mplayer.sock", Server.new())
DRb.thread.join
