# This migration comes from nunes (originally 20231229000001)
class CreateNunesTags < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_tags do |t|
      t.bigint :span_id, null: false
      t.string :key, null: false
      t.text :value, null: false
      t.timestamps
    end

    add_index :nunes_tags, %i[span_id key]
    add_index :nunes_tags, :key
  end
end
