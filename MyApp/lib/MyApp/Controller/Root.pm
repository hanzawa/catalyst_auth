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

	$c->stash->{user}->{login_id} = $c->req->param('login_id') || '';
	$c->stash->{user}->{login_password} = $c->req->param('login_password') || '';
	$c->stash->{user}->{last_name} = $c->req->param('last_name') || '';
	$c->stash->{user}->{email_pc} = $c->req->param('email_pc') || '';
	$c->stash->{user}->{email_mb} = $c->req->param('email_mb') || '';

	# -- validation --------------
	$c->form(
		login_id => [
			qw/NOT_BLANK/,
			['DBIC_UNIQUE', $c->model('DBIC::User'), 'login_id'],
			['REGEX', qr/^[a-zA-Z0-9]{1,}$/],
			[qw/LENGTH 4 16/]
		],
		login_password => [
			qw/NOT_BLANK/,
			['REGEX', qr/^[a-zA-Z0-9]{1,}$/],
			[qw/LENGTH 8 32/]
		],
        	email_pc => [
        		qw/NOT_BLANK EMAIL_LOOSE/,
 			['DBIC_UNIQUE', $c->model('DBIC::UserEmail'), 'email'],
        	],
        	email_mb => [
        		qw/NOT_BLANK EMAIL_LOOSE/,
 			['DBIC_UNIQUE', $c->model('DBIC::UserEmail'), 'email'],
 		],
        	last_name => [
        		qw/NOT_BLANK/,
 		],
	);

	$c->stash->{error}->{same_email} = 1 if( $c->stash->{user}->{email_pc}
		&& $c->stash->{user}->{email_mb}
		&& ($c->stash->{user}->{email_pc} eq $c->stash->{user}->{email_mb}));

	if ($c->form->has_error || $c->stash->{error}->{same_email}){
		$c->stash->{template} = 'index.tt';
		$c->detach();
	}

	# -- 暗号化 ------------------
	my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-512');
	$csh->add($c->stash->{user}->{login_password});

	# -- DB_INSERT ------------------
	my $txn = sub {

	my $ls = $c->model('DBIC::User')->create({
			last_name => $c->stash->{user}->{last_name},
			login_id => $c->stash->{user}->{login_id},
			login_password => $csh->generate,
			created_at => \'NOW()'
	});

	$c->model('DBIC::UserEmail')->create({
			user_id => $ls->id,
			email => $c->stash->{user}->{email_pc},
			flag => 1,
	}) if $c->stash->{user}->{email_pc};

	$c->model('DBIC::UserEmail')->create({
			user_id => $ls->id,
			email => $c->stash->{user}->{email_mb},
			flag => 2,
	}) if $c->stash->{user}->{email_mb};

	};

	my $re = $c->do_txn($c->model('DBIC'), $txn );
	if($@){ $c->res->body("DB ERROR");$c->detach();}
	$c->res->body("ok, let's try <a href='/login'>login</a>"); $c->detach();
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

sub render : ActionClass('RenderView'){}

sub end : Private{
    my ( $self, $c ) = @_;
    $c->forward('render');
    $c->res->headers->content_type('text/html; charset=utf-8');
}

=head1 AUTHOR

Kazuya Hanzawa

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
