class CreateRestRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :rest_requests do |t|
      t.string :http_method, comment: '请求方法'
      t.string :url, comment: '请求 URL'
      t.text :headers, comment: '请求 header'
      t.text :query_params, comment: 'url 参数'
      t.string :data_type, comment: 'data 参数类型 (form/json)'
      t.text   :data, comment: '参数'
      t.text :request_data, comment: '可能和 query params 重复'

      t.integer :status_code, comment: 'response http code'
      t.text :response, comment: 'response body'
      t.text :response_headers, comment: 'response header'
      t.boolean :response_status, comment: '请求结果 true/false, 这个要根据业务逻辑来设定. 不能靠 status_code 来确定'
      t.text :response_data, comment: '格式化后的 response'

      t.string :type, comment: '请求类型'
      t.string :requestable_id, comment: '外键 ID'
      t.string :requestable_type, comment: '外键 类型'
      t.boolean :is_valid, comment: '请求是否成功'

      t.timestamps
    end
  end
end
