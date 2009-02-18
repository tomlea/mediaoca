# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def format_disk_usage(disk_usage)
    available = disk_usage.available / 1024
    total = disk_usage.total / 1024
    "<strong>#{available}</strong>/<strong>#{total}</strong>"
  end
end
