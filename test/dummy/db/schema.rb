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

ActiveRecord::Schema[7.1].define(version: 2024_01_02_230233) do
  create_table "nunes_spans", force: :cascade do |t|
    t.string "span_id", null: false
    t.string "trace_id", null: false
    t.string "parent_id"
    t.string "name", null: false
    t.integer "started_at", null: false
    t.integer "finished_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_nunes_spans_on_name"
    t.index ["parent_id"], name: "index_nunes_spans_on_parent_id"
    t.index ["span_id"], name: "index_nunes_spans_on_span_id"
    t.index ["trace_id"], name: "index_nunes_spans_on_trace_id"
  end

  create_table "nunes_tags", force: :cascade do |t|
    t.bigint "span_id", null: false
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_nunes_tags_on_key"
    t.index ["span_id", "key"], name: "index_nunes_tags_on_span_id_and_key"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
