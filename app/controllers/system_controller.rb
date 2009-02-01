require "timeout"
class SystemController < ApplicationController
  def sleep_system
    fork do
      logger.info "Fork for sleep started, hanging for 2."
      sleep 2
      Timeout.timeout(5){
        logger.info "Issuing sleep command."
        v = system("/usr/bin/sudo" "pmi" "action" "sleep")
        logger.info "Sleep command returned #{v} (#{$?})."
      }
      exit
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
