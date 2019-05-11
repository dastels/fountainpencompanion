require 'rails_helper'

describe UsageRecordsController do
  render_views

  let(:user) { create(:user) }

  describe '#create' do
    let(:currently_inked) { create(:currently_inked, user: user) }

    it 'requires authentication' do
      post :create, params: { currently_inked_id: currently_inked.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'signed in' do
      before(:each) do
        sign_in(user)
      end

      it 'creates a usage record for today' do
        expect do
          post :create, params: { currently_inked_id: currently_inked.id }
          expect(response).to have_http_status(:created)
        end.to change { UsageRecord.count }.from(0).to(1)
        expect(currently_inked.usage_records.count).to eq(1)
        usage_record = currently_inked.usage_records.first
        expect(usage_record.used_on).to eq(Date.today)
      end

      it 'only creates one record for a given day' do
        expect do
          post :create, params: { currently_inked_id: currently_inked.id }
          expect(response).to have_http_status(:created)
          post :create, params: { currently_inked_id: currently_inked.id }
          expect(response).to have_http_status(:created)
        end.to change { UsageRecord.count }.from(0).to(1)
      end
    end
  end

  describe '#index' do

    it 'requires authentication' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'signed in' do
      before(:each) do
        sign_in(user)
      end

      it 'renders the entries' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
