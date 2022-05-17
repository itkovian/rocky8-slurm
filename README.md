# docker-rocky8-slurm

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/neilmunday/docker-rocky8-slurm/Docker%20Image%20CI)](https://github.com/neilmunday/docker-rocky8-slurm/actions/workflows/docker-image.yml) [![GitHub issues](https://img.shields.io/github/issues/neilmunday/docker-rocky8-slurm)](https://github.com/neilmunday/docker-rocky8-slurm/issues) [![GitHub license](https://img.shields.io/github/license/neilmunday/docker-rocky8-slurm)](https://github.com/neilmunday/docker-rocky8-slurm/blob/main/LICENSE) ![Docker Pulls](https://img.shields.io/docker/pulls/neilmunday/rocky8-slurm)

Source repository: https://www.github.com/neilmunday/docker-rocky8-slurm

A Rocky 8 Docker image with a working Slurm installation. This image is intended to allow tests to be performed against a Slurm version.

At present there are no persistent volumes so each invocation of the image creates a clean set-up.

Note: this is a work in progress!

## Building

Use the `SLURM_VER` build argument to specify the Slurm version to build in the image.

The default value is currently 21.08.8-2.

**Note:** The first release of a Slurm version does not require `-1` in the `SLURM_VER` value.

## Running

Run the container in detached mode:

```
docker run -d --name slurm neilmunday/rocky8-slurm
```

Check that the container started ok:

```
docker logs slurm
```

Then you can run commands inside the container like so:

```
docker exec slurm sinfo
```

To submit a job:

```
docker exec -i slurm sbatch < myjob.sh
```
