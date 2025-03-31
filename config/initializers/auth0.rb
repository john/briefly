Rails.application.config.auth0 = {
  client_id: ENV['AUTH0_CLIENT_ID'],
  client_secret: ENV['AUTH0_CLIENT_SECRET'],
  domain: ENV['AUTH0_DOMAIN'],
  audience: ENV['AUTH0_AUDIENCE'],
  scope: 'openid profile email'
} 