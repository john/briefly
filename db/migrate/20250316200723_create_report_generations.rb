class CreateReportGenerations < ActiveRecord::Migration[8.0]
  def change
    create_table :report_generations do |t|
      t.references :report_config, null: false, foreign_key: true
      t.text :content
      t.string :status, null: false, default: 'pending'
      t.text :error_message
      t.datetime :generated_at
      t.datetime :sent_at

      t.timestamps
    end

    add_index :report_generations, :status
    add_index :report_generations, :generated_at
  end
end
