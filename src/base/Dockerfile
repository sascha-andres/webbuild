ENV NVM_DIR /root/.nvm

COPY scripts/build.sh /exec/build.sh
COPY scripts/build_build.sh /exec/build_build.sh
COPY scripts/build_install.sh /exec/build_install.sh
COPY scripts/build_install_node.sh /exec/build_install_node.sh
COPY scripts/composer /usr/local/bin/composer
COPY scripts/install.sh /exec/install.sh

RUN /bin/bash /exec/install.sh

ENTRYPOINT [ "/exec/build.sh" ]
CMD []