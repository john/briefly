class ReportGeneration < ApplicationRecord
  belongs_to :report_config

  STATUSES = %w[pending generating completed failed].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :content, presence: true, if: :completed?
  validates :error_message, presence: true, if: :failed?

  scope :recent, -> { order(generated_at: :desc) }
  scope :completed, -> { where(status: 'completed') }
  scope :failed, -> { where(status: 'failed') }

  def completed?
    status == 'completed'
  end

  def failed?
    status == 'failed'
  end

  def pending?
    status == 'pending'
  end

  def generating?
    status == 'generating'
  end

  def mark_as_completed!(content)
    update!(
      status: 'completed',
      content: content,
      generated_at: Time.current
    )
  end

  def mark_as_failed!(error_message)
    update!(
      status: 'failed',
      error_message: error_message,
      generated_at: Time.current
    )
  end

  def mark_as_sent!
    update!(sent_at: Time.current)
  end
end
