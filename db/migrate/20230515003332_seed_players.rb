class SeedPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.integer :age
      t.integer :average_position_age_diff
      t.string :first_name
      t.string :last_name
      t.string :name_brief
      t.string :position
      t.string :sport

      t.timestamps
    end
  end
end
