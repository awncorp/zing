package
  MyApp::Time;

use parent 'Zing::Process';

my $i = 0;
my $time = time;

sub perform {
  warn time, ' ', 'tick', ' ', ($i = (time == $time ? $i+1 : do{$time=time; 0}));
}

1;
