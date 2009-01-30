require 'timeout'
class Hellanzb
  HELLA_URL = "http://hellanzb:changeme@localhost:8760"
  HELLA_BIN = `which hellanzb`.chomp
  
  require 'xmlrpc/client'
  attr_reader :config_file, :prefix_dir, :queue, :dest_dir

  def initialize 
    begin
      @server ||= XMLRPC::Client.new2(HELLA_URL)
      # Create a method accessor for each of the server methods
      @server.call('system.listMethods').each do |m|
        if m.eql?("down") or m.eql?("up") or m.eql?("dequeue") or 
           m.eql?("last") or m.eql?("next") or m.eql?("force") or
           m.eql?("enqueue") or m.eql?("enqueueurl") or m.eql?("enqueuenewzbin")

          self.class.send(:define_method, m) {|id| @server.call(m,id)} 
        else
          self.class.send(:define_method, m) {@server.call(m)}
        end
      end

      status.each do |s|
        if s[0].eql?('currently_downloading') or 
           s[0].eql?('currently_processing')then
          self.class.send(:define_method, s[0]) {@server.call("status")[s[0]][0]}
        else
          self.class.send(:define_method, s[0]) {@server.call("status")[s[0]]}
        end
      end
    end
  end
  
  def self.start_server
    Timeout.timeout(1) do
      system(HELLA_BIN+" -D")
      $?.success?
    end
  rescue Timeout::Error
    false
  end
end
