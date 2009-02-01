require "timeout"
class SystemController < ApplicationController
  def sleep_system
    fork do
      sleep 2
      puts "Issuing sleep command."
      system("/usr/bin/sudo /usr/sbin/pmi action sleep")
      exit $?
    end
    flash[:notice] = "Sent system to sleep in 2."
    redirect_to :action => "index"
  end
  
  def restart_media_controller
    Dir.chdir(ENV["HOME"]) do
      system("/usr/bin/media_controller", "restart")
      logger.info "Issued media_controller restart, while working from #{Dir.pwd}"
    end
    if $?.success?
      flash[:notice] = "Media controller restart issued"
    else
      flash[:notice] = "Media controller restart issued, but seemed to fail."
    end
    redirect_to :action => "index"
  end
end
