class AddStatusToReportConfigs < ActiveRecord::Migration[8.0]
  def change
    add_column :report_configs, :status, :string, default: 'draft', null: false
  end
end
