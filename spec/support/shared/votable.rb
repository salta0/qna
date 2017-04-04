shared_examples_for "Votable" do 
  describe 'vote' do
    it 'create vote with value' do
      object.vote(1, user.id)
      vote = object.votes.first
      expect(vote.user_id).to eq user.id
      expect(vote.value).to eq 1
    end
  end

  describe 'reset' do
    it 'delete vote' do
      vote_1
      vote_2
      expect(object.votes.count).to eq 2
      object.reset(user.id)
      object.votes.reload
      expect(object.votes.count).to eq 1
    end
  end

  describe 'rating' do
    it 'counts votes' do
      vote_1
      vote_2
      expect(object.rating).to eq 2
    end
  end
end
