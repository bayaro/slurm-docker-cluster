# Slurm Docker Cluster for nextflow pipelines

**Slurm Docker Cluster** is a multi-container Slurm cluster designed for rapid
deployment using Docker Compose. This repository simplifies the process of
setting up a robust Slurm environment for development, testing, or lightweight
usage. In the scope of task this cluster is expanded by bwa, samtools on all nodes
and nexflow binaries on the slurmctl node.

## 🏁 Getting Started

To get up and running with Slurm in Docker, make sure you have the following tools installed:

- **[Docker](https://docs.docker.com/get-docker/)**
- **[Docker Compose](https://docs.docker.com/compose/install/)**

Clone the repository:

```bash
git clone https://github.com/bayaro/slurm-docker-cluster.git
cd slurm-docker-cluster
```

## 📦 Containers and Volumes

This setup consists of the following containers:

- **mysql**: Stores job and cluster data.
- **slurmdbd**: Manages the Slurm database.
- **slurmctld**: The Slurm controller responsible for job and resource management.
- **c1, c2**: Compute nodes (running `slurmd`).

### Persistent Volumes:

- `etc_munge`: Mounted to `/etc/munge`
- `etc_slurm`: Mounted to `/etc/slurm`
- `slurm_jobdir`: Mounted to `/data`
- `var_lib_mysql`: Mounted to `/var/lib/mysql`
- `var_log_slurm`: Mounted to `/var/log/slurm`

### Bind mount

- `./data`: Mounted to `/data`
- `.//nf-pipelines`: Mounted to `/pipelines`

## 🛠️  Building the Docker Image

The version of the Slurm project and the Docker build process can be simplified
by using a `.env` file, which will be automatically picked up by Docker Compose.

Update the `SLURM_TAG` and `IMAGE_TAG` found in the `.env` file and build
the image:

```bash
docker compose build
```

## 🚀 Starting the Cluster

Once the image is built, deploy the cluster with the default version of slurm
using Docker Compose:

```bash
docker compose up -d
```

This will start up all containers in detached mode. You can monitor their status using:

```bash
docker compose ps
```

For real-time cluster logs, use:

```bash
docker compose logs -f
```

## 🖥️  Accessing the Cluster

To interact with the Slurm controller, open a shell inside the `slurmctld` container:

```bash
docker exec -it slurmctld bash
```

## Triggering a nextflow pipeline

Copy the unarchived input folder with sample data to the data folder. Start the nextflow pipeline:
```bash
docker exec -it slurmctld /pipelines/do.nf
```

### Deleting the Cluster:

To completely remove the containers and associated volumes:

```bash
docker compose down -v
```

### Original README.md
- [README.md](README.cluster.md)
