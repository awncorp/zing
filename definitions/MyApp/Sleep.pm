package MyApp::Sleep;

use parent 'Zing::Process';

sub perform {
  warn $$, ' ', time; sleep 1;
}

1;
