class CasSso < BaseService
  def self.login(ticket)
    rsp = RestClient.get("#{ENV['SSO_HOST']}#{ENV['SSO_GET_USER_INFO_PATH']}?",
                         params: { ticket: ticket, service: login_url })
    doc = Nokogiri::XML(rsp.body)

    if safe_xpath?(doc, '//sso:authenticationSuccess')
      [true, {
        id_number:          doc.xpath('//cas:ID_NUMBER').text.strip,
        user_name:          doc.xpath('//cas:USER_NAME').text.strip,
        id_type:            doc.xpath('//cas:ID_TYPE').text.strip,
        check_alive_ticket: doc.xpath('//cas:checkAliveTicket').text.strip,
      }]
    elsif safe_xpath?(doc, '//cas:authenticationFailure')
      ele  = doc.xpath('//cas:authenticationFailure').first
      code = ele.attributes['code']&.text.to_s.strip

      [false, { code: code, message: ele.text.strip }]
    else
      [false, { message: 'xml 解析错误', xml: rsp.body }]
    end
  rescue => e
    [false, { message: e.message }]
  end

  def self.safe_xpath?(doc, path)
    doc.xpath(path).present?
  rescue Nokogiri::XML::XPath::SyntaxError
    false
  end

  def self.error
    "\n\n\n<cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>\n\t<cas:authenticationFailure code='INVALID_TICKET'>\n\t\t未能够识别出目标 &#039;a&#039;票根\n\t</cas:authenticationFailure>\n</cas:serviceResponse>"
  end

  def self.success
    "<?xml version='1.0' encoding='UTF-8'?>\r\n\r\n\r\n\r\n<sso:serviceResponse xmlns:sso='http://www.yale.edu/tp/cas' xmlns:cas='http://www.yale.edu/tp/cas'>\r\n\t<sso:authenticationSuccess>\r\n\t\t<sso:user>S20180300001</sso:user>\r\n\t\t\r\n\t\t\t\r\n\t            \r\n                <cas:attributes>\r\n\t                \r\n\t                    <cas:ID_NUMBER>S20180300001</cas:ID_NUMBER>\r\n\t                \r\n\t                    <cas:USER_NAME>测试老师</cas:USER_NAME>\r\n\t                \r\n\t                    <cas:ID_TYPE>3</cas:ID_TYPE>\r\n\t                \r\n\t                    <cas:KSH>S20180300001</cas:KSH>\r\n\t                \r\n\t                <cas:checkAliveTicket>TGT-S20180300001-33683-52qc53bBYTGK0OjujVcEVH3Y5KhW3jLWR2OBRGFUJ0ez7lEXYZ-cas</cas:checkAliveTicket>\r\n\t                <cas:serviceId>23843589910531</cas:serviceId>\r\n\t            </cas:attributes>\r\n\t            \r\n\t            <sso:attributes>\r\n\t                \r\n\t                    <sso:attribute name=\"id_number\" type=\"java.lang.String\" value=\"S20180300001\"></sso:attribute>\r\n\t                \r\n\t                    <sso:attribute name=\"user_name\" type=\"java.lang.String\" value=\"测试老师\"></sso:attribute>\r\n\t                \r\n\t                    <sso:attribute name=\"id_type\" type=\"java.lang.String\" value=\"3\"></sso:attribute>\r\n\t                \r\n\t                    <sso:attribute name=\"ksh\" type=\"java.lang.String\" value=\"S20180300001\"></sso:attribute>\r\n\t                \r\n\r\n\t            </sso:attributes>\r\n\t            \r\n\t        \r\n\t\t\t\r\n\t        \r\n        \r\n\t\t\t\r\n\t\t\r\n\t</sso:authenticationSuccess>\r\n</sso:serviceResponse>"
  end

  def self.login_url
    "https://e-learning.sdu.edu.cn/login/cas"
  end

  def self.redirect_url
    "#{ENV['SSO_HOST']}#{ENV['SSO_LOGIN_PATH']}?service=#{url_encode(login_url)}"
  end

  def self.url_encode(str)
    CGI.escape(str)
  end
end
