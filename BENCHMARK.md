## Note

There is an open issue on these results
* https://github.com/rubyops/duality/issues/2

* * * * *

## Ruby 1.9.3p194

* note run on a single cpu virtual machine
 
#### small string * 100000
<pre>
           user     system      total        real
disk.set   2.690000  11.220000  13.910000 ( 13.923081)
mong.set  12.230000   1.800000  14.030000 ( 14.061016)
dual.set 104.550000  12.390000 116.940000 (117.742059)
disk.get   4.550000   1.940000   6.490000 (  6.536653)
mong.get  10.980000   2.080000  13.060000 ( 56.598212)
dual.get   3.430000   2.230000   5.660000 (  5.693351)
</pre>
 
 
#### large hash * 100000
<pre>
          user     system      total        real
disk.set  27.230000   8.130000  35.360000 ( 35.404013)
mong.set  81.920000   5.820000  87.740000 ( 87.989885)
dual.set 209.630000  28.940000 238.570000 (239.966954)
disk.get  38.580000   3.270000  41.850000 ( 41.953512)
mong.get  31.890000   3.910000  35.800000 (121.901871)
dual.get  23.910000   2.790000  26.700000 ( 26.761665)
</pre>

* * * * *

## Ruby 1.9.3p194

* run on an 8 core physical box with mongo on a localhost
 
#### small string * 100000
<pre>
         user        system    total       real
disk.set   3.460000   5.090000   8.550000 ( 26.358104)
mong.set   5.140000   0.460000   5.600000 (  5.617677)
dual.set 105.000000  22.010000 127.010000 (147.109562)
disk.get   2.000000   0.380000   2.380000 (  2.401359)
mong.get  15.450000   2.170000  17.620000 ( 20.692795)
dual.get   1.410000   0.430000   1.840000 (  1.845777)
</pre>
 
 
#### large hash * 100000
<pre>
         user        system    total       real
disk.set  19.020000   7.510000  26.530000 ( 60.840357)
mong.set  35.940000   0.800000  36.740000 ( 36.865466)
dual.set 203.200000  35.660000 238.860000 (235.429576)
disk.get  20.690000   0.730000  21.420000 ( 21.509426)
mong.get  34.310000   4.150000  38.460000 ( 44.444895)
dual.get  11.350000   0.820000  12.170000 ( 12.217972)
</pre>

