FROM rockylinux:9

LABEL org.opencontainers.image.source="https://github.com/neilmunday/rocky8-slurm" \
      org.opencontainers.image.description="A Rocky 9 Slurm container intended for testing Slurm" \
      org.opencontainers.image.title="rocky9-slurm" \
      maintainer="Neil Munday"

ARG SLURM_VER=23.02.2

# download, build, install and clean-up
RUN dnf install -y dnf-plugins-core && \
    dnf update -y && \
    dnf install -y epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y \
    python3-Cython \
    gcc \
    mailx \
    mariadb-devel \
    mariadb-server \
    munge-devel \
    pam-devel \
    perl \
    python3 \
    readline-devel \
    rpm-build \
    supervisor \
    tini \
    wget && \
    wget https://download.schedmd.com/slurm/slurm-${SLURM_VER}.tar.bz2 -O /root/slurm-${SLURM_VER}.tar.bz2 && \
    rpmbuild -tb /root/slurm-${SLURM_VER}.tar.bz2 && \
    dnf localinstall -y /root/rpmbuild/RPMS/x86_64/slurm-${SLURM_VER}*.el8.x86_64.rpm \
    /root/rpmbuild/RPMS/x86_64/slurm-slurmctld-${SLURM_VER}*.el8.x86_64.rpm \
    /root/rpmbuild/RPMS/x86_64/slurm-slurmd-${SLURM_VER}*.el8.x86_64.rpm \
    /root/rpmbuild/RPMS/x86_64/slurm-slurmdbd-${SLURM_VER}*.el8.x86_64.rpm \
    /root/rpmbuild/RPMS/x86_64/slurm-devel-${SLURM_VER}*.el8.x86_64.rpm && \
    dnf -y erase gcc mariab-devel make munge-devel pam-devel readline-devel rpm-build wget && \
    dnf clean all && \
    rm -rf /root/rpmbuild /root/slurm*.tar.bz2 && \
    groupadd -r slurm && \
    useradd -r -g slurm -d /var/empty/slurm -m -s /bin/bash slurm && \
    groupadd test && \
    useradd -g test -d /home/test -m test && \
    install -d -o slurm -g slurm /etc/slurm /var/spool/slurm /var/log/slurm

COPY supervisord.conf /etc/
COPY --chown=slurm slurm.*.conf /etc/slurm/
COPY --chown=slurm slurmdbd.conf /etc/slurm/
COPY --chown=root entrypoint.sh /usr/local/sbin/

RUN MAJOR_VER=`echo ${SLURM_VER} | egrep -o "^[0-9]+"` && \
  mv /etc/slurm/slurm.${MAJOR_VER}.conf /etc/slurm/slurm.conf && \
  rm -f /etc/slurm/slurm.*.conf

RUN /usr/bin/mysql_install_db --user=mysql

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/sbin/entrypoint.sh"]
CMD ["tail -f /dev/null"]
