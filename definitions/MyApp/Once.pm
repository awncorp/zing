package
  MyApp::Once;

use parent 'Zing::Process';

sub perform {
  warn $$, ' ', time; shift->shutdown;
}

1;
