# frozen_string_literal: true

# This migration comes from nunes (originally 20231229000000)
class CreateNunesSpans < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_spans do |t|
      t.string :name, null: false
      t.string :kind, null: false
      t.string :span_id, null: false, index: true
      t.string :trace_id, null: false, index: true
      t.string :parent_span_id, null: true, index: true
      t.bigint :start_timestamp, null: false
      t.bigint :end_timestamp, null: false
      t.integer :total_recorded_properties, null: false, default: 0
      t.integer :total_recorded_events, null: false, default: 0
      t.integer :total_recorded_links, null: false, default: 0
      t.timestamps
    end
  end
end
