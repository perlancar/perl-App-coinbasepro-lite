package App::coinbasepro::lite;

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

my ($clipub, $clipriv);

sub _init {
    require Finance::CoinbasePro::Lite;
    my ($args) = @_;
    $clipub  //= Finance::CoinbasePro::Lite->new();
    $clipriv //= Finance::CoinbasePro::Lite->new(
        key        => $args->{key},
        secret     => $args->{secret},
        passphrase => $args->{passphrase},
    );
}

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Thin CLI for Coinbase Pro API',
    description => <<'_',

This package offers a thin CLI for accessing Coinbase Pro API (public or
private), mainly for debugging/testing.

_
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
    $clipub->public_request(
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
    $clipriv->private_request(
        $args{method},
        $args{endpoint},
        $args{args},
    );
}

1;
# ABSTRACT:

=head1 SYNOPSIS

Please see included script L<coinbasepro-lite>.


=head1 SEE ALSO

L<Finance::CoinbasePro::Lite>
