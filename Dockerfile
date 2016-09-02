FROM alpine:3.4
MAINTAINER Ewa Czechowska <ewa@ai-traders.com>

# * entrypoint requires sudo and shadow
# * git is needed to install ide image configs
# * openssh is needed by `git clone git@...`
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
 apk add --no-cache bash shadow sudo git openssh && \
 git clone --depth 1 -b 0.5.0 https://github.com/ai-traders/ide.git && \
 ide/ide_image_scripts/src/install.sh && \
 echo 'ide ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY etc_ide.d/scripts/* /etc/ide.d/scripts/
COPY etc_ide.d/variables/* /etc/ide.d/variables/

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]
