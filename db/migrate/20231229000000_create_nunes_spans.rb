class CreateNunesSpans < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_spans do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :nunes_spans, :name
  end
end
