class CreateReportPartnerEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :report_partner_entries do |t|
      t.references :report, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :percentage

      t.timestamps
    end
  end
end
