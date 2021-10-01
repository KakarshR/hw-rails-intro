class Movie < ActiveRecord::Base

    def self.all_ratings
      return ['G', 'PG', 'PG-13' ,'R'] #collection of movie ratings
    end
    
    def self.with_ratings(ratings)
        if ratings.nil? #no rating is selected
            Movie.all
        else #filetering by a particular rating
            Movie.where(rating:ratings)
        end
    end
end