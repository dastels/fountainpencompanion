require 'rails_helper'

describe BrandsController do
  fixtures :collected_inks

  describe '#index' do

    it 'returns all brands by default' do
      get :index, params: { term: '' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(["Diamine", "Robert Oster"])
    end

    it 'filters by term' do
      get :index, params: { term: 'Dia' }
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(["Diamine"])
    end
  end
end