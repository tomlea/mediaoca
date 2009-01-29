class HellanzbController < ApplicationController
  def index
    @status = hellanzb.status
    if current_download = @status["currently_downloading"].first
      @current_download_name = current_download["nzbName"]
      @current_download_size = current_download["total_mb"]
      @current_download_eta  = simple_time(@status["eta"])
      @percent_complete = @status["percent_complete"]
      @rate = @status["rate"]
    end
    @current_download_paused = @status["is_paused"]
    
    @enqueue = Enqueue.new()
    
    respond_to do |want|
      want.html
      want.js
    end
  end

  def enqueue
    @enqueue = Enqueue.new(params[:enqueue])
    if @enqueue.newzbin_id
      hellanzb.enqueuenewzbin(@enqueue.newzbin_id)
      flash[:notice] = "Enqueued NZB id #{@enqueue.newzbin_id}"
    end
    redirect_to :action => :index
  end
  
  def hellanzb
    @hellanzb ||= Hellanzb.new
  end
  
private
  def simple_time(seconds)
    mins, seconds = seconds.divmod(60)
    hours, mins = mins.divmod(60)
    [hours,mins,seconds].map{|v| "%02i" % [v] }.join(":")
  end
end