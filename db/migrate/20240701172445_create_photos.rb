class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :image
      t.integer :commments_count
      t.integer :likes_count
      t.text :caption
      t.references :owner, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
