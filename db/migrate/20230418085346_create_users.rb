class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :userId
      t.integer :sum_complete, default:0

      t.timestamps
    end
  end
end
