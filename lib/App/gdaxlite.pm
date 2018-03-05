package App::gdaxlite;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

our %SPEC;

my %args_common = (
    endpoint => {
        schema => 'str*', # XXX uri
        req => 1,
        pos => 0,
    },
    args => {
        'x.name.is_plural' => 1,
        'x.name.singular' => 'arg',
        schema => ['hash*', of=>'str'],
        pos => 1,
        greedy => 1,
    },
    method => {
        schema => 'str*',
        default => 'GET',
    },
);

my %args_credentials = (
    key => {
        schema => ['str*'],
        req => 1,
    },
    secret => {
        schema => ['str*'],
        req => 1,
    },
    passphrase => {
        schema => ['str*'],
        req => 1,
    },
);

my ($gdaxpub, $gdaxpriv);

sub _init {
    require Finance::GDAX::Lite;
    my ($args) = @_;
    $gdaxpub  //= Finance::GDAX::Lite->new();
    $gdaxpriv //= Finance::GDAX::Lite->new(
        key        => $args->{key},
        secret     => $args->{secret},
        passphrase => $args->{passphrase},
    );
}

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Lite CLI for GDAX',
};

$SPEC{public} = {
    v => 1.1,
    summary => 'Perform a public API request',
    args => {
        %args_common,
    },
};
sub public {
    my %args = @_;
    _init(\%args);
    $gdaxpub->public_request(
        $args{method},
        $args{endpoint},
        $args{args},
    );
}

$SPEC{private} = {
    v => 1.1,
    summary => 'Perform a public API request',
    args => {
        %args_credentials,
        %args_common,
    },
};
sub private {
    my %args = @_;
    _init(\%args);
    $gdaxpriv->private_request(
        $args{method},
        $args{endpoint},
        $args{args},
    );
}

1;
# ABSTRACT:

=head1 SYNOPSIS

Please see included script L<gdaxlite>.


=head1 SEE ALSO

L<Finance::GDAX::Lite>
