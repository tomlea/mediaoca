class SystemController < ApplicationController
  def sleep_system
    fork do
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
    v = system("/usr/bin/media_controller", "restart")
    logger.info "Issued media_controller restart."
    if $?.success? and v
      flash[:notice] = "Media controller restart issued"
    else
      flash[:notice] = "Media controller restart issued, but seemed to fail."
    end
    redirect_to :action => "index"
  end
end
