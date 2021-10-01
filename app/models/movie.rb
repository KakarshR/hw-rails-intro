class Movie < ActiveRecord::Base

    #Get all unique ratings
    def self.all_ratings
      select(:rating).map(&:rating).uniq
    end
    
    # get all movies with ratings 
    def self.with_ratings(ratings)
        Movie.where(rating:ratings) 
    end
    
end