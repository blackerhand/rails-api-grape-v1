class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name, unique: true, null: false
      t.string :description
      t.integer :status
      t.string :ancestry, index: true

      t.timestamps
    end
  end
end
