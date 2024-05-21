# Shifu LwM2M Demo

This project provides a comprehensive demonstration of the Shifu LwM2M framework, showcasing the deployment and management of lightweight machine-to-machine (LwM2M) devices within a Kubernetes environment using k3s. The demo includes setting up LeShan mock clients and servers, creating and joining a k3s cluster, installing Shifu, and deploying various types of devices (LwM2M, HTTP, and MQTT) to interact with the server. This guide will walk you through each step to successfully run the demo.

## Preparation

### Building LeShan Mock Client and Server

[LeShan](https://github.com/eclipse-leshan/leshan) is an open-source implementation of the OMA Lightweight M2M protocol (LwM2M). In this demo we need to modify the leshan-demo-client to make it show value in list command, we need to build the LeShan server and client Docker images. This can be done using the following commands:

```bash
docker build -t leshan-server -f leshan/dockerfiles/server.dockerfile leshan
docker build -t leshan-client -f leshan/dockerfiles/client.dockerfile leshan
```

These commands will create Docker images for the LeShan server and client based on the configurations specified in their respective Dockerfiles.

## Running LeShan Mock Server

Next, we need to run the LeShan mock server as Lwm2m Server in Cloud. The following command will start the server in a Docker container, exposing necessary ports for communication:

```bash
docker run --name leshan-server -d -p 5683:5683/udp -p 5684:5684/udp -p 8080:8080/tcp leshan-server
```

This command runs the LeShan server in detached mode, with ports 5683 and 5684 for CoAP and CoAPs communication and port 8080 for HTTP access.

## Creating a k3s Cluster

[k3s](https://k3s.io/) is a lightweight Kubernetes distribution ideal for edge computing and IoT environments. We can create a k3s cluster by running the following command:

```bash
curl -sfL https://get.k3s.io | sh -
```

This command downloads and installs k3s on your system.

## Installing Shifu

[Shifu](https://shifu.dev/) is a Kubernetes native, production-grade, protocol & vendor agnostic IoT gateway. To install Shifu, apply the installation manifest using kubectl:

```bash
kubectl apply -f shifu/pkg/k8s/crd/install/shifu_install.yml
```

This command deploys the necessary Custom Resource Definitions (CRDs) and controllers to manage IoT devices with Shifu.

### Joining a k3s Cluster (Optional)

If you have additional nodes to join your k3s cluster, you can do so by retrieving the token from the master node and running the following command on the worker nodes:

```bash
curl -sfL https://get.k3s.io | K3S_URL='https://<master-node-ip>:6443' K3S_TOKEN='<TOKEN>' K3S_NODE_NAME=shifu-worker sh -
```

Replace `<master-node-ip>` with the IP address of your master node and `<TOKEN>` with the token found at `/var/lib/rancher/k3s/server/token` on the master node.

## Deploying Devices

### LwM2M Device

#### Connecting LwM2M Device

To deploy and connect an LwM2M device, apply the configuration file using kubectl:

```bash
kubectl apply -f lwm2m
```

Then, run the LeShan client to connect to the server:

```bash
docker run --rm -it leshan-client bash

java -jar leshan-client-demo-2.0.0-SNAPSHOT-jar-with-dependencies.jar -u coaps://<ip>:30001 -n test -i hint -p ABC123 -c TLS_PSK_WITH_AES_128_CCM_8
```

Replace `<ip>` with the IP address of your server. This command starts the LeShan client, connecting to the server using CoAPs with specified credentials.

#### Disconnecting LwM2M Device

To disconnect the LwM2M device, delete deviceShifu LwM2M using kubectl:

```bash
kubectl delete -f lwm2m
```

### HTTP Device

#### Creating HTTP Mock Device

To deploy an [HTTP mock device](https://shifu.dev/docs/tutorials/demo-try#2-interact-with-the-thermometer), apply its configuration file using kubectl:

```bash
kubectl apply -f http/mockdevice.yaml
```

This command deploys the mock HTTP device, which simulates HTTP interactions within the k3s cluster.

#### Creating HTTP Device Shifu and Connecting to Server

Next, deploy the Shifu HTTP device and connect it to the server:

```bash
kubectl apply -f http/device.yaml
```

This command configures the HTTP device with Shifu, enabling it to communicate with the server and perform necessary operations.

#### Disconnecting HTTP Device

To disconnect the HTTP device from the server, delete the deployment using kubectl:

```bash
kubectl delete -f http/device.yaml
```

This command removes the HTTP device from the k3s cluster, stopping its interactions with the server.

### MQTT Device

#### Creating MQTT Mock Device

To deploy [Mosquitto](https://mosquitto.org/)(MQTT Broker), apply its configuration file using kubectl:

```bash
kubectl apply -f mqtt/mockdevice.yaml
```

#### Creating MQTT Device Shifu and Connecting to Server

Next, deploy the Shifu MQTT and connect it to the server:

```bash
kubectl apply -f mqtt/device.yaml
```

This command configures the Mosquitto with Shifu, enabling it to communicate with the server and perform necessary operations.

#### Publishing MQTT Message

Publish a message to the MQTT device using the following command:

```bash
kubectl exec -it <mosquitto-pod-name> -n devices mosquitto _oub -t "/topic/channel1" -m Hello, World
```

Replace `<mosquitto-pod-name>` with the name of the Mosquitto pod in the cluster. This command publishes a message to the specified topic on the MQTT device. and you can read the message in cloud by read the object

#### Disconnecting MQTT Device

To disconnect the MQTT device from the server, delete the deployment using kubectl:

```bash
kubectl delete -f mqtt/device.yaml
```

This command removes the MQTT device from the k3s cluster, stopping its interactions with the server.


### Deleting Worker Node (Optional)

If you need to remove a worker node from your k3s cluster, you can do so with the following command:

```bash
kubectl delete node shifu-worker
```

This command removes the specified worker node from the cluster.

## Conclusion

This README provides a detailed guide to setting up and running the Shifu LwM2M demo. By following the steps outlined above, you can build and deploy mock LwM2M, HTTP, and MQTT devices within a k3s cluster, demonstrating the capabilities of the Shifu platform in managing IoT devices. Whether you're setting up a single-node cluster or a multi-node environment, these instructions will help you get started with Shifu and LeShan, enabling efficient and scalable device management.