class CreateReportConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :report_configs do |t|
      t.string :name
      t.string :frequency
      t.string :audience
      t.text :prompt
      t.datetime :last_sent_at

      t.timestamps
    end
  end
end
