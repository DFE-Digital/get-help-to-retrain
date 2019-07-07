Then('I should see the alternative titles under the first result title') do
  find("li.govuk-\!-padding-bottom-3:nth-child(1) > p:nth-child(2)").text.should != ''
end
