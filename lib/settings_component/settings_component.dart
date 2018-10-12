library settings;

import 'dart:html';

import 'package:WhynClient/common/dialog_manager.dart';
import 'package:WhynClient/lss/lss.dart';
import 'package:WhynClient/kernel/kernel.dart';

part 'src/component.dart';
part 'src/view.dart';
part 'src/controller.dart';
part 'src/model.dart';

// sn sm sf an aa ab ac ad ae af ma mb mc md me mf fa fb fc fd fe ff
//  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22

//                     33322222222221111111111000000000
//                     21098765432109876543210987654321
// int sn = int.parse('00000000000000000000000000000001', radix: 2); // 1 (pos 1)
// int sm = int.parse('00000000000000000000000000000010', radix: 2); // 2 (pos 2)
// int sf = int.parse('00000000000000000000000000000100', radix: 2); // 4 (pos 3)
// int an = int.parse('00000000000000000000000000001000', radix: 2); // 8 (pos 4)
// ...
// int ff = int.parse('00000000001000000000000000000000', radix: 2); // 2097152 (pos 22)
//                     21098765432109876543210987654321
//                     33322222222221111111111000000000
// iam                             11000000000010000010
// d1                                    1      1   1  
// d1: 8708                              10000001000100
// d2                                    1     1    1  
// d2: 8324                              10000010000100
// d3                                    1       1  1  
// d3: 8228                              10000000100100
// d4                                    1    1     1  
// d4: 8452                              10000100000100

// int iam = sm^ad^fc^fd;
// print('iam: $iam');
// print(iam.toRadixString(2));

// int d1 = sf^ac^md;
// print('d1: $d1');
// print(d1.toRadixString(2));

// int d2 = sf^ad^md;
// print('d2: $d2');
// print(d2.toRadixString(2));

const int sn = 1; // 1
const int sm = 2; // 2
const int sf = 4; // 3
const int an = 8; // 4
const int aa = 16; // 5
const int ab = 32; // 6
const int ac = 64; // 7
const int ad = 128; // 8
const int ae = 256; // 9
const int af = 512; // 10
const int ma = 1024; // 11
const int mb = 2048; // 12
const int mc = 4096; // 13
const int md = 8192; // 14
const int me = 16384; // 15
const int mf = 32768; // 16
const int fa = 65536; // 17
const int fb = 131072; // 18
const int fc = 262144; // 19
const int fd = 524288; // 20
const int fe = 1048576; // 21
const int ff = 2097152; // 22
// const int : 4194304; // 23
// const int : 8388608; // 24
// const int : 16777216; // 25
// const int : 33554432; // 26
// const int : 67108864; // 27
// const int : 134217728; // 28
// const int : 268435456; // 29
// const int : 536870912; // 30
// const int : 1073741824; // 31
// const int : 2147483648; // 32

Map se = {
  'sn': sn,
  'sm': sm,
  'sf': sf,
  'an': an,
  'aa': aa,
  'ab': ab,
  'ac': ac, 
  'ad': ad, 
  'ae': ae, 
  'af': af, 
  'ma': ma, 
  'mb': mb, 
  'mc': mc, 
  'md': md, 
  'me': me, 
  'mf': mf, 
  'fa': fa, 
  'fb': fb, 
  'fc': fc, 
  'fd': fd, 
  'fe': fe, 
  'ff': ff,
};

List ses = [sn, sm, sf];
List sea = [an, aa, ab, ac, ad, ae, af];
List sem = [ma, mb, mc, md, me, mf];
List sef = [fa, fb, fc, fd, fe, ff];

Map es = reverse(se);

Map reverse(Map a) {
  Map b = {};
  a.forEach((String k, int v) {
    if (ses.contains(v) || sea.contains(v)) b[v] = k.substring(1);
    else b[v] = k;
  });
  return b;
}

