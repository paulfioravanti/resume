require_relative '../../resume/pdf/document'
require_relative 'colours'

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
          },
          ja: {
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
          }
        }[locale]
      end

      def request_user_to_open_document
        puts yellow(messages[__method__])
      end

      private

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
