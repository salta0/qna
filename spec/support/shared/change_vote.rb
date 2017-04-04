shared_examples_for "Change Votable" do  
  context 'authenticated user' do
    sign_in_user
    it 'make vote' do
      expect { send type, action, id: object, format: :js }.to change(Vote, :count).by(1)
    end
    it 'up value for 1' do
      send type, action, id: object, format: :js
      vote = object.votes.first
      expect(vote.value).to eq result
    end
    it "doesn't change voted" do
      vote
      expect { send type, action, id: object, format: :js }.to_not change(Vote, :count)
    end
    it "doesn't voting for own question" do
      expect { send type, action, id: own_object, format: :js }.to_not change(Vote, :count)
    end
  end

  context 'unauthenticated user' do
    it "cannot vote" do
      expect { send type, action, id: object, format: :js }.to_not change(Vote, :count)
    end
  end
end
