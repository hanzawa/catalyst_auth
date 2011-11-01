package MyApp::Controller::Login;
use Moose;
use namespace::autoclean;

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


	if ($c->req->method eq 'POST'){

		$c->stash->{login}->{id} = $c->req->param('login_id');
		$c->stash->{login}->{password} = $c->req->param('login_password');

		$c->form(login_id => [qw/NOT_BLANK/], login_password => [qw/NOT_BLANK/] );
		if ($c->form->has_error){
			$c->stash->{template} = 'login/index.tt';
			$c->detach();
		}

		my $userTBL;
		if($c->stash->{login}->{id} =~ m/@/gis){
			$userTBL = $c->model('DBIC::User')->search({
				'user_email.email' => $c->stash->{login}->{id},
			},{
				prefetch => 'user_email',
			})->next;
		        # SELECT user.login_password FROM user_email me 
			# INNER JOIN user user ON user.user_id = me.user_id WHERE ( email = ? )
		}else{
			$userTBL = $c->model('DBIC::User')->search({
				login_id => $c->stash->{login}->{id},
			})->next;
		}
		if(Crypt::SaltedHash->validate($userTBL->login_password, $c->stash->{login}->{password})){
			$c->session->{root}->{last_name} = $userTBL->last_name;
			$c->res->body("ok<br>".$c->session->{root}->{last_name}."さん！ようこそ"); $c->detach();
		}else{
			$c->stash->{error}->{login} = 1;
			$c->stash->{template} = 'login/index.tt';
			$c->detach();
		}

		
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
