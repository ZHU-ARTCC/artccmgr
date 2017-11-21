# frozen_string_literal: true

class CreateGpgKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :gpg_keys, id: :uuid do |t|
      t.uuid    :user_id
      t.binary  :primary_keyid
      t.binary  :fingerprint
      t.text    :key
      t.timestamps
    end

    add_index 'gpg_keys', ['fingerprint'], name: 'index_gpg_keys_on_fingerprint', unique: true, using: :btree
    add_index 'gpg_keys', ['primary_keyid'], name: 'index_gpg_keys_on_primary_keyid', unique: true, using: :btree
    add_index 'gpg_keys', ['user_id'], name: 'index_gpg_keys_on_user_id', using: :btree
  end
end
