# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_26_085504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_tracks", force: :cascade do |t|
    t.string "description"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_contract_id"
    t.index ["project_contract_id"], name: "index_activity_tracks_on_project_contract_id"
  end

  create_table "expense_invitations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email"
    t.string "name"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.index ["email", "user_id"], name: "index_expense_invitations_on_email_and_user_id", unique: true
    t.index ["user_id"], name: "index_expense_invitations_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.text "receipt_data"
    t.date "from"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_expenses_on_project_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "invoice_entries", force: :cascade do |t|
    t.string "description"
    t.decimal "rate"
    t.bigint "invoice_id"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activity_track_id"
    t.index ["activity_track_id"], name: "index_invoice_entries_on_activity_track_id"
    t.index ["invoice_id"], name: "index_invoice_entries_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "project_id"
    t.decimal "discount_percentage"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "from"
    t.date "to"
    t.boolean "is_visible"
    t.bigint "user_id"
    t.text "invoice_data"
    t.text "payment_data"
    t.boolean "is_client_visible"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_invoices_on_deleted_at"
    t.index ["project_id"], name: "index_invoices_on_project_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "project_contracts", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.string "activity"
    t.decimal "project_rate"
    t.decimal "user_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "active_from"
    t.date "ends_at"
    t.index ["project_id"], name: "index_project_contracts_on_project_id"
    t.index ["user_id"], name: "index_project_contracts_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "currency"
    t.string "slug"
    t.text "icon_data"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "report_partner_entries", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "user_id"
    t.decimal "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_report_partner_entries_on_report_id"
    t.index ["user_id"], name: "index_report_partner_entries_on_user_id"
  end

  create_table "report_worker_entries", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "user_id"
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_report_worker_entries_on_invoice_id"
    t.index ["report_id"], name: "index_report_worker_entries_on_report_id"
    t.index ["user_id"], name: "index_report_worker_entries_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.date "from"
    t.date "to"
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "invoice_id"
    t.index ["invoice_id"], name: "index_reports_on_invoice_id"
    t.index ["project_id"], name: "index_reports_on_project_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "picture"
    t.string "slug"
    t.boolean "is_admin"
    t.boolean "is_premium"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "expense_invitations", "users"
  add_foreign_key "expenses", "projects"
  add_foreign_key "expenses", "users"
  add_foreign_key "invoice_entries", "invoices"
  add_foreign_key "invoices", "projects"
  add_foreign_key "project_contracts", "projects"
  add_foreign_key "project_contracts", "users"
  add_foreign_key "report_partner_entries", "reports"
  add_foreign_key "report_partner_entries", "users"
  add_foreign_key "report_worker_entries", "invoices"
  add_foreign_key "report_worker_entries", "reports"
  add_foreign_key "report_worker_entries", "users"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
end
