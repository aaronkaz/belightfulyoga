class AddCommentToPayOuts < ActiveRecord::Migration
  def change
    add_column :pay_outs, :comment, :text
  end
end
