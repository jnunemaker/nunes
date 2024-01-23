# frozen_string_literal: true

class CreateNunesEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :nunes_events do |t|
      t.bigint :span_id, null: false, index: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
