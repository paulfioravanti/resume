require_relative "one_sheet/generator"

namespace :resume do
  task :generate_one_sheet do
    OneSheet::Generator.run
  end
end

desc "Generate the 'one-sheet' resume from the application"
task resume: "resume:generate_one_sheet"
