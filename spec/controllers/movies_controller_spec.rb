require 'rails_helper'

describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end
    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with({title: 'hardware', release_year: '', language: 'all'}).
        and_return(@fake_results)
      get :search_tmdb, params: { title: 'hardware', release_year: '', language: 'all' }
    end
    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        get :search_tmdb, params: { title: 'hardware', release_year: '', language: 'all' }
      end
      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end
      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end
  end

  describe 'adding one movie' do
    before :each do
      @movie_params = { title: 'Hackers', release_date: '1995-09-15', rating: 'R' }
    end
    it 'saves the movie in database' do
      expect(Movie).to receive(:create!).with(@movie_params).and_return(Movie.new(@movie_params))
      post :add_movie, params: @movie_params
    end
    it 'redirects to search page' do
      allow(Movie).to receive(:create!).and_return(Movie.new(@movie_params))
      post :add_movie, params: @movie_params
      expect(response).to redirect_to(search_tmdb_path)
    end
  end
end
