module Entities
  class FileObject < Base
    expose :id, :file_url, :filename, :filename_with_ext, :ext
  end
end
