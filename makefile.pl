use ExtUtils::MakeMaker;

WriteMakefile(
NAME => 'Class::Mutator',
VERSION_FROM => 'Mutator.pm',
PM =>     {'Mutator.pm' => '$(INST_LIBDIR)/Mutator.pm',
           },
dist => {
        COMPRESS => 'gzip -9', SUFFIX => 'gz'
},

);
