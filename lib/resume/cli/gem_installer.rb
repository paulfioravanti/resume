require_relative '../output'
require_relative 'exceptions'
require_relative 'exception_suppressor'

module Resume
  module CLI
    class GemInstaller
      include ExceptionSuppressor
      extend Forwardable

      attr_reader :gems

      def self.gem_already_installed?(name, version)
        Gem::Specification.find_by_name(name).version ==
          Gem::Version.new(version)
      end
      private_class_method :gem_already_installed?

      def initialize(gems)
        @gems = gems
      end

      def_delegator self, :gem_already_installed?

      def audit_gem_dependencies
        gems.each do |name, version|
          # if gem not installed: leave in the gems list
          suppress(Gem::LoadError, -> { next }) do
            if gem_already_installed?(name, version)
              # remove dependency to install
              self.gems -= [[name, version]]
            end
          end
        end
      end

      def output_gem_dependencies
        return if gems.none?
        Output.warning(:ruby_gems)
        gems.each do |name, version|
          Output.plain([
            :gem_name_and_version, { name: name, version: version }
          ])
        end
      end

      def gems_successfully_installed?
        return true if gems.none?
        Output.plain(:installing_ruby_gems)
        gems.all? do |gem, version|
          Kernel.system('gem', 'install', gem, '-v', version)
        end
      rescue SocketError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      ensure
        # Reset dir and path values so just-installed gems can
        # be required, but also have this here so that the
        # return value for this method is a boolean
        Gem.clear_paths
      end

      private

      attr_writer :gems
    end
  end
end
