class AddTwoFactorRequiredToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :two_factor_required, :boolean, default: false
  end
end
