require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  
  it { should accept_nested_attributes_for :attachments }

  let(:question) { create :question }
  let(:user) { create :user }
  let(:vote_1) { create :vote, value: -1, user: user, votable: question }
  let(:vote_2) { create :vote, votable: question }
  let(:votes) { create_list :vote, 3, votable: question, value: 1 }

  describe 'votable' do
    let(:vote_1) { create :vote, votable: question, value: 1 }
    let(:vote_2) { create :vote, user: user, votable: question, value: 1 }
    let(:object) { question }
    it_behaves_like "Votable"
  end

  describe 'subscribe owner after create' do
    let(:question) { build(:question, user: user) }

    it 'owner subscribes for question after create' do
      expect(Subscription).to receive(:create)
      question.save!
    end

    it 'does not subscribe after update' do
      question.save!
      expect(Subscription).to_not receive(:create)
      question.update(title: "new title")
    end
  end
end
