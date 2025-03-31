class RenameAudienceToRecipientsAndAddModelAndTemperature < ActiveRecord::Migration[8.0]
  def change
    rename_column :report_configs, :audience, :recipients
    add_column :report_configs, :model, :string, default: 'gpt-4'
    add_column :report_configs, :temperature, :float, default: 0.7
  end
end
