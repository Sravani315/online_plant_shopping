class CreateCategories < ActiveRecord::Migration[5.1]
  def up
    create_table :categories do |t|
      t.string :name
      t.references :product_type, index: true
      t.timestamps
    end
  end

  def down
    drop_table :categories    
  end
end
