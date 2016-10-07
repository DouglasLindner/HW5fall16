# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

 Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    Movie.create movie #active record call to create movies
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  allRatings = ['G', 'PG', 'PG-13', 'NC-17', 'R']
  ratings = arg1
  ratings.upcase!
  selectedRatings = ratings.split(", ") #create array of selected ratings
  selectedRatings.uniq!
  unselectedRatings = allRatings - selectedRatings #create array of unselected ratings
  selectedRatings.each {|x|
    id = "ratings[" + x + "]"
    check id #check appropriate desired ratings
  }
  unselectedRatings.each {|x|
    id = "ratings[" + x + "]"
    uncheck id #uncheck appropriate undesired ratings
  }
  click_button('ratings_submit')
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = arg1
  ratings.upcase!
  selectedRatings = ratings.split(", ") #create array of selected ratings
  selectedRatings.uniq!
  size = Movie.where(:rating => selectedRatings).all.size #find number of movies with selected ratings in database
  size.should == ((page.all('table#movies tr').count) - 1) #find number of movies with selected ratings in html and compare with database query
  page.all('table#movies td').each {|td| #navigate through table records
    if td.inspect.last(4).first == "2" #look at tables column
      expect(selectedRatings.include?(td.text)).to be_truthy #make sure rating is in expected ratings array
    end
  }  
end

Then /^I should see all of the movies$/ do
  size = Movie.all.size #count all movies in database
  size.should == ((page.all('table#movies tr').count) - 1) #find number of movies in html and compare with database query
end

When /^I filter on "(.*?)"$/ do |filter|
  click_link(filter)
end


Then /^I should see all of the movies filtered by "(.*?)"$/ do |filter|
  colMapping = {"title" => "1", "release_date" => "3"} #mapping based on desired filter to promote dryness
  elementList = ""
  page.all('table#movies td').each {|td| #look through all table cells
    if td.inspect.last(4).first == colMapping[filter] #checking the column of the data values
      elementList << td.text #push all of the html data values into an array
    end
  }  
  elements = Movie.order(filter) #Getting all elements from database filtered on input column
  expectedElementList = ""
  elements.each {|x|
    hashX = x.to_json
    expectedElementList << x[filter].to_s #converting hash format to array format
  }
  expect(elementList == expectedElementList).to be_truthy #expect database ordering to equal html ordering
end


Then /^I should see "(.*?)" before "(.*?)"$/ do |arg1, arg2|
  expect(page.body =~ /#{arg1}.*#{arg2}/m).to be_truthy #point check for reg expression matching
end