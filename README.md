# docker-test-image and jenkins-test

Docker images for CI unit tests et al

New images are hosted in AWS ECR.

Old images are hosted in https://hub.docker.com/r/digabi/docker-test-image/ 

- stretch version: digabi/docker-test-image:stretch is built from branch `stretch`
- buster version: digabi/docker-test-image:buster is built from branch `buster`
- bullseye version: 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:latest is built from branch `master`

## Building and publishing stretch image:

```
git checkout master
docker build -t digabi/docker-test-image:stretch .
docker login # If not logged in already. See KeePass for digabi Docker Hub credentials
docker push digabi/docker-test-image:stretch
```

## Building and publishing buster image:

```
git checkout buster
docker build -t digabi/docker-test-image:buster .
docker login # If not logged in already. See KeePass for digabi Docker Hub credentials
docker push digabi/docker-test-image:buster
```

## Building and publishing bullseye image:

We are moving to ECR instead of Docker Hub. Building and pushing to ECR, using Bullseye as the latest:

```
git checkout master
docker build -t 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:latest .
aws-vault exec ytl-utility -- aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 863419159770.dkr.ecr.eu-north-1.amazonaws.com
docker push 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:latest
```

Pushing to legacy DockerHub:

```
git checkout master
docker build -t digabi/docker-test-image:bullseye .
docker login # If not logged in already. See KeePass for digabi Docker Hub credentials
docker push digabi/docker-test-image:bullseye
```

