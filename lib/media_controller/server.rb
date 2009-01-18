require 'drb'

class Server
  MPLAYER="/opt/local/bin/mplayer"
  
  def initialize()
    @semaphore = Mutex.new
    @mplayer = nil
  end
  
  def start_playing(file, options = "-fs")
    @semaphore.synchronize do
      _stop
      @mplayer = IO.popen("#{MPLAYER} #{options} '#{file}'")
    end
  end
  
  def stop
    @semaphore.synchronize do
      _stop
    end
  end
  
private
  def _stop
    return unless @mplayer
    Process.kill("TERM", @mplayer.pid)
    Process.waitpid(@mplayer.pid)
    @mplayer = nil
  end
end

DRb.start_service("drbunix:/tmp/mplayer.sock", Server.new())
DRb.thread.join
