shared_examples_for "Includable object" do 
  before { do_request(type, path, access_token: access_token.token) }

  it 'include object at path' do
    expect(response.body).to have_json_size(json_size).at_path(json_path)
  end

  it "contains attributes" do
    attributes.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{attr_path}#{attr}")
    end
  end
end
