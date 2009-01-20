require 'rubygems'
gem 'FooBarWidget-daemon_controller'
require 'daemon_controller'

require 'drb'

require File.join(File.dirname(__FILE__), *%w[media_controller server])
require File.join(File.dirname(__FILE__), *%w[media_controller client])

module MediaController
  CONTROLLER = DaemonController.new(
     :identifier    => 'MediaController Server',
     :start_command => "ruby #{__FILE__}",
     :ping_command  => lambda{ raise "Not Connected" unless File.exists? "/tmp/mplayer.sock" },
     :pid_file      => "media_controller_server.pid",
     :log_file      => "media_controller_server.log"
  )
end


if File.expand_path($0) == File.expand_path(__FILE__)
  fork do
    Process.setsid
    exit if fork
    File.open("media_controller_server.pid", "w"){|f| f << Process.pid }
    DRb.start_service("drbunix:/tmp/mplayer.sock", MediaController::Server.new())
    DRb.thread.join
  end
  puts "Started"
  exit
end
