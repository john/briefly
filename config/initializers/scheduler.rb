# Schedule the report scheduler to run every hour
Rails.application.config.after_initialize do
  Rails.application.config.active_job.queue_adapter = :solid_queue

  # Only schedule in production to avoid duplicate jobs in development
  if Rails.env.production?
    SolidQueue::RecurringJob.create!(
      name: "Report Scheduler",
      class_name: "ReportSchedulerJob",
      schedule: "0 * * * *" # Run every hour
    )
  end
end 