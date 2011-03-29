Given /^I have a file "(.*?)" containing:$/ do |path, content|
  open(path, 'w') do |file|
    file.puts "$:.unshift '#{LIB}'"
    file.print content
  end
end

When /^I run "(.*?)"$/ do |command|
  @output = `bundle exec #{command} 2>&1`
end

Then /^I should see "(.*?)"$/ do |expected|
  @output.should include(expected)
end
