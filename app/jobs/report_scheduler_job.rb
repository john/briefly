class ReportSchedulerJob < ApplicationJob
  queue_as :default

  def perform
    # Find all published reports that are due to run
    ReportConfig.published.where('next_scheduled_at <= ?', Time.current).find_each do |config|
      # Enqueue the report generation
      GenerateAndSendReportJob.perform_later(config.id)
      
      # Calculate next run time based on frequency
      config.update(next_scheduled_at: calculate_next_run_time(config))
    end
  end

  private

  def calculate_next_run_time(config)
    case config.frequency
    when 'daily'
      Time.current.tomorrow
    when 'weekly'
      Time.current.next_week
    when 'monthly'
      Time.current.next_month
    else
      Time.current.tomorrow # fallback to daily
    end
  end
end 