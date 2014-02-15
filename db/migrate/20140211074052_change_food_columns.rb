class ChangeFoodColumns < ActiveRecord::Migration
  def change
    rename_column :foods, :protein, :prot
  end
end
