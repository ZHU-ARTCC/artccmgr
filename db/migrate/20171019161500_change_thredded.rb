# frozen_string_literal: true

class ChangeThredded < ActiveRecord::Migration[5.1]
  def up
    change_column_default :thredded_user_details, :moderation_state, 1 # Approved
  end
  def down
    change_column_default :thredded_user_details, :moderation_state, 0 # Not approved
  end
end