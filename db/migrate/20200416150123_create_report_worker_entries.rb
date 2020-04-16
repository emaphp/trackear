class CreateReportWorkerEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :report_worker_entries do |t|
      t.references :report, foreign_key: true
      t.references :user, foreign_key: true
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
