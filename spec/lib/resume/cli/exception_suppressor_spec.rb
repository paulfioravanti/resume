require 'resume/cli/exception_suppressor'

module Resume
  module CLI
    RSpec.describe ExceptionSuppressor do
      let(:suppressable) do
        Class.new do
          include ExceptionSuppressor

          def suppress_exception_both_params(exception_to_ignore, default, &block)
            suppress(exception_to_ignore, default, &block)
          end

          def suppress_exception_one_param(exception_to_ignore, &block)
            suppress(exception_to_ignore, &block)
          end

          def suppress_exception_without_params(&block)
            suppress(&block)
          end
        end.new
      end
      let(:suppressing_exception) do
        -> { suppress_exception }
      end

      describe '#suppress_exception_with_both_params' do
        let(:exception) { SystemExit }
        let(:suppress_exception) do
          suppressable.suppress_exception_both_params(exception, default) do
            fail exception_to_raise
          end
        end

        context 'when specified exception to ignore is raised' do
          let(:exception_to_raise) { exception }

          context 'default value is callable' do
            let(:value) { 'foo' }
            let(:default) { -> { value } }

            it 'returns the default value' do
              expect(suppress_exception).to eq(value)
            end
          end

          context 'default value is not callable' do
            let(:default) { 'bar' }

            it 'returns the default value' do
              expect(suppress_exception).to eq(default)
            end
          end
        end

        context 'when a non-ignored exception is raised' do
          let(:exception_to_raise) { LoadError }
          let(:default) { 'bar' }

          it 'raises the non-ignored exception' do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end

      describe '#suppress_exception_with_one_param' do
        let(:exception) { SystemExit }
        let(:suppress_exception) do
          suppressable.suppress_exception_one_param(exception) do
            fail exception_to_raise
          end
        end

        context 'when specified exception to ignore is raised' do
          let(:exception_to_raise) { exception }

          it 'returns the default value' do
            expect(suppress_exception).to be nil
          end
        end

        context 'when a non-ignored exception is raised' do
          let(:exception_to_raise) { LoadError }

          it 'raises the non-ignored exception' do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end

      describe '#suppress_exception_without_params' do
        let(:suppress_exception) do
          suppressable.suppress_exception_without_params do
            fail exception_to_raise
          end
        end

        context 'returns the default value' do
          let(:exception_to_raise) { StandardError }

          it 'rescues from StandardError' do
            expect(suppress_exception).to be nil
          end
        end

        context 'when a non-ignored exception is raised' do
          let(:exception_to_raise) { LoadError }

          it 'raises the non-ignored exception' do
            expect(suppressing_exception).to \
              raise_error(exception_to_raise)
          end
        end
      end
    end
  end
end
