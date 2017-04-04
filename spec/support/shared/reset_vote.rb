shared_examples_for "Reset Votable" do
  context 'authenticate user' do
    sign_in_user
    it 'reset vote' do
      vote
      expect { delete :vote_reset, id: object, format: :js }.to change(Vote, :count).by(-1)
    end
  end
  
  context 'unauthenticated user' do
    it "cannot vote" do
      expect { delete :vote_reset, id: object, format: :js}.to_not change(Vote, :count)
    end
  end
end
