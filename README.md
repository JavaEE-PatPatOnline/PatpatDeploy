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

---

## CI/CD

### GitHub Actions

You need to have the following secrets set in your GitHub repository:

- `HOST`: The host of the server.
- `USERNAME`: The username of the server.
- `SSH_PRIVATE_KEY`: The private key of the server.
- `DEPLOY_PATH`: The path to deploy the project on the server.
