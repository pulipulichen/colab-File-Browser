#!/bin/bash

new_version=$(date '+%Y%m%d.%H%M%S')
script_dir=$(dirname "$0")
yaml_file="../app-build/$script_dir/docker-compose-template.yml"

# ========

CONTAINER_NAME=$(awk -F= '/^ *- CONTAINER_NAME=/ {gsub(/ /,"",$2); print $2}' "$yaml_file")

echo "CONTAINER_NAME: $CONTAINER_NAME"

# ========

# Get the line starting with "image:"
image_line=$(awk '/^ *image:/ {print $0}' "$yaml_file")

# Extract the string before the last ":"
image_prefix=$(echo "$image_line" | rev | cut -d':' -f2- | rev)

# Replace the line with the new version
sed -i "s|^ *image:.*|${image_prefix}:${CONTAINER_NAME}-${new_version}|" "$yaml_file"

IMAGE_NAME=$(awk '/^ *image:/ {sub(/^ *image: */, ""); sub(/ *$/, ""); print $0}' "$yaml_file")

echo "IMAGE_NAME: $IMAGE_NAME"

return 0

# ========

docker tag ${CONTAINER_NAME} ${IMAGE_NAME}
docker push "${IMAGE_NAME}"

# =========

git add .
git commit -m "${new_version}"
git push --force-with-lease