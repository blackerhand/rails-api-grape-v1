# 200 code 返回 data 构建规则
# 203 表示 token 有更新, 检查 response header Authorization, 得到新的token, 此时应该更新客户端的 token
# 结构说明 {meta: {*payload, path: '/', version: '1'}, data: {id: '1', type: 'User', attributes: {}}/[]}
module DataBuildHelper
  def data!(data)
    meta = default_meta

    if data.is_a?(String)
      meta[:message] = data
      data           = nil
    elsif data.is_a?(Hash) && data[:meta].present?
      meta.merge!(data.delete(:meta))
    end

    { meta: meta, data: data }
  end

  def base_num(records)
    return 0 if records.try(:current_page).nil?

    (records.current_page - 1) * records.limit_value
  end

  def default_opts
    {
      current_user_id: current_user_id,
      current_user:    current_user
    }
  end

  def data_paginate!(records, entities_class, meta = {})
    opts = meta.delete(:opts) || {}
    opts.merge!(default_opts)

    {
      meta: default_meta.merge(pagination(records)).merge(meta),
      data: json_records!(records, entities_class, opts)
    }
  end

  def data_ransack_file!(records, entities_class, opts = {})
    thead           = opts.delete(:thead)
    file_name       = opts.delete(:file_name) || 'export'
    opts[:use_base] = false

    data = file_records!(records, entities_class, opts).as_json
    p    = Axlsx::Package.new

    p.workbook.add_worksheet(name: 'Data') do |sheet|
      sheet.add_row thead if thead.present?

      data.each do |row|
        row.delete(:id) if opts[:without_id]
        sheet.add_row row.values
      end
    end

    p.use_shared_strings = true

    content_type 'application/octet-stream'
    header['Access-Control-Expose-Headers'] = 'Content-Disposition'
    header['Content-Disposition']           = "attachment; filename=#{file_name}.xlsx"
    env['api.format']                       = :binary
    p.to_stream.read
  end

  def file_records!(records, entities_class, opts = {})
    records.find_each.map { |record| entities_record_no_base(record, entities_class, opts) }
  end

  def data_record!(record, entities_class, meta = {})
    opts = meta.delete(:opts) || {}
    opts.merge!(default_opts)

    {
      meta: default_meta.merge(meta),
      data: entities_record(record, entities_class, opts)
    }
  end

  def json_records!(records, entities_class, opts = {})
    records.map.each_with_index { |record, index| entities_record(record, entities_class, opts.merge(rank: base_num(records) + index + 1)) }
  end

  private

  def entities_record_no_base(record, entities_class, opts = {})
    opts ||= {}
    entities_class.represent record, opts
  end

  def entities_record(record, entities_class, opts)
    opts ||= {}
    Entities::RecordBase.represent record, opts.merge(glass: entities_class)
  end

  def base_meta
    request = Grape::Request.new(env)
    {
      message: '请求成功',
      path:    request.path,
      status:  200,
      version: request.path.match(%r{\/v(\d+)\/}).try(:[], 1)
    }
  end

  def default_meta
    meta                = base_meta
    meta[:payload]      = @payload || {}
    meta[:current_user] = current_user_info
    meta
  end

  def current_user_info
    return if current_user.blank?

    Entities::User::Info.represent current_user
  end

  def pagination(records)
    {
      pagination: {
        total_pages:   records.try(:total_pages),
        current_page:  records.try(:current_page),
        current_count: records.try(:length),
        limit_value:   records.try(:limit_value),
        total_count:   records.try(:total_count),
        prev_page:     records.try(:prev_page),
        next_page:     records.try(:next_page)
      }
    }
  end
end
