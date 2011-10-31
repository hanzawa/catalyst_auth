package MyApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

MyApp::Controller::Root - Root Controller for MyApp

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;


	if ($c->req->method eq 'POST'){
	my $login_id = $c->req->param('login_id') || '';
	my $login_password = $c->req->param('login_password') || '';
	if($login_id && $login_password){
		my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');
		$csh->add($login_password);
		$c->model('DBIC::User')->create({
			login_id => $login_id,
			login_password => $csh->generate,
			created_at => \'NOW()'
		});
		$c->res->body("ok, let's try <a href='/login'>login</a>"); $c->detach();
	}else{ $c->res->body("ng"); $c->detach(); }
	}

}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Kazuya Hanzawa

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
