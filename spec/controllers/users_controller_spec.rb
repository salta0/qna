require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do
    session["devise.oauth_data"] = OmniAuth::AuthHash.new(provider: 'twitter', uid: '1234567')
  end

  describe '#POST finish_singup' do
    context 'for new user' do
      it 'creates new user' do
        expect { post :finish_signup, user: attributes_for(:user) }.to change(User, :count).by(1)
      end

      it 'creates authorization' do
         post :finish_signup, user: attributes_for(:user)
         expect(User.first.authorizations.count).to eq 1
      end
    end

    context 'for existing user' do
      let(:user) { create :user }

      it 'do not changes users count' do
        user
        expect{ post :finish_signup, user: { email: user.email } }.to_not change(User, :count)
      end
      
      it 'create authorization for existing user' do
        expect{ post :finish_signup, user: { email: user.email } }.to change(user.authorizations, :count).by(1)
      end
    end

    context 'with invalid email' do
      it "don't creates user" do
        expect{ post :finish_signup, user: { email: 'invalid' } }.to_not change(User, :count)
      end

      it 'render add_email if invalid email' do
        post :finish_signup, user: { email: 'invalid' }
        expect(response).to render_template :add_email
      end
    end
  end
end
