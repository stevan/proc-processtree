package Proc::ProcessTree;
use Moose;
use MooseX::Params::Validate;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Proc::ProcessTable;

use Proc::ProcessTree::Tree;

use Forest::Tree::Writer::SimpleASCII;
use Forest::Tree::Loader::SimpleUIDLoader;

has 'tree' => (
    is       => 'ro',
    isa      => 'Proc::ProcessTree::Tree',   
    lazy     => 1,
    builder  => 'build_tree',
);

sub build_tree {
    my $self = shift;
    
    my $root   = Proc::ProcessTree::Tree->new;
    my $loader = Forest::Tree::Loader::SimpleUIDLoader->new(
        tree       => $root,
        row_parser => sub { 
            my $proc = shift;
            $proc, $proc->pid, $proc->ppid
        }
    );
    
    my $p = Proc::ProcessTable->new;
    
    $loader->load($p->table);
    
    $root;
}

sub find_proc_tree_for {
    my ($self, $pid) = validatep(\@_, 
        pid => { isa => 'Int' },
    );    
    eval {
        $self->tree->traverse(sub {
            my $t = shift;
            die $t if $t->pid == $pid;
        });
    };
    if ($@) {
        return $@ if blessed $@ and $@->isa('Forest::Tree');
        die $@;
    }
    die "Could not find tree node for $pid";
}

no Moose; 1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS 

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
