require_relative "one_sheet/generator"

namespace :resume do
  desc "Generates the resume code in a single file"
  task :generate_one_sheet do
    OneSheet::Generator.run
  end
end

desc "Generate the 'one-sheet' resume from the application"
task resume: "resume:generate_one_sheet"
