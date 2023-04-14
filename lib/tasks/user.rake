require Rails.root.join('app', 'services', 'authenticate_token_service.rb').to_s

namespace :user do
  desc 'Generate token for API access token'
  task :generate_token, [:user_id] => [:environment] do |t, args|
    user = User.find(args.user_id.to_i)
    data = { uid: user.id, nm: user.name }
    public_key = OpenSSL::PKey::RSA.new Rails.application.credentials[Rails.env.to_sym][:jwt_public_key]
    jwt = JSON::JWT.new(data)
    jwe = jwt.encrypt(public_key)
    puts jwe.to_s
  end

  desc "Display user's name from given token"
  task :whoami, [:token] => [:environment] do |t, args|
    token = args.token.to_s.strip
    fail 'Invalid token' if token.blank?

    user = AuthenticateTokenService.call(token: token)
    fail 'Invalid token' unless user

    puts user.name
  end
end
