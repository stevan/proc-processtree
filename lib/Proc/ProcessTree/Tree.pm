package Proc::ProcessTree::Tree;
use Moose;
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Forest::Tree';

# NOTE:
# need to do this in order to 
# +node, since that requires a
# valid type to exist already
# - SL
subtype 'Proc::ProcessTable::Process'
    => as 'Object'
    => where { $_->isa('Proc::ProcessTable::Process') };

has '+node' => (
    isa     => 'Proc::ProcessTable::Process',  
    handles => {
        # make Proc::ProcessTable::Process API 
        # a little less cryptic - SL
        percent_cpu    => 'pctcpu',
        percent_memory => 'pctmem',
        command_line   => 'cmndline',
        process_group  => 'pgrp',
        session_id     => 'sess',
        file_name      => 'fname',
        start_time     => 'start',
        map {
            $_ => $_
        } qw[
            uid gid pid ppid priority ttynum flags
            time ctime size rss wchan state ttydev
        ]             
    }
);

sub to_string {
    my $self = shift;
    sprintf("[ %s ( %s )  %s ] %s" => (
        $self->pid, 
        $self->percent_cpu, 
        scalar(localtime($self->start_time)),
        $self->command_line
    ));
}

sub view {
    my ($self, %options) = @_;
    
    $options{node_formatter} ||= sub { (shift)->to_string };
    
    Forest::Tree::Writer::SimpleASCII->new(
        tree => $self, %options
    );
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
