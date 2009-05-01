module HellanzbHelper
  def hellanzb_progress(progress, size)
    "<strong>#{progress}%</strong> of <strong>#{size}</strong>mb"
  end

  def hellanzb_progress_bar(progress, size)
    %{<div class="progress_bar"><div style="width: #{progress}%;">#{hellanzb_progress(progress, size)}</div></div>}
  end
end
