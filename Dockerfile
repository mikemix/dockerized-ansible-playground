FROM debian:stretch

RUN apt-get update && apt-get install -y openssh-server python-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

