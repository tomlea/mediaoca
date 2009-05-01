module HellanzbHelper
  def hellanzb_progress(progress, size)
    "<strong>#{progress}%</strong> of <strong>#{size}</strong>mb"
  end

  def hellanzb_progress_chart(progress)
    %{<div class="progress_bar"><div style="width: #{progress}%;">#{progress}%</div></div>}
  end
end
