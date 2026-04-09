require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe 'searching TMDB by keyword' do
    it 'calls Faraday gem with NYU domain' do
      fake_response = double('response', body: '{"results":[]}')
      expect(Faraday).to receive(:get).and_return(fake_response)
      Movie.find_in_tmdb({title: 'hardware', language: 'en'})
    end
    it 'calls TMDb with valid API key' do
      Movie.find_in_tmdb({title: 'hardware', language: 'en'})
    end
  end
end
