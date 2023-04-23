# Enable/disable caching. By default caching is disabled.
# Set MEMCACHE_SERVERS on .env.{environment} file
if ENV['MEMCACHE_SERVERS']
  Rails.application.config.action_controller.perform_caching = true
  Rails.application.config.action_controller.enable_fragment_cache_logging = true

  Rails.application.config.cache_store = :mem_cache_store
  Rails.application.config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{2.days.to_i}"
  }
else
  Rails.application.config.action_controller.perform_caching = false
  Rails.application.config.cache_store = :null_store
end
