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
    if request.method == :put
      @enqueue = Enqueue.new(params[:enqueue])
      if @enqueue.newzbin_id
        hellanzb.enqueuenewzbin(@enqueue.newzbin_id)
        flash[:notice] = "Enqueued NZB id #{@enqueue.newzbin_id}"
      end
      redirect_to :action => :index
    else
      @enqueue = Enqueue.new(params[:enqueue])
    end
  end

  def force_download
    hellanzb.force(params[:nzbid])
    respond_to do |want|
      want.html { redirect_to :action => :index }
      want.js {
        index
      }
    end
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
  def hellanzb
    @hellanzb ||= Hellanzb.client
  rescue Hellanzb::ServerDown
    render :action => "server_down"
  end

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
