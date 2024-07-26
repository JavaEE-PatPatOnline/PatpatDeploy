# Patpat Online Deployment

> Deployment environment for Patpat Online

---

## Prerequisites

You need to have the following installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [K3S](https://k3s.io/)
- [MySQL](https://www.mysql.com/)
- [RabbitMQ](https://www.rabbitmq.com/)
- [Nginx](https://www.nginx.com/)

## Docker

### Kubernetes Dependencies

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/rancher/mirrored-pause:3.6
docker tag registry.cn-hangzhou.aliyuncs.com/rancher/mirrored-pause:3.6 rancher/mirrored-pause:3.6
```
