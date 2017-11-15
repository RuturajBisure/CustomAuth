OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1152397541562752', 'a11fb2ef6f11ec4c4d3c6aab3d7cb737',  { provider_ignores_state: true 
  }
end