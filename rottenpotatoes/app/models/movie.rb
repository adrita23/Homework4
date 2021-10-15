class Movie < ActiveRecord::Base
    def self.ratings
        return Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
    end
    
    def self.similar_director_movies(title)
        director = Movie.find_by(title: title).director
        return nil if director.blank? or director.nil?
        Movie.where(director: director)
    end
end
