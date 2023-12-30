class CreateNunesTags < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_tags do |t|
      t.string :key, null: false
      t.text :value, null: false
      t.timestamps
    end

    add_index :nunes_tags, :key
  end
end
