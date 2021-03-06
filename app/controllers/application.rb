# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '02007f33c5329276593e99411e45c8b5'

  before_filter :fetch_currently_playing, :except => [:play, :stop, :pause]
  before_filter :authenticate
private

  def authenticate
    return true if request.remote_ip =~ /^192\.168\.|^127.0.0.1$|^0.0.0.0$/
    authenticate_or_request_with_http_basic("Mediaoca") do |username, password|
      password_hash = Digest::SHA1.hexdigest(password)
      passwds = YAML.load(File.open(File.join(Rails.root, "config", "authentication.yml")))
      passwds[username] and passwds[username] == password_hash
    end
  end

  layout :select_layout
  def select_layout
    "master"
  end

  def fetch_currently_playing
    if currently_playing_file = media_controller.currently_playing
      @currently_playing_episode = Episode.for(currently_playing_file)
    else
      @currently_playing_episode = nil
    end
  rescue DRb::DRbConnError
    @notice =        "Could not connect to the media_controller daemon. "+
                     "Start it with <code>media_controller start</code>."
  end

  def media_controller
    @media_controller ||= MediaController::Client.new
  end
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end
