FROM debian
ARG user=steampipe
RUN apt-get update && \
    apt-get -y install \
        curl \
        sudo && \
        useradd --system --create-home --shell /bin/bash "$user" && \
        echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user && \
    sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER $user
ENTRYPOINT ["steampipe"]
