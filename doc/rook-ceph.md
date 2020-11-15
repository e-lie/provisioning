

- Il faut passer pg_num à 64 manuellement pour chaque pool (d'après le calcul indiqué dans Learning Ceph book partie Settings PGs on pool) pour que HEALTH soit OK.

- Il y a des blockpool comme proposé dans hobbykube/storage et du cephfs comme indiqué dans la doc rook  (plus intéressant pour nous) Cf aussi role rook_cephfs