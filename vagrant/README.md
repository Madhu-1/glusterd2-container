## vagrant

This folder contains the vagrant setup which creates the glusterd2 cluster

run below command to bring up glusterd2 vm's

```
./up.sh
```

once the vm's are up ,gather all the vm ip's 
```
./script/vm_ip.sh
```


### peer probe

* replace  glusterd21 ip in addpeer1.json 
* replace  glusterd22 ip in addpeer2.json

send request to glusterd20 for peer probing

* add glusterd21 to the pool

```
#curl -X POST http://<glusterd20_ip>:24007/v1/peers --data @addpeer1.json -H 'Content-Type: application/json'
```

* add glusterd22 to the pool

```
#curl -X POST http://<glusterd20_ip>:24007/v1/peers --data @addpeer2.json -H 'Content-Type: application/json'
```

### pool list

check glusterD2 cluster is formed by getting pool list

```
#curl http://<glusterd20_ip>:24007/v1/peers |python -m json.tool
```


once the glusterd2 cluster is ready lets create volume using glusterd2

### create directory in vm

* glusterd21
```
#vagrant ssh glusterd21

#mkdir -p /dev/brick{1,3}/data
```

* glusterd22
```
#vagrant ssh glusterd22

#mkdir -p /dev/brick{2,4}/data
```

### create volume 

* gather peerid from the glusterd2 pool list

```
#curl http://<glusterd20_ip>:24007/v1/peers |python -m json.tool
```

* replace corresponding peerid in volume_create.json

* send request to glusterd20 to create volume

```
curl -X POST http://<glusterd20_ip>:24007/v1/volumes --data @volume_create.json -H 'Content-Type: application/json'
```

* send request to glusterd20 to start volume

```
curl -X POST http://<glusterd20_ip>:24007/v1/volumes/testvol/start
```
