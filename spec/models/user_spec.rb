require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:others_question) { create :question }
  let(:answer) { create :answer, user: user }
  let(:others_answer) { create :answer }
  let(:question_vote) { create :vote, user: user, votable: others_question }
  let(:answer_vote) { create :vote, user: user, votable: others_answer }

  describe 'author_of?' do
    it 'return true if question/answer belongs to current user' do
      expect(user.author_of?(question)).to eq true
      expect(user.author_of?(answer)).to eq true
    end

    it "return false if question/answer doesn't belongs to current user" do
      expect(user.author_of?(others_question)).to eq false
      expect(user.author_of?(others_answer)).to eq false
    end
  end

  describe 'voted?' do
    it 'return true if question/answer has vote belongs to current user' do
      question_vote
      expect(user.voted?(others_question)).to eq true
      answer_vote
      expect(user.voted?(others_answer)).to eq true
    end

    it "return false if question/answer doesn't has vote belongs to current user" do
      expect(user.voted?(question)).to eq false
      expect(user.voted?(answer)).to eq false
    end
  end

  describe '.find_for_oauth' do
    context 'User already has authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info:{ email: user.email })}
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "User hasn't authorization" do
      context 'User already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info:{ email: user.email })}
        it "doesn't create new user" do
          user
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context "User doesn't exist" do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)

      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'feels user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

  describe '.subscribed?' do
    it "return true if subscribed" do
      expect(user.subscribed?(question)).to eq true
    end

    it "return false if unsubscribed" do
      expect(user.subscribed?(others_question)).to eq false
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
      User.send_daily_digest
    end
  end
end
