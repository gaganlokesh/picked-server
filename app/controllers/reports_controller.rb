class ReportsController < ApplicationController
  def create
    report = Report.new(report_params.merge(user_id: current_user&.id))

    if report.save
      render json: { status: "success", message: "Report created" }, status: :ok
    else
      render json: { status: "error", message: "Report not created" }, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.permit(:category, :reason, :reportable_type, :reportable_id)
  end
end
