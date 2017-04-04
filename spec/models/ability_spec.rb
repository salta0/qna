require 'rails_helper'

describe 'Ability' do 
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let!(:subscription) { create :subscription, question: question, user: user }
    let(:answer) { create :answer, user: user }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, create(:question, user: other), user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, create(:question, user: other), user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    it { should be_able_to :destroy, create(:attachment, attachable: question), user: user }
    it { should be_able_to :destroy, create(:attachment, attachable: answer), user: user }
    it { should_not be_able_to :destroy, create(:attachment), user: user }

    it { should be_able_to :set_best, create(:answer, question: question), user: user }
    it { should_not be_able_to :set_best, create(:answer), user: user }

    it { should be_able_to :vote, create(:question, user: other), user: user }
    it { should be_able_to :vote, create(:answer, user: other), user: user }
    it { should_not be_able_to :vote, question, user: user }
    it { should_not be_able_to :vote, answer, user: user }

    it { should be_able_to :me, user, user: user }
    it { should be_able_to :index, User, user: user }

    it { should be_able_to :subscribe, create(:question) } 
    it { should_not be_able_to :subscribe, question }

    it { should be_able_to :unsubscribe, create(:question) }

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, Subscription }
    it { should_not be_able_to :destroy, create(:subscription), user: user }
  end
end
