require_relative "../resume/output"

namespace :resume do
  desc "Delete assets downloaded into the local tmpdir"
  task :delete_assets do
    Resume::Output.raw_warning("Deleting assets in the tmpdir...")

    File.delete(*Dir.glob(File.join(Dir.tmpdir, "resume_*")))

    Resume::Output.raw_success("Successfully deleted assets")
  end
end
