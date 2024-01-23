# frozen_string_literal: true

# This migration comes from nunes (originally 20231229000002)
class CreateNunesEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_events do |t|
      t.bigint :span_id, null: false, index: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
