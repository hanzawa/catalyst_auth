package MyApp::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

MyApp::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 login_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 login_password

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 last_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 created_at

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "login_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "login_password",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "last_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "created_at",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->add_unique_constraint("login_id", ["login_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-11-01 20:48:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:o9jFCI+wdiCNZgeA6pZ/Ag

__PACKAGE__->has_many('user_email' => 'MyApp::Schema::Result::UserEmail', 'user_id');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
