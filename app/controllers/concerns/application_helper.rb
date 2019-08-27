# global helpers
module ApplicationHelper
  def verify_params!
    Svc::ParamsSignature.verify!(request)
  end
end
