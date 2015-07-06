require_relative '../../resume/pdf/document'

module Resume
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
            inform_of_gem_dependencies:
              "In order to help me generate a PDF, "\
              "I need the following Ruby gems:",
            request_installation_permission:
              'May I please install them? (Y/N) ',
            thank_user_for_permission:
              'Thank you kindly :-)',
            inform_start_of_gem_installation:
              'Installing required gems...',
            inform_start_of_resume_generation:
              "Generating PDF. This shouldn't take longer "\
              "than a few seconds...",
            inform_of_failure_to_generate_resume:
              "Sorry, I won't be able to generate a PDF "\
              "without these specific gem versions.\n"\
              "Please ask me directly for a PDF copy of my resume.",
            inform_of_successful_resume_generation:
              'Resume generated successfully.',
            request_to_open_resume:
              'Would you like me to open the resume for you (Y/N)? ',
            thank_user_for_generating_resume:
              "Thanks for looking at my resume. "\
              "I hope to hear from you soon!\n"\
              "My resume has been generated in the same "\
              "directory you ran this script under the filename:",
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
            inform_of_inability_to_get_outside_connection:
              "Sorry, it seems I can't get an outside connection.",
            request_user_to_check_internet_settings:
              "Please check your internet settings and try again."
          },
          ja: {
            inform_creation_of_social_media_links:
              'ソーシャルメディアリンクを作成中･･･',
            inform_creation_of_technical_skills:
              'スキルセクションを作成中･･･',
            inform_creation_of_employment_history:
              '職歴セクションを作成中･･･',
            inform_creation_of_education_history:
              '学歴セクションを作成中･･･',
            inform_of_gem_dependencies:
              "PDFを生成するために以下のRuby gemが必要です:",
            request_installation_permission:
              'インストールをしてもよろしいですか? (Y/N) ',
            thank_user_for_permission:
              'ありがとうございます(^_^)',
            inform_start_of_gem_installation:
              'Ruby gemsをインストール中･･･',
            inform_start_of_resume_generation:
              "PDFを生成中。少々お待ち下さい･･･",
            inform_of_failure_to_generate_resume:
              "申し訳ありませんが、特定されたRuby gemがないと"\
              "PDFが生成できません。\n"\
              "履歴書PDFが生成できない場合は、直接にお問い合わせ下さい。",
            inform_of_successful_resume_generation:
              '履歴書生成が成功しました。',
            request_to_open_resume:
              '履歴書を開きますか (Y/N)? ',
            thank_user_for_generating_resume:
              "履歴書をご覧いただき、ありがとうございます。"\
              "ご連絡をお待ちしております。\n"\
              "履歴書はこのスクリプトが実行された同ディレクトリ"\
              "に生成されました。",
            request_user_to_open_document:
              "ごめんなさい。使用されているコンピュータでの資料の開き方が"\
              "不明なため、ご自身でご確認ください。",
            inform_of_successful_gem_installation:
              'Ruby gemsのインストールが成功しました。',
            inform_of_gem_installation_failure:
              "ごめんなさい。理由は不明ですが、Ruby gemが"\
              "インストールできませんでした。"\
              "もう一度実行してみるか、または履歴書PDF版のリクエストを"\
              "直接ご連絡下さい。",
            inform_of_inability_to_get_outside_connection:
              "インターネットに接続できません。",
            request_user_to_check_internet_settings:
              "ネットワーク設定をご確認下さい。"
          }
        }[locale]
      end

      def thank_user_for_permission
        puts green(messages[__method__])
      end

      def inform_start_of_gem_installation
        puts messages[__method__]
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
        puts red(messages[:inform_of_inability_to_get_outside_connection])
        puts yellow(messages[:request_user_to_check_internet_settings])
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
        puts yellow(messages[:inform_of_gem_dependencies])
        gems.each do |name, version|
          puts "- #{name} #{version}"
        end
        print yellow(messages[:request_installation_permission])
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

      def thank_user_for_generating_resume
        puts(cyan(messages[__method__]), filename)
      end

      def request_to_open_resume
        print yellow(messages[__method__])
      end
    end
  end
end
