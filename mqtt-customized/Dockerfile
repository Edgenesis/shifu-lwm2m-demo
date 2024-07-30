FROM edgenesis/lwm2m-demo-deviceshifu-http-mqtt:nightly AS shifubase

FROM gcr.io/distroless/python3-debian11

COPY --from=shifubase /deviceshifu deviceshifu

COPY customized_handlers.py pythoncustomizedhandlers/

USER 65532:65532
ENTRYPOINT ["/deviceshifu"]
