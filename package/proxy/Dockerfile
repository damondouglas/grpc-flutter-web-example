FROM envoyproxy/envoy:v1.13.0
COPY ./certs/cert.crt /etc/cert.crt
COPY ./certs/cert.key /etc/cert.key
COPY ./proxy/envoy.yaml /etc/envoy/envoy.yaml
CMD /usr/local/bin/envoy -c /etc/envoy/envoy.yaml
