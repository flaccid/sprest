# sprest
Steampipe REST interface

## Usage

With host shell's aws variables and debug logging:

```
docker run \
    -it \
    --rm \
    -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
    -e AWS_REGION="$AWS_REGION" \
    -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
    -p 8080:8080 \
        flaccid/sprest \
            /sprest -l debug
```
