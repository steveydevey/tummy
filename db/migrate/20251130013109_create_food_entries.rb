class CreateFoodEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :food_entries do |t|
      t.text :description
      t.datetime :consumed_at
      t.text :notes

      t.timestamps
    end
  end
end
