require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should validate_presence_of(:user_id) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  let(:question) { create :question }
  let(:user) { create :user }
  let(:first_answer) {
    create :answer,
      question: question,
      created_at: '2015-12-04 13:00:00'
  }
  let(:second_answer) {
    create :answer,
    question: question,
    created_at: '2015-12-04 12:00:00'
  }
  
  describe 'set_best' do
    before do
      first_answer.set_best
      second_answer.set_best
      first_answer.reload
      second_answer.reload
    end
    
    it 'set only one best answer' do
      expect(first_answer.best?).to eq false
      expect(second_answer.best?).to eq true
    end

    it 'best answer should be fisrt' do
      expect(question.answers).to eq ([second_answer, first_answer])
    end
  end

  describe 'votable' do
    let(:vote_1) { create :vote, votable: first_answer, value: 1 }
    let(:vote_2) { create :vote, user: user, votable: first_answer, value: 1 }
    let(:object) { first_answer }
    it_behaves_like "Votable"
  end

  describe '.send_answer_notification' do
    let(:answer) { build :answer }

    it 'should send notification after creating' do
      expect(AnswerNotificationJob).to receive(:perform_later).with(answer)
      answer.save!
    end

    it 'should send notification after update' do
      answer.save!
      expect(AnswerNotificationJob).to_not receive(:perform_later)
      answer.update(body: "new body")
    end
  end
end
