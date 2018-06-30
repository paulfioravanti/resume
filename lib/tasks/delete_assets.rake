require "tmpdir"
require_relative "../resume/output"

namespace :resume do
  desc "Delete assets downloaded into the local tmpdir"
  task :delete_assets do
    Resume::Output.raw_warning("Deleting assets in the tmpdir...")

    # Remove all resume prefixed files and the font files used
    # in the Japanese language resume.
    File.delete(*Dir.glob(File.join(Dir.tmpdir, "resume_*")))
    File.delete(*Dir.glob(File.join(Dir.tmpdir, "ipa?p.ttf")))

    Resume::Output.raw_success("Successfully deleted assets")
  end
end
