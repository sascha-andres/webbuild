COPY scripts/build.sh /exec/build.sh
COPY scripts/composer /usr/local/bin/composer
COPY scripts/install.sh /exec/install.sh

RUN chmod 700 /exec/install.sh
RUN /exec/install.sh

ENTRYPOINT [ "/exec/build.sh" ]
CMD []