OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],  { provider_ignores_state: true }
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end