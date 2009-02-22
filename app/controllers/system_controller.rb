require "timeout"
require "ostruct"
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

  def shutdown_system
    system("sudo /sbin/shutdown -h now")
    flash[:notice] = "System should be going down now."
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

  def index
    @disk_usage = Episode.media_paths.map{|mp|
      `/bin/df -m #{mp}`.chomp.split("\n").last.split(/ +/)
    }.uniq{|parts| parts.first }.map{|(path, total, used, available)|
      OpenStruct.new(:path => path, :total => total.to_i, :used => used.to_i, :available => available.to_i)
    }
  end
end
