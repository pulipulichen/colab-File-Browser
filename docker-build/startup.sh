#!/bin/bash


# Get the directory path of the script
script_dir=$(dirname "$0")

# Change the current working directory to the script's location
cd "$script_dir"

# ----------------------------------------------------------------

waitForConntaction() {
  port="$1"
  sleep 3
  while true; do
    echo "http://127.0.0.1:$port"
    if curl -sSf "http://127.0.0.1:$port" >/dev/null 2>&1; then
      echo "Connection successful."
      break
    else
      #echo "Connection failed. Retrying in 5 seconds..."
      sleep 5
    fi
  done
}

# ----------------------------------------------------------------

./../app-build/app-1-start.sh &

#echo "BEFORE ================================================================="
waitForConntaction "${LOCAL_PORT}"
#echo "AFTER ================================================================="

sleep 10

DATA_PATH="${LOCAL_VOLUMN_PATH}data.csv"
DATA_TEMP_PATH="${LOCAL_VOLUMN_PATH}data-temp.csv"
rm -f "${DATA_TEMP_PATH}"

# ----------------------------------------------------------------

./../app-build/app-2-afterstart.sh &

# ----------------------------------------------------------------

if [ "$INITED" != "true" ]; then
  sleep 30
fi

# ----------------------------------------------------------------

setupCloudflare() {
  file="/tmp/cloudflared"
  if [ ! -f "$file" ]; then
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O "${file}"
    chmod a+x "${file}"
  fi
}

runCloudflare() {
  port="$1"
  file_path="$2"

  #echo "p ${port} ${file_path}"

  rm -rf "${file_path}"
  #nohup /tmp/.cloudflared --url "http://127.0.0.1:${port}" > "${file_path}" 2>&1 &
  /tmp/cloudflared --url "http://127.0.0.1:${port}" > "${file_path}" 2>&1 &
}

getCloudflarePublicURL() {
  setupCloudflare

  port="$1"

    # File path
  file_path="/tmp/cloudflared.out"

  runCloudflare "${port}" "${file_path}" &

  sleep 3

  # Extracting the URL using grep and awk
  url=$(grep -o 'https://[^ ]*\.trycloudflare\.com' "$file_path" | awk '/https:\/\/[^ ]*\.trycloudflare\.com/{print; exit}')

  echo "$url/solr/collection/browse"
}

getCloudflarePublicURL "${LOCAL_PORT}" > "${LOCAL_VOLUMN_PATH}/.cloudflare.url"

# ----------------------------------------------------------------


url=$URL_TO_TEST_READY

while true; do
    response=$(curl -s "$url")
    #echo "$response"
    if [[ $(echo "$response" | jq -e . 2>/dev/null) ]]; then
        echo "Received JSON, sleeping for 5 seconds..."
        sleep 5
    elif [[ $response == *"<html>"* ]]; then
        sleep 10
        echo "Received HTML, it's okay!"
        break
    else
        echo "Unexpected response. Exiting."
        #exit 1
        sleep 5
    fi
done

echo `date` > "${LOCAL_VOLUMN_PATH}/.docker-web.ready"

echo "================================================================"
echo "$APP_NAME is ready to serve."
echo "================================================================"

# ----------------------------------------------------------------

while true; do
  sleep 10
done