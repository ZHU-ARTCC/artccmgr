class EnablePgcryptoExtension < ActiveRecord::Migration[5.1]
  def change
    # New extension required for UUIDs in Rails 5.1
    enable_extension 'pgcrypto'
  end
end
