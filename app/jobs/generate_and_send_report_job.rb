class GenerateAndSendReportJob < ApplicationJob
  queue_as :default

  def perform(report_config_id)
    report_config = ReportConfig.find(report_config_id)
    report_generation = report_config.report_generations.create!(
      status: 'generating',
      generated_at: Time.current
    )

    begin
      content = OpenaiService.new.generate_report(
        report_config.prompt,
        report_config.model,
        report_config.temperature
      )

      # Send the email
      ReportMailer.report_email(report_config, content).deliver_now

      report_generation.update!(
        status: 'completed',
        content: content,
        completed_at: Time.current
      )
      report_config.update!(last_sent_at: Time.current)
      true
    rescue StandardError => e
      report_generation.update!(
        status: 'failed',
        error_message: e.message,
        completed_at: Time.current
      )
      false
    end
  end
end
