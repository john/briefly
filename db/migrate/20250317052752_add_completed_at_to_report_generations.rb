class AddCompletedAtToReportGenerations < ActiveRecord::Migration[8.0]
  def change
    add_column :report_generations, :completed_at, :datetime
  end
end
