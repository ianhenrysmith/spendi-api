class AddFieldsAndRelationsToActivities < ActiveRecord::Migration
  def change
    change_table(:activities) do |t|
      t.string :description
      t.decimal :amount
      t.boolean :positive
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
