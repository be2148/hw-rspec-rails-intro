require 'cgi'

class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.find_in_tmdb(params, api_key = ENV['TMDB_API_KEY'])
    url = "https://api.themoviedb.org/3/search/movie?api_key=#{api_key}&query=#{CGI.escape(params[:title].to_s)}"
    url += "&year=#{params[:release_year]}" if params[:release_year].present?
    url += "&language=#{params[:language]}" if params[:language].present? && params[:language] != 'all'
    response = Faraday.get(url)
    results = JSON.parse(response.body)['results']
    results.map do |r|
      Movie.new(
        title: r['title'],
        release_date: r['release_date'].present? ? Date.parse(r['release_date']) : nil,
        rating: 'R'
      )
    end
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
end
