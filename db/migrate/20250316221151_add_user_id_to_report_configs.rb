class AddUserIdToReportConfigs < ActiveRecord::Migration[8.0]
  def change
    add_column :report_configs, :user_id, :integer
    add_index :report_configs, :user_id
  end
end
