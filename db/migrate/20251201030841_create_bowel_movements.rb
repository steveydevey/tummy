class CreateBowelMovements < ActiveRecord::Migration[8.1]
  def change
    create_table :bowel_movements do |t|
      t.datetime :occurred_at
      t.integer :severity
      t.text :notes

      t.timestamps
    end
  end
end
