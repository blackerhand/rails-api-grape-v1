class FileObject < ApplicationRecord
  belongs_to :fileable, polymorphic: true, touch: true
  belongs_to :user, optional: true

  mount_uploader :file, FileUploader

  before_create do
    if file.try(:file)
      o_file             = file.file
      original_name, ext = o_file.filename.split(/\./)

      self.filename       = original_name
      self.ext            = ext
      self.size           = o_file.size
      self.content_digest = Digest::SHA1.hexdigest(o_file.read)
    end
  end
end
