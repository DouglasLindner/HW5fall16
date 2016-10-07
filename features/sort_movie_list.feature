Feature: display list of movies sorted by different criteria
 
  As an avid moviegoer
  So that I can quickly browse movies based on my preferences
  I want to see movies sorted by title or release date

Background: movies have been added to database
  
  Given the following movies have been added to RottenPotatoes: 
  | title                   | rating | release_date |
  | Aladdin                 | G      | 25-Nov-1992  |
  | The Terminator          | R      | 26-Oct-1984  |
  | When Harry Met Sally    | R      | 21-Jul-1989  |
  | The Help                | PG-13  | 10-Aug-2011  |
  | Chocolat                | PG-13  | 5-Jan-2001   |
  | Amelie                  | R      | 25-Apr-2001  |
  | 2001: A Space Odyssey   | G      | 6-Apr-1968   |
  | The Incredibles         | PG     | 5-Nov-2004   |
  | Raiders of the Lost Ark | PG     | 12-Jun-1981  |
  | Chicken Run             | G      | 21-Jun-2000  |

  And I am on the RottenPotatoes home page

Scenario: sort movies alphabetically
  When I have opted to see movies rated: "G, PG, PG-13, NC-17, R"
  And  I filter on "movie title" 
  Then I should see all of the movies filtered by "movie title" 
  And  I should see "Aladdin" before "Amelie"
  And  I should see "Chocolat" before "The Incredibles"
  And  I should see "Chicken Run" before "The Help"

#Scenario: sort movies in increasing order of release date
  When I have opted to see movies rated: "G, PG, PG-13, NC-17, R"
  And  I filter on "release date" 
  Then I should see all of the movies filtered by "release date" 
  And  I should see "1992-11-25" before "2011-08-10"
  And  I should see "1968-04-06" before "1981-06-12"
  And  I should see "1984-10-26" before "2000-06-21"
