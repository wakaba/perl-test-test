package test::Test::Test::More;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->parent->subdir('lib')->stringify;
use base qw(Test::Class);
use Test::More;
use Test::Differences;
use Test::Test::More;

sub _test_ok_ok_ok : Test(1) {
    test_ok_ok {
        test_ok_ok {
            ok 1;
        };
    };
}

sub _test_ok_ok_ng : Test(1) {
    test_ng_ok {
        test_ok_ok {
            ok 0;
        };
    };
}

sub _test_ng_ok_ok : Test(1) {
    test_ok_ok {
        test_ng_ok {
            ok 0;
        };
    };
}

sub _test_ng_ok_ng : Test(1) {
    test_ng_ok {
        test_ng_ok {
            ok 1;
        };
    };
}

sub _eq_or_diff : Test(2) {
    test_ok_ok {
        eq_or_diff 1, 1;
    };
    test_ng_ok {
        eq_or_diff 1, 2;
    };
}

sub _failure_output_like : Test(2) {
    failure_output_like {
        eq_or_diff 1, 1;
    } qr<^$>;

    failure_output_like {
        eq_or_diff 'ab', 'ac';
    } qr<\Q
# +---+\E-+\Q+----------+
# | Ln|Got\E +\Q|Expected  |
# +---+\E-+\Q+----------+
# *  1|\E'?ab'? +\Q|\E'?ac'? +\Q*
# +---+\E-+\Q+----------+
\E>;
}

__PACKAGE__->runtests;

1;
