use ExtUtils::MakeMaker;
my $module = 'Mutator.pm';
WriteMakefile(
              NAME         => 'Class::Mutator',
              VERSION_FROM => $module,
              PREREQ_PM    => {
                               Test::More => 0,
                               Memoize => 0.52,
                              },
              AUTHOR       => 'Greg McCarroll <greg@mccarroll.demon.co.uk>',
             );





