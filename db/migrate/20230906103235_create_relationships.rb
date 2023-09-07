class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id #フォローしたuserのid
      t.integer :followed_id #フォローされたuserのid

      t.timestamps
    end
  end
end
