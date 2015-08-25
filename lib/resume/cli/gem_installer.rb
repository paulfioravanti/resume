require_relative '../exceptions'

module Resume
  module CLI
    class GemInstaller
      attr_reader :gems

      def initialize(gems)
        @gems = gems
      end

      def audit_gem_dependencies
        gems.each do |name, version|
          begin
            if gem_already_installed?(name, version)
              # remove dependency to install
              self.gems -= [[name, version]]
            end
          rescue Gem::LoadError
            # gem not installed: leave in the gems list
            next
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
          system('gem', 'install', gem, '-v', version)
        end
      rescue SocketError, Errno::ECONNREFUSED
        raise NetworkConnectionError
      ensure
        # Reset dir and path values so just-installed gems can be required
        Gem.clear_paths
      end

      private

      attr_writer :gems

      def gem_already_installed?(name, version)
        Gem::Specification.find_by_name(name).version ==
          Gem::Version.new(version)
      end
    end
  end
end
