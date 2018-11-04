FROM hypriot/rpi-alpine

RUN apk --no-cache add --update python3 py3-pip jq curl
RUN pip3 install speedtest-cli
ADD speedtest.sh /app/speedtest.sh
CMD ["sh", "/app/speedtest.sh"]
