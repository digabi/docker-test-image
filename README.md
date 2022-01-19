# docker-test-image
Docker image for unit tests et al

Hosted in https://hub.docker.com/r/digabi/docker-test-image/

* stretch version: digabi/docker-test-image:latest is built from branch `master`
* buster version: digabi/docker-test-image:buster is built from branch `buster`

## Building and publishing stretch image:

```
git checkout master
docker build -t digabi/docker-test-image:latest .
docker login # If not logged in already. See KeePass for digabi Docker Hub credentials
docker push digabi/docker-test-image:latest
```

## Building and publishing buster image:

```
git checkout buster
docker build -t digabi/docker-test-image:buster .
docker login # If not logged in already. See KeePass for digabi Docker Hub credentials
docker push digabi/docker-test-image:buster
```
