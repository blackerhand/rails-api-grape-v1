class Post < ApplicationRecord
  include Disable

  acts_as_taggable
  resourcify
end
