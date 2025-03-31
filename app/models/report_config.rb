class ReportConfig < ApplicationRecord
  belongs_to :user
  AVAILABLE_MODELS = %w[gpt-4 gpt-3.5-turbo].freeze
  STATUSES = %w[draft published].freeze

  has_many :report_generations, dependent: :destroy

  validates :name, presence: true
  validates :frequency, presence: true
  validates :recipients, presence: true
  validates :prompt, presence: true
  validates :model, presence: true, inclusion: { in: AVAILABLE_MODELS }
  validates :temperature, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }
  validates :status, inclusion: { in: STATUSES }
  validates :recipients, presence: true #, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :set_default_status, on: :create
  before_save :set_next_scheduled_at, if: :published?

  scope :published, -> { where(published: true) }
  scope :due_for_generation, -> { published.where('next_scheduled_at <= ?', Time.current) }

  enum :frequency, {
    daily: "daily",
    weekly: "weekly",
    monthly: "monthly"
  }

  def should_generate?
    return true if last_sent_at.nil?

    case frequency
    when 'daily'
      last_sent_at < 1.day.ago
    when 'weekly'
      last_sent_at < 1.week.ago
    when 'monthly'
      last_sent_at < 1.month.ago
    else
      false
    end
  end

  def schedule_report
    GenerateAndSendReportJob.perform_later(id) if should_generate?
  end

  def generate_report!
    report_generations.create!(
      status: 'generating',
      started_at: Time.current
    ).tap do |generation|
      begin
        content = OpenaiService.new.generate_report(prompt, model, temperature)
        generation.update!(
          status: 'completed',
          content: content,
          completed_at: Time.current
        )
        update!(last_sent_at: Time.current)
      rescue => e
        generation.update!(
          status: 'failed',
          error_message: e.message,
          completed_at: Time.current
        )
        raise e
      end
    end
  end

  def publish!
    update!(status: 'published', published_at: Time.current)
  end

  def unpublish!
    update!(status: 'draft', published_at: nil)
  end

  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def last_published_at
    published_at&.strftime("%B %d, %Y")
  end

  def last_generation
    report_generations.recent.first
  end

  private

  def set_default_status
    self.status ||= 'draft'
  end

  def set_next_scheduled_at
    return if next_scheduled_at.present? && !published_changed?

    self.next_scheduled_at = case frequency
                            when 'daily'
                              Time.current.tomorrow
                            when 'weekly'
                              Time.current.next_week
                            when 'monthly'
                              Time.current.next_month
                            else
                              Time.current.tomorrow
                            end
  end
end
