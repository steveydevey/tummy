class CreateAccidents < ActiveRecord::Migration[8.1]
  def change
    create_table :accidents do |t|
      t.datetime :occurred_at
      t.string :accident_type
      t.text :notes

      t.timestamps
    end
  end
end
