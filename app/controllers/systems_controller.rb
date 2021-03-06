require "timeout"
require "ostruct"
class SystemsController < ApplicationController
  def shutdown
    system("sudo /sbin/shutdown -h now")
    flash[:notice] = "System should be going down now."
    redirect_to :action => "show"
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
    redirect_to :action => "show"
  end

  def scan_for_new_media
    Episode.scan_for_episodes!
    flash[:notice] = "Scan complete."
    redirect_to :action => "show"
  end

  def show
    @disk_usage = disk_usage
  end

private
  def disk_usage
    Episode.media_paths.map{|mp|
      `/bin/df -m #{mp}`.chomp.split("\n").last.split(/ +/)
    }.uniq{|parts| parts.first }.map{|(path, total, used, available, usage, partition)|
      OpenStruct.new(:path => partition, :total => total.to_i, :used => used.to_i, :available => available.to_i)
    }
  rescue
    []
  end
end
