Feature: As a user, I want to see alternate job titles on job detail page, in order to see alaternative relevant jobs.

Given I visit Check your existing skills page
And I Search for a job title keyword
And I see results on the page
Then I should see the alternative title under the result's title
If that is also present on https://nationalcareers.service.gov.uk

Given I visit Explore occupations page
And I Search for a job title keyword
And I see results on the page
Then I should see the alternative title under the result's title
If that is also present on https://nationalcareers.service.gov.uk