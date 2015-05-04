  context 'user is on a mac' do
    # before { stub_const('RUBY_PLATFORM', 'darwin') }

    it 'opens the file using the open command' do
      # expect(cli).to \
      #   receive(:system).with("open #{document_name}.pdf")
      # cli.send(:clean_up)
    end
  end

  context 'user is on linux' do
    # before { stub_const('RUBY_PLATFORM', 'linux') }

    it 'opens the file using the xdg-open command' do
    #   expect(cli).to \
    #     receive(:system).with("xdg-open #{document_name}.pdf")
    #   cli.send(:clean_up)
    end
  end

  context 'user is on windows' do
    # before { stub_const('RUBY_PLATFORM', 'windows') }

    it 'opens the file using the cmd command' do
    #   expect(cli).to \
    #     receive(:system).
    #       with("cmd /c \"start #{document_name}.pdf\"")
    #   cli.send(:clean_up)
    end
  end

  context 'user is on an unknown operating system' do
    # before { stub_const('RUBY_PLATFORM', 'unknown') }

    it 'prints a message telling the user to open the file' do
    #   expect(cli).to \
    #     receive(:request_user_to_open_document).and_call_original
    #   cli.send(:clean_up)
    end
  end
