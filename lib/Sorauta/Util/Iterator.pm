package Sorauta::Util::Iterator;

use 5.010000;
use strict;
use warnings;
use Carp qw/croak/;

our($YES, $NO) = qw/1 0/;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Sorauta::Util::Iterator ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

#=====================
#
#=====================
sub new {
  my $self = shift;

  bless {
    _last_id       => 0,
    _position      => 0,
    _item_key_list => [],
    _item_list     => {},
  }, $self;
}

# リストをセット
# ハッシュのリファレンスを渡す
sub hash2itr {
  my($self, $hash_ref) = @_;

  #$self->{_last_id} = 0;
  #$self->{_position} = 0;
  #$self->{_item_key_list} = [];
  #$self->{_item_list} = {};

  while (my($key, $val) = each(%$hash_ref)) {
    $self->add($key, $val);
  }
}

# 最後尾に追加する
sub add {
  my($self, $key, $val) = @_;

  $self->{_item_list}->{$key} = $val;
  $self->{_item_key_list}->[$self->{_last_id}++] = $key;

  return ;
}

# インデックス指定で上書き
=pod
sub add_at {
  my($self, $key, $val, $index) = @_;

  $self->{_item_list}->{$key} = $val;
  $self->{_item_key_list}->[$index] = $key;

  return ;
}
=cut

# 削除する
sub del {
  my($self, $key) = @_;

  # ハッシュを削除
  delete($self->{_item_list}->{$key});

  # インデックス保持配列削除
  my $index = -1;
  foreach (0..@{$self->{_item_key_list}}) {
    if ($self->{_item_key_list}->[$_] eq $key) {
      $index = $_;
      last;
    }
  }
  if ($index == -1) {
    croak 'not found key';
  }
  splice(@{$self->{_item_key_list}}, $index, 1);

  # 個数を減らす
  $self->{_last_id}--;

  return ;
}

# キー指定で取得
# ※ただし、_positionの移動などは行わない
sub get {
  my($self, $key) = @_;
  
  return $self->{_item_list}->{$key};
}

# インデックス指定で取得
# ※ただし、_positionの移動などは行わない
sub get_by_index {
  my($self, $index) = @_;
  my $key = $self->{_item_key_list}->[$index];
  
  return $self->{_item_list}->{$key};
}

# 次へ
sub next {
  my $self = shift;
  my $key = $self->{_item_key_list}->[$self->{_position}++];
  
  if ($self->{_position} <= $self->{_last_id}) {
    return $self->{_item_list}->{$key};
  }
  else {
    return ;
  }
}

# 次があるか
sub hasNext {
  my $self = shift;

  return $self->{_position} < $self->{_last_id} ? $YES : $NO;
}

# ポジションを最初に戻す
sub reset {
  my $self = shift;

  $self->{_position} = 0;

  return;
}

# 全行取得
sub all {
  my $self = shift;
  my @list = ();

  foreach my $val(values(%{$self->{_item_list}})) {
    push(@list, $val);
  }
  return wantarray ? @list : \@list;
}

# 件数返却
sub count {
  my $self = shift;

  return $self->{_last_id};
}

1;

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Sorauta::Util::Iterator - Simple Iterator

=head1 SYNOPSIS

  use Sorauta::Util::Iterator;
  
  my $itr = Sorauta::Util::Iterator->new;

=head1 DESCRIPTION

Sorauta::Util::Iterator is simple iterator.

=head1 METHODS

=over

=item $itr->add($val);

add new value in iterator

example:
  my $itr = Sorauta::Util::Iterator->new;

  $itr->add('num1', { data => 1, test => "fuck" });
  $itr->add('num2', [ 'data', 1, 'test', "fuck" ]);
  $itr->add('num3', 'kurenai');
  $itr->add('num4', 109238402389);
  $itr->add('sub_ref', $sub_ref); # $sub_ref = sub { print 'hoge' };

=item $itr->del($key);

delete value

example:
  my $itr = Sorauta::Util::Iterator->new;

  $itr->del('key');

=item $itr->get($key);

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  my $val = $itr->get('num1');

=item $itr->get_by_index($index);

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  my $val = $itr->get_by_index(3);

=item $item->next

loop

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  while (my $val = $itr->next) {
    print Dumper($val);
  }

=item $item->hasNext

current iterate position has next?

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  say $itr->hasNext ? 'you have next value' : 'none';

=item $itr->all

get all hash data

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  # get all data by array or array_ref
  my $list = $itr->all;
  or
  my @list = $itr->all;

=item $itr->count

get hash count

example:
  my $itr = Sorauta::Util::Iterator->new;
  
  my $count = $itr->count;

=item $itr->hash2itr($hashref);

hash convert to iterator

example:
  my $itr2 = Sorauta::Util::Iterator->new;
  my $hash_list = {
    hoge => 1,
    sample => 2,
    wieht => [1,2,3,5,55,2524352345,23],
    hash => {shi => 1, weoith=>"2", weotj => "hoghehoge"}
  };
  $itr2->hash2itr($hash_list);

  while (my $val = $itr2->next) {
    print Dumper($val); #=> 1, 2, {shi=>1,...}...
  }

=item $itr->reset;
position reset

example:
  my $itr = Sorauta::Util::Iterator->new;
  $itr->reset;

=head1 AUTHOR

Yuki ANAI, E<lt>yuki@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Yuki ANAI

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
