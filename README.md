# sprest

Steampipe REST interface.

## Usage

With host shell's aws variables and debug logging:

```
docker run \
    --name sprest \
    -it \
    --rm \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_REGION="$AWS_REGION" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -p 8080:8080 \
        flaccid/sprest \
            /sprest -l debug
```

With bind mount volume to host's aws config:

```
docker run \
    --name sprest \
    -it \
    --rm \
    -v "$HOME/.aws:/home/steampipe/.aws" \
    -p 8080:8080 \
        flaccid/sprest \
            /sprest -l debug
```

AWS SSO env example:

```
docker run \
    --name sprest \
    -it \
    --rm \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION" \
    -e AWS_REGION="$AWS_REGION" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -e AWS_SESSION_EXPIRATION="$AWS_SESSION_TOKEN" \
    -e AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" \
    -e AWS_SSO_REGION="$AWS_SSO_REGION" \
    -p 8080:8080 \
        flaccid/sprest \
            /sprest -l debug
```
