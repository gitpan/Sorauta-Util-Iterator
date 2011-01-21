# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sorauta-Util-Iterator.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Data::Dumper;
use Carp qw/croak/;
use Test::More tests => 1;

use lib qw(../lib/);
use Sorauta::Util::Iterator;

BEGIN { use_ok('Sorauta::Util::Iterator') };

my $sub_ref = sub {
  dummy_print('fuck')
};

my $itr = Sorauta::Util::Iterator->new;

# 追加テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_add", $/);
  dummy_print("=======================", $/);

  # ハッシュ
  $itr->add('num1', { data => 1, test => "fuck" });
  # 配列
  $itr->add('num2', [ 'data', 1, 'test', "fuck" ]);
  # 文字列
  $itr->add('num3', 'kurenai');
  # 数値
  $itr->add('num4', 109238402389);
  # リファレンス
  $itr->add('sub_ref', $sub_ref);

  dummy_print(Dumper($itr));
}

# 削除テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_del", $/);
  dummy_print("=======================", $/);

  $itr->del('num4');

  dummy_print(Dumper($itr));
}

# 取得テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_get", $/);
  dummy_print("=======================", $/);

  my $val = $itr->get('num1');
  dummy_print(Dumper($val));
  
  $val = $itr->get_by_index(3);
  dummy_print(Dumper($val));
}

# いてレータでのループテスト
{
  dummy_print("=======================", $/);
  dummy_print("test_iterator", $/);
  dummy_print("=======================", $/);

  while (my $val = $itr->next) {
    dummy_print(Dumper($val));
  }

  # ポジションを頭にもどす
  $itr->reset;
  
  dummy_print(Dumper($itr));
}

# 全データ取得テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_all", $/);
  dummy_print("=======================", $/);

  my $all = $itr->all;
  dummy_print(Dumper($all));
}

# 件数取得テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_count", $/);
  dummy_print("=======================", $/);

  dummy_print($itr->count, $/);
}

# ハッシュからいてレータ生成テスト
{
  dummy_print("=======================", $/);
  dummy_print("test_hash2itr", $/);
  dummy_print("=======================", $/);

  my $itr2 = Sorauta::Util::Iterator->new;
  my $hash_list = {
    hoge => 1,
    sample => 2,
    wieht => [1,2,3,5,55,2524352345,23],
    hash => {shi => 1, weoith=>"2", weotj => "hoghehoge"}
  };
  $itr2->hash2itr($hash_list);

  dummy_print(Dumper($itr2));
}

sub dummy_print {
  my(@list) = @_;
  #print join("", @list);
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

