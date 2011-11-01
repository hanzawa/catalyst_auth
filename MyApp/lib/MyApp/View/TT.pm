package MyApp::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT::ForceUTF8';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

MyApp::View::TT - TT View for MyApp

=head1 DESCRIPTION

TT View for MyApp.

=head1 SEE ALSO

L<MyApp>

=head1 AUTHOR

Kazuya Hanzawa

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
