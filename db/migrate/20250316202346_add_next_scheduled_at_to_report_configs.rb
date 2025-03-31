class AddNextScheduledAtToReportConfigs < ActiveRecord::Migration[8.0]
  def change
    add_column :report_configs, :next_scheduled_at, :datetime
  end
end
