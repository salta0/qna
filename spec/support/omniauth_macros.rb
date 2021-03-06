# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({ 
      provider: provider.to_s, 
      uid: '123456'
    }.merge(provider == :facebook ? { info: { email: 'new@user.com' }} : {}))  
  end
end