class AddPublishedAtToReportConfigs < ActiveRecord::Migration[8.0]
  def change
    add_column :report_configs, :published_at, :datetime, null: true
  end
end
