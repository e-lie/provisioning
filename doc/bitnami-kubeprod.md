

## Générer/dumper les manifests de bkpr

`kubecfg show kubeprod-manifest.jsonnet >> dump.yaml`


## Faire fonctionner les statefulsets

Il faut attacher une indication `storageClassName: rook-cephfs` à tout les VolumeClaimTemplates des statefulSets comme dans l'exemple de la doc: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#components

Une fois tous les PVC/statefusets ok les services se lancent dans l'ordre de dépendance ce qui prend jusqu'à 5-10 minutes

... elastic-logging -> mariadb-galera -> keycloak