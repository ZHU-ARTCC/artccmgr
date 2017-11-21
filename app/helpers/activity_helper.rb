# frozen_string_literal: true

module ActivityHelper
  # Returns the css class to be used if the user does not meet
  # the minimum activity requirements for the user and duration given
  #
  def activity_minimums_css(user, duration)
    mins = user.min_controlling_hours

    duration < mins ? 'bg-danger' : nil
  end

  # Returns paths for viewing previous and next month reports
  #
  def report_controls
    forward = nil

    # convert Time to Date
    start_date = Date.parse((@report_start - 1.month).to_s)
    back       = activity_index_path(start_date: start_date)

    if @report_end <= Time.now.utc
      # convert Time to Date
      start_date = Date.parse((@report_start + 1.month).to_s)
      forward = activity_index_path(start_date: start_date)
    end

    { prev: back, next: forward }
  end
end
