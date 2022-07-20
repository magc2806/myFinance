class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ""
      t.string :color, null: false, default: "#FFFFFF"
      t.boolean :active, null: false, default: true
      t.boolean :to_analyze, null: false, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
