# Customized MQTT deviceShifu

## Modify

- To change customization, modify `customized_handlers.py`
- To add new customization functions, modify `customized_handlers.py` and add your function mapping to `mqtt-customized-deviceshifu-configmap.yaml`

## Build

Use the following command to build this version of customized MQTT deviceShifu

### To use locally

```bash
docker buildx build -f Dockerfile . -t edgenesis/lwm2m-demo-deviceshifu-http-mqtt-customized:nightly --load
```

### If you are using K3s, load with

```bash
docker save edgenesis/lwm2m-demo-deviceshifu-http-mqtt-customized:nightly | k3s ctr image import -
```

### To push to Docker Hub with multiple platform support

```bash
docker buildx build --platform=linux/amd64,linux/arm64 -f Dockerfile . -t edgenesis/lwm2m-demo-deviceshifu-http-mqtt-customized:nightly --push
```