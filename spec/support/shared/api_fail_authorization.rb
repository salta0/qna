shared_examples_for "Fail Authenticable" do   
  context 'unauthorize' do
    it 'returns 401 if there is no access_token' do
      do_request(type, path)
      expect(response.status).to eq 401
    end

    it 'returns 401 if invalid access_token' do
      do_request(type, path, access_token: '2345')
      expect(response.status).to eq 401
    end
  end
end
