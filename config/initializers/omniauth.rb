Rails.application.config.middleware.use OmniAuth::Builder do
    provider :asana, ENV['ASANA_ID'], ENV['ASANA_SECRET']
end