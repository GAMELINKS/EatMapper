class CreateMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :maps do |t|
      t.string :title
      t.string :about
      t.date :date
      t.string :image
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
