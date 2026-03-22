class RenamePasswordHashToPasswordDigestInUsers < ActiveRecord::Migration[7.1] # Версия может отличаться, оставь ту, что сгенерировалась
  def change
    rename_column :users, :password_hash, :password_digest
  end
end