shared_examples_for "Creatable object with valid attributes" do
  it 'returns 201' do
    do_request(type, path, options)
    expect(response.status).to eq 201
  end

  it 'create object' do
    expect{ do_request(type, path, options) }.to change(object, :count).by(1)
  end

  it "returs object" do
    do_request(type, path, options)
    attributes.each do |attr, value|
      expect(response.body).to be_json_eql(value.to_json).at_path("#{object_class.name.downcase}/#{attr}")
    end
  end
end

