class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.text    :goal,   nil: false
      t.integer :period, nil: false
      t.timestamps
    end
  end
end
