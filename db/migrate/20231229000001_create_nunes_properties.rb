# frozen_string_literal: true

class CreateNunesProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_properties do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :key, null: false
      t.text :value, null: false
      t.integer :value_type, null: false, default: 0
      t.timestamps
    end

    add_index :nunes_properties, %i[owner_id owner_type key], unique: true
    add_index :nunes_properties, :key
  end
end
