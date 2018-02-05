ENV NVM_DIR /root/.nvm

RUN mkdir /exec

COPY scripts/* /exec/
COPY scripts/composer /usr/local/bin/composer
COPY scripts/install.sh /exec/install.sh

RUN /bin/bash /exec/install.sh

ENTRYPOINT [ "/exec/build.sh" ]
CMD []