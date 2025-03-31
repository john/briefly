class ReportConfigsController < ApplicationController
  include Auth0Concern

  before_action :set_report_config, only: [:show,:edit, :update, :destroy, :preview, :publish, :unpublish, :generate, :history]

  def index
    @report_configs = ReportConfig.all
  end

  def new
    @report_config = ReportConfig.new
  end

  def create
    @report_config = ReportConfig.new(report_config_params)
    @report_config.user = current_user

    logger.debug("-----------> Report config: #{@report_config.inspect}")

    if @report_config.save
      redirect_to report_configs_path, notice: 'Report configuration was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @report_config.update(report_config_params)
      @report_config.update(status: 'draft') if @report_config.published?
      redirect_to report_configs_path, notice: 'Report configuration was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report_config.destroy
    redirect_to report_configs_path, notice: 'Report configuration was successfully deleted.'
  end

  def preview
    if @report_config.save
      @preview = OpenaiService.new.generate_report(
        @report_config.prompt,
        model: @report_config.model,
        temperature: @report_config.temperature
      )
      respond_to do |format|
        format.turbo_stream
      end
    else
      render turbo_stream: turbo_stream.update("preview-content") do
        render partial: "shared/error_message", locals: { message: "Please fix the errors before previewing." }
      end
    end
  end

  def publish
    if @report_config.publish!
      redirect_to report_configs_path, notice: 'Report configuration was successfully published.'
    else
      redirect_to report_configs_path, alert: 'Failed to publish report configuration.'
    end
  end

  def unpublish
    if @report_config.unpublish!
      redirect_to report_configs_path, notice: 'Report configuration was successfully unpublished.'
    else
      redirect_to report_configs_path, alert: 'Failed to unpublish report configuration.'
    end
  end

  def generate
    if @report_config.generate_report!
      redirect_to history_report_config_path(@report_config), notice: 'Report was successfully generated and sent.'
    else
      redirect_to history_report_config_path(@report_config), alert: 'Failed to generate report.'
    end
  end

  def history
    @generations = @report_config.report_generations.recent
  end

  private

  def set_report_config
    @report_config = ReportConfig.find(params[:id]) if params[:id]
  end

  def report_config_params
    params.require(:report_config).permit(:name, :frequency, :recipients, :prompt, :model, :temperature)
  end
end
