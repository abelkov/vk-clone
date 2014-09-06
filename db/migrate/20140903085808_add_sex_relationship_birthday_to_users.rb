class AddSexRelationshipBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sex, :string
    add_column :users, :relationship, :string
    add_column :users, :birthday, :date
  end
end
