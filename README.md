# docker-test-image and jenkins-test

Docker images for CI unit tests et al

New images are hosted in AWS ECR.

Old images are hosted in https://hub.docker.com/r/digabi/docker-test-image/

- stretch version: digabi/docker-test-image:stretch is built from branch `stretch`
- buster version: digabi/docker-test-image:buster is built from branch `buster`
- bullseye version: 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:bullseye
- bullseye version: 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:bookworm is built from branch `master`

## Building and publishing an image:

```
git checkout master
docker build -t 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:<debian code name> .
aws-vault exec digabi -- aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 863419159770.dkr.ecr.eu-north-1.amazonaws.com
docker push 863419159770.dkr.ecr.eu-north-1.amazonaws.com/jenkins-test:<debian code name>
```
