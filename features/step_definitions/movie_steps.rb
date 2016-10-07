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


 Then /^(?:|I )should see "(.*?)"$/ do |text|
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
  #pending  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
      Movie.create!(movie)
      
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split(',')
    all('input[type=checkbox]').each do |checkbox|
     if checkbox.checked? then 
      uncheck(checkbox[:id])
     end
    end
    ratings.each do |rating|
        check("ratings_"+rating.gsub(/\s+/, ""))
    end
    click_button 'Refresh'


end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    ratings = arg1.split(',')
    allCorrectRatings=true
    all("tr").each do |tr|
        correctRating=false
        ratings.each do |rating|
            if tr.has_content?(rating.gsub(/\s+/, ""))
                correctRating=true
            end
        end
        allCorrectRatings = allCorrectRatings && correctRating
    end  
    expect(allCorrectRatings).to be_truthy
    
end

Then /^I should see all of the movies$/ do
    #movies = Movie.all
    #allThere=true
    #movies.each do |movie|
    #    containsMovie=false
    #    all("tr").each do |tr|
    #        if tr.has_content?(movie[:title])
    #            containsMovie=true
    #        end
    #    end
    #    allThere = allThere && containsMovie
    #end 
        
    #expect(allThere).to be_truthy

    (page.all('table#movies tr').count-1).should == Movie.all.count

end



 When /^I have clicked on: "(.*?)"$/ do |arg1|
   click_on arg1
 end


 Then /^(?:|I )should see the movie "(.*?)" before "(.*?)"$/ do |movie1,movie2|
    match = /#{movie1}.*#{movie2}/m =~ page.body
    
    expect(match).to be_truthy
 end
