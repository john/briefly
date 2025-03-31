class ReportMailer < ApplicationMailer
  def report_email(report_config, content)
    @report_config = report_config
    @content = content
    @recipients = report_config.recipients.split(',').map(&:strip)

    mail(
      to: @recipients,
      subject: "Your #{report_config.name} Report"
    )
  end
end 