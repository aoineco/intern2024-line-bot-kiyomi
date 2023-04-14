class CreateChallengeTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :challenge_tasks do |t|
      t.string :content

      t.timestamps
    end
  end
end
