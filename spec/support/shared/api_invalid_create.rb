shared_examples_for "Creatable object with invalid attributes" do  
  it 'returns 422' do
    do_request(type, path, options)
    expect(response.status).to eq 422
  end

  it "doesn't create object" do
    expect { do_request(type, path, options) }.to_not change(object_class, :count)
  end

  it 'returns error' do
    do_request(type, path, options)
    expect(response.body).to have_json_path("errors")
  end
end
