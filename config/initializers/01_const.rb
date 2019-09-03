module GRAPE_API
  JWT_EXP     = ENV['JWT_EXP'].to_i
  JWT_REFRESH = ENV['JWT_EXP'].to_i - 60
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PER_PAGE    = 15

  AUTH_UN_REQUIRED = %w[POST/v1/users/sign_in POST/v1/users/sign_up
                        POST/v1/users/send_mail POST/v1/users/reset]

  OWNER_REQUIRED = %w[POST/v1/posts/:id DELETE/v1/posts/:id PUT/v1/items/:id]
end
