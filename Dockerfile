FROM debian
ARG user=steampipe
COPY entry.sh /usr/local/bin/entry.sh
COPY bin/sprest /sprest
RUN apt-get update && \
    apt-get -y install \
        bash \
        curl \
        sudo && \
        useradd --system --create-home --shell /bin/bash "$user" && \
        echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user && \
    sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER $user
RUN steampipe plugin install aws
EXPOSE 9193
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["/sprest"]
