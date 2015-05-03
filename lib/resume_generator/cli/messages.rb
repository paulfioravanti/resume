require_relative '../../resume_generator/resume/document'

module ResumeGenerator
  module CLI
    module Messages
      include Colours

      def self.included(base)
        base.send(:attr_reader, :messages)
      end

      def initialize_messages
        @messages = {
          en: {
            inform_creation_of_social_media_links:
              'Creating social media links...',
            inform_creation_of_technical_skills:
              'Creating technical skills section...',
            inform_creation_of_employment_history:
              'Creating employment history section...',
            inform_creation_of_education_history:
              'Creating education history section...',
            request_gem_installation:
              "May I please install the following Ruby gems:\n"\
              "- prawn #{ResumeGenerator::PRAWN_VERSION}\n"\
              "- prawn-table #{ResumeGenerator::PRAWN_TABLE_VERSION}\n"\
              "in order to help me generate a PDF (Y/N)? ",
            thank_user_for_permission:
              'Thank you kindly :-)',
            inform_start_of_gem_installation:
              'Installing required gems...',
            inform_start_of_resume_generation:
              "Generating PDF. This shouldn't take longer than a few seconds...",
            inform_of_failure_to_generate_resume:
              "Sorry, I won't be able to generate a PDF\n"\
              "without these specific gem versions.\n"\
              "Please ask me directly for a PDF copy of my resume.",
            inform_of_successful_resume_generation:
              'Resume generated successfully.',
            request_to_open_resume:
              'Would you like me to open the resume for you (Y/N)? ',
            request_user_to_open_document:
              "Sorry, I can't figure out how to open the resume on\n"\
              "this computer. Please open it yourself.",
            inform_of_successful_gem_installation:
              'Gems successfully installed.',
            inform_of_gem_installation_failure:
              "Sorry, for some reason I wasn't able to\n"\
              "install one or more required gems.\n"\
              "Either try again or ask me directly for a PDF copy of "\
              "my resume.",
            inform_of_network_connection_issue:
              "Sorry, it seems I can't get an outside connection.\n"\
              "Please check your internet settings and try again."
          },
          # TODO: Actually localise these messages
          # ja: {
          #   inform_creation_of_social_media_links:
          #     'Creating social media links...',
          #   inform_creation_of_technical_skills:
          #     'Creating technical skills section...',
          #   inform_creation_of_employment_history:
          #     'Creating employment history section...',
          #   inform_creation_of_education_history:
          #     'Creating education history section...',
          #   request_gem_installation:
          #     "May I please install the following Ruby gems:\n"\
          #     "- prawn #{ResumeGenerator::PRAWN_VERSION}\n"\
          #     "- prawn-table #{ResumeGenerator::PRAWN_TABLE_VERSION}\n"\
          #     "in order to help me generate a PDF (Y/N)? ",
          #   thank_user_for_permission:
          #     'Thank you kindly :-)',
          #   inform_start_of_gem_installation:
          #     'Installing required gems...',
          #   inform_start_of_resume_generation:
          #     "Generating PDF. This shouldn't take longer than a few seconds...",
          #   inform_of_failure_to_generate_resume:
          #     "Sorry, I won't be able to generate a PDF\n"\
          #     "without these specific gem versions.\n"\
          #     "Please ask me directly for a PDF copy of my resume.",
          #   inform_of_successful_resume_generation:
          #     'Resume generated successfully.',
          #   print_thank_you_message:
          #     "Thanks for looking at my resume. I hope to hear from you soon!\n"\
          #     "#{filename} has been generated in the same\n"\
          #     "directory you ran the script.",
          #   request_to_open_resume:
          #     'Would you like me to open the resume for you (Y/N)? ',
          #   request_user_to_open_document:
          #     "Sorry, I can't figure out how to open the resume on\n"\
          #     "this computer. Please open it yourself.",
          #   inform_of_successful_gem_installation:
          #     'Gems successfully installed.',
          #   inform_of_gem_installation_failure:
          #     "Sorry, for some reason I wasn't able to\n"\
          #     "install one or more required gems.\n"\
          #     "Either try again or ask me directly for a PDF copy of "\
          #     "my resume.",
          #   inform_of_network_connection_issue:
          #     "Sorry, it seems I can't get an outside connection.\n"\
          #     "Please check your internet settings and try again."
          # }
        }[locale]
      end

      def inform_creation_of_social_media_links
        puts messages[__method__]
      end

      def inform_creation_of_technical_skills
        puts messages[__method__]
      end

      def inform_creation_of_employment_history
        puts messages[__method__]
      end

      def inform_creation_of_education_history
        puts messages[__method__]
      end

      def inform_of_network_connection_issue
        puts red(messages[__method__])
      end

      def inform_of_successful_gem_installation
        puts green(messages[__method__])
      end

      def inform_of_gem_installation_failure
        puts red(messages[__method__])
      end

      def request_user_to_open_document
        puts yellow(messages[__method__])
      end

      private

      def request_gem_installation
        print yellow(messages[__method__])
      end

      def thank_user_for_permission
        puts green(messages[__method__])
      end

      def inform_start_of_gem_installation
        puts messages[__method__]
      end

      def inform_start_of_resume_generation
        puts messages[__method__]
      end

      def inform_of_failure_to_generate_resume
        puts red(messages[__method__])
      end

      def inform_of_successful_resume_generation
        puts green(messages[__method__])
      end

      def print_thank_you_message
        puts cyan(
          {
            en: "Thanks for looking at my resume."\
                "I hope to hear from you soon!\n"\
                "#{filename} has been generated in the same\n"\
                "directory you ran this script."
          }[locale]
        )
      end

      def request_to_open_resume
        print yellow(messages[__method__])
      end
    end
  end
end

