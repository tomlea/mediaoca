set :cron_log, File.join(File.dirname(__FILE__), *%w[.. log cron.log])

every 10.minutes do
  runner "Episode.scan_for_episodes!"
end
