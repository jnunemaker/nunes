class CreateNunesSpans < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_spans do |t|
      t.string :span_id, null: false
      t.string :trace_id, null: false
      t.string :parent_id, null: true
      t.string :name, null: false
      t.integer :started_at, null: false
      t.integer :finished_at, null: false
      t.timestamps
    end

    add_index :nunes_spans, :span_id
    add_index :nunes_spans, :trace_id
    add_index :nunes_spans, :parent_id
    add_index :nunes_spans, :name
  end
end
