module ApiTestHelper
  def stub_authenticated_token(token, authenticated_user, &block)
    allow(AuthenticateTokenService).to receive(:call).with(token: token).and_return(authenticated_user)

    yield if block_given?
  end

  def json_response
    JSON.parse(response.body.presence || {})
  end
end
