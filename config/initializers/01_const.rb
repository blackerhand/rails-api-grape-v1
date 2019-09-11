module GRAPE_API
  JWT_EXP     = ENV['JWT_EXP'].to_i
  JWT_REFRESH = ENV['JWT_EXP'].to_i / 2

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  PER_PAGE             = 15
  HTTP_FILE_SIZE_LIMIT = 60_000 # Response max size
end
