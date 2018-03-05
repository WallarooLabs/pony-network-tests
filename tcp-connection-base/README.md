# tcp-connection-base

Simple tcp server using `TCPConnection` that reads bytes off the network as fast as possible while recording total time it has been running. Outputs bytes received per second when the connection is closed.

Starts up bound to all interfaces at port 7669.

## Build

```bash
ponyc
```

## Start

```bash
sudo cset proc -s user -e numactl -- -C 3,17 chrt -f 80 ./tcp-connection-base --ponythreads=1 --ponynoblock --ponypinasio
```
