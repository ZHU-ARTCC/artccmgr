# frozen_string_literal: true

class ActivityController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    unless current_user.staff?
      raise Pundit::NotAuthorizedError, 'Not allowed to view this page'
    end

    @controllers = User.local_controllers
    @visiting_controllers = User.visiting_controllers

    @report_start = report_start_date(params)
    @report_end   = @report_start.end_of_month.at_end_of_day

    authorize @controllers
    authorize @visiting_controllers
  end

  private

  # Determine start date for report
  def report_start_date(params)
    if params['start_date']
      date = Time.parse(params['start_date']).utc
      # force first day of month
      date.beginning_of_month.at_beginning_of_day
    else
      Time.now.utc.beginning_of_month.at_beginning_of_day
    end
  end
end
