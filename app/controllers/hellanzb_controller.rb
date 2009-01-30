class HellanzbController < ApplicationController
  before_filter :hellanzb, :except => :start_server

  def index
    load_status

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
  rescue Errno::ECONNREFUSED
    render :action => "server_down"
  end
  
  def start_server
    if Hellanzb.start_server
      flash[:notice] = "Kindly asked the server to start."
    else
      flash[:notice] = "Server does not seem to have come up."      
    end
    redirect_to :back
  end
  
  def pause_server
    load_status
    if @current_download_paused
      hellanzb.continue
    else
      hellanzb.pause
    end
    
    respond_to do |want|
      want.html { redirect_to :action => :index }
      want.js {
        index
      }
    end
  end
  
private
  def load_status
    @status = hellanzb.status
    if current_download = @status["currently_downloading"].first
      @current_download_name = current_download["nzbName"]
      @current_download_size = current_download["total_mb"]
    end
    @current_download_eta  = simple_time(@status["eta"])
    @percent_complete = @status["percent_complete"]
    @rate = @status["rate"]
    @current_download_paused = @status["is_paused"]
  end

  def simple_time(seconds)
    mins, seconds = seconds.divmod(60)
    hours, mins = mins.divmod(60)
    [hours,mins,seconds].map{|v| "%02i" % [v] }.join(":")
  end
end