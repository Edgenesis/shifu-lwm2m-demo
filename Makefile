build-docker-images:
	make -C shifu \
	buildx-build-image-deviceshifu-http-http \
	buildx-build-image-deviceshifu-http-lwm2m \
	buildx-build-image-deviceshifu-http-mqtt \
	buildx-build-image-gateway-lwm2m

save-docker-images:
	docker save edgehub/deviceshifu-http-http:nightly > images/edgehub-deviceshifu-http-http-nightly.tar
	docker save edgehub/deviceshifu-http-mqtt:nightly > images/edgehub-deviceshifu-http-mqtt-nightly.tar
	docker save edgehub/deviceshifu-http-lwm2m:nightly > images/edgehub-deviceshifu-http-lwm2m-nightly.tar
	docker save edgehub/gateway-lwm2m:nightly > images/edgehub-gateway-lwm2m-nightly.tar

kind-load-docker-images:
	kind load docker-image edgehub/deviceshifu-http-http:nightly
	kind load docker-image edgehub/deviceshifu-http-mqtt:nightly
	kind load docker-image edgehub/deviceshifu-http-lwm2m:nightly
	kind load docker-image edgehub/gateway-lwm2m:nightly

ctr-load-docker-images:
	sudo ctr images import images/edgehub-deviceshifu-http-http-nightly.tar
	sudo ctr images import images/edgehub-deviceshifu-http-mqtt-nightly.tar
	sudo ctr images import images/edgehub-deviceshifu-http-lwm2m-nightly.tar
	sudo ctr images import images/edgehub-gateway-lwm2m-nightly.tar
