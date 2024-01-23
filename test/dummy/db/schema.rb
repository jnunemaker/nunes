# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_21_015826) do
  create_table "nunes_events", force: :cascade do |t|
    t.bigint "span_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["span_id"], name: "index_nunes_events_on_span_id"
  end

  create_table "nunes_properties", force: :cascade do |t|
    t.string "owner_type", null: false
    t.integer "owner_id", null: false
    t.string "key", null: false
    t.text "value", null: false
    t.integer "value_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_nunes_properties_on_key"
    t.index ["owner_id", "owner_type", "key"], name: "index_nunes_properties_on_owner_id_and_owner_type_and_key", unique: true
    t.index ["owner_type", "owner_id"], name: "index_nunes_properties_on_owner"
  end

  create_table "nunes_spans", force: :cascade do |t|
    t.string "name", null: false
    t.string "kind", null: false
    t.string "span_id", null: false
    t.string "trace_id", null: false
    t.string "parent_span_id"
    t.bigint "start_timestamp", null: false
    t.bigint "end_timestamp", null: false
    t.integer "total_recorded_properties", default: 0, null: false
    t.integer "total_recorded_events", default: 0, null: false
    t.integer "total_recorded_links", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_span_id"], name: "index_nunes_spans_on_parent_span_id"
    t.index ["span_id"], name: "index_nunes_spans_on_span_id"
    t.index ["trace_id"], name: "index_nunes_spans_on_trace_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
