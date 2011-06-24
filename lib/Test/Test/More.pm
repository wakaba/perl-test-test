package Test::Test::More;
use strict;
use warnings;
our $VERSION = '1.0';
use Test::More;
use Exporter::Lite;

our @EXPORT = qw(test_ok_ok test_ng_ok failure_output_like);

sub _run_test ($) {
    my $code = shift;
    
    open my $file1, '>', \(my $s = '');
    open my $file2, '>', \(my $t = '');
    open my $file3, '>', \(my $u = '');
    
    {
        my $builder = Test::Builder->create;
        $builder->output($file1);
        $builder->failure_output($file2);
        $builder->todo_output($file3);
        no warnings 'redefine';
        local *Test::More::builder = sub { $builder };

        # For Test::Class
        my $diag = \&Test::Builder::diag;
        local *Test::Builder::diag = sub {
            shift;
            $diag->($builder, @_);
        };

        # For Test::Differences
        local *Test::Builder::new = sub { $builder };
        
        $code->();
    }
    
    close $file1;
    close $file2;
    close $file3;

    return {output => $s, failure_output => $t, todo_output => $u};
}

sub test_ok_ok (&;$) {
    my ($code, $name) = @_;
    my $result = _run_test($code);
    
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    like $result->{output}, qr[^ok ], $name;
}

sub test_ng_ok (&;$) {
    my ($code, $name) = @_;
    my $result = _run_test($code);
    
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    like $result->{output}, qr[^not ok ], $name;
}

sub failure_output_like (&$;$) {
    my ($code, $regexp, $name) = @_;
    my $result = _run_test($code);
    
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    like $result->{failure_output}, $regexp, $name;
}

1;
