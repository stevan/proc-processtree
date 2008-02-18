#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('Proc::ProcessTree');
}

for (0 .. 1000) {
    print Proc::ProcessTree->new
                           ->find_proc_tree_for(pid => 622)
                           ->clone_and_detach
                           ->view
                           ->as_string;
    sleep(1);
    system("clear");
}