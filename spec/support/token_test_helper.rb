module TokenTestHelper
  def generate_token(user)
    data = { uid: user.id, nm: user.name }
    public_key = OpenSSL::PKey::RSA.new Rails.application.credentials[Rails.env.to_sym][:jwt_public_key]
    jwt = JSON::JWT.new(data)
    jwe = jwt.encrypt(public_key)

    jwe.to_s
  end
end
