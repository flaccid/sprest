FROM golang as builder
COPY . /go/src/github.com/flaccid/sprest
WORKDIR /go/src/github.com/flaccid/sprest
RUN go get ./... && \
    make build

FROM debian
ARG user=steampipe
COPY --from=builder /go/src/github.com/flaccid/sprest/bin/sprest /sprest
COPY entry.sh /usr/local/bin/entry.sh
RUN apt-get update && \
    apt-get -y install \
    awscli \
    bash \
    curl \
    iproute2 \
    less \
    procps \
    sudo && \
    useradd --system --create-home --shell /bin/bash "$user" && \
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user && \
    sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER $user
WORKDIR "/home/$user"
RUN steampipe plugin install aws
EXPOSE 9193
ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["/sprest"]
