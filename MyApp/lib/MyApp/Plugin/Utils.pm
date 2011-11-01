package MyApp::Plugin::Utils;

use strict;
use warnings;

sub do_txn {
    my ( $c, $model, $txn ) = @_;

    eval { $model->schema->txn_do($txn); };
    if ($@) {
        if ( $@ =~ /rollback failed/ ) {
            return 'rollback failed :$@'
        }
        else {
            return "rollbacked: $@";
        }
    }
}

1;
