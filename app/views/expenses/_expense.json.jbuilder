json.extract! expense, :id, :name, :receipt_data, :from, :project_id, :created_at, :updated_at
json.url expense_url(expense, format: :json)
