class AuthenticateTokenService
  attr_reader :public_key, :private_key, :authenticated_user

  def self.call(token:)
    new.authenticate! token
  end

  def initialize
    @private_key = OpenSSL::PKey::RSA.new Rails.application.credentials[:jwt_private_key]
    @public_key = OpenSSL::PKey::RSA.new Rails.application.credentials[:jwt_public_key]
  end

  def authenticate!(token)
    begin
      data = decode_token(token)
      @authenticated_user = User.find(data['uid'].to_i)

      authenticated_user
    # TODO: convert lib specific exception into human-readable error
    rescue JSON::JWT::InvalidFormat, ActiveRecord::RecordNotFound => error
      raise ArgumentError.new 'Invalid token'
    end
  end

  private

  def decode_token(token)
    jwe = JSON::JWT.decode(token, private_key)
    json = JSON::JWT.decode(jwe.plain_text)

    json
  end
end
