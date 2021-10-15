require 'rails_helper'

describe Movie do
  context 'find movies by the same director' do
    it 'matches movies with the same director' do
      movie1 = Movie.create!(id:100, title: "Pulp Fiction", director: "Quentin Tarantino")
      movie2 = Movie.create!(id:101, title: "Inglourious Basterds", director: "Quentin Tarantino")
      movies = Movie.similar_director_movies(movie1.title)
      expect(movies).to eq([movie1, movie2])
    end        
  end    

  context 'single movie by that director' do
    it 'does not matches any other movies with the same director' do
      movie1 = Movie.create!(id: 200, title: "Sad Life", director: "Ankur Nath")
      movie2 = Movie.create!(id: 136, title: "Great Life", director: "Donald Trump")
      results = Movie.similar_director_movies(movie1.title)
      expect(results).not_to eq([movie1, movie2])
    end
  end
end