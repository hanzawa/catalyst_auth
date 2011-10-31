package MyApp::Controller::Login;
use Moose;
use namespace::autoclean;
use Crypt::SaltedHash;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

MyApp::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

	my $login_id = $c->req->param('login_id') || '';
	my $login_password = $c->req->param('login_password') || '';

	if ($c->req->method eq 'POST'){
	if($login_id && $login_password){
	my $password_hash = $c->model('DBIC::User')->search({
			login_id => $login_id
		})->get_column('login_password')->next;
	if(Crypt::SaltedHash->validate($password_hash, $login_password)){
	    $c->res->body("ok"); $c->detach();
	}else{ $c->res->body("ng"); $c->detach(); }
	}else{ $c->res->body("ng"); $c->detach(); }
	}

}


=head1 AUTHOR

Kazuya Hanzawa

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
