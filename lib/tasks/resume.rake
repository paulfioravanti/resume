require_relative 'one_sheet_resume'

desc 'Generate the one-file resume from the application'
task :resume do
  OneSheetResume.generate
end
