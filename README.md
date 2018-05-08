# Glusterd2-container
Build docker image from glusterd2 source and glusterfs source
## Build 

if you want to build docker image  from different branch of glusterd2 or glusterfs

edit following section in Dockerfile

### glusterd2

```
    GD2_BRANCH="master"
```

### glusterfs
```
    GLUSTERFS_BRANCH="master"
```

### Buid docker image

Build docker image from source
```
    #docker build . -t <image_name:version>
```


## Run

This will pull the available glusterd2 docker image from the docker hub.

```
docker pull madhupr001/glusterd2
```
run docker container

by default glusterd2 starts with the configuration present in /etc/glusterd2/glusterd2.toml

* run with default configuration
```
    #docker run -d <image_name:version>
```

* run with new  configuration file

    add new configuration file to the docker container and run docker container with new configuration
```
    #docker run -d <image_name:version> --config <new configuration file path>
```

## check glusterd2 version

```
    #curl http://<container-ip>:24007/version
```

## check glusterd2 logs

```
    #docker logs <container-id>
```