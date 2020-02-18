class CreateFileObjects < ActiveRecord::Migration[5.2]
  def change
    create_table :file_objects do |t|
      t.string :type

      t.string :fileable_id
      t.string :fileable_type

      t.string :file # store file
      t.integer :user_id # 上传人
      t.string :ext # 文件类型, [pdf, jpeg, jpg, png]
      t.string :filename # 文件名称: uuid
      t.string :original_filename # 文件原始名称
      t.decimal :size # 文件大小
      t.string :content_digest # 内容 md5

      t.bigint :created_user_id
      t.bigint :updated_user_id
      t.datetime :disabled_at

      t.timestamps
    end
  end
end
