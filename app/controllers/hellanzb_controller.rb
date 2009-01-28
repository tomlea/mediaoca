class HellanzbController < ApplicationController
  def index
    hellanzb = Hellanzb.new
    @status = hellanzb.status
    if current_download = @status["currently_downloading"].first
      @current_download_name = current_download["nzbName"]
      @current_download_size = current_download["total_mb"]
      @current_download_eta  = simple_time(@status["eta"])
      @percent_complete = @status["percent_complete"]
      @rate = @status["rate"]
    end
    @paused = @status["is_paused"]
    
    respond_to do |want|
      want.html
      want.js
    end
  end
  
  def simple_time(seconds)
    mins, seconds = seconds.divmod(60)
    hours, mins = mins.divmod(60)
    [hours,mins,seconds].map{|v| "%02i" % [v] }.join(":")
  end
end