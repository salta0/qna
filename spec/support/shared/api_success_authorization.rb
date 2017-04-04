shared_examples_for "Success Authenticable" do  
  before { do_request(type, path, access_token: access_token.token) }

  it 'returns 200 ok' do
    expect(response).to be_success
  end
end
