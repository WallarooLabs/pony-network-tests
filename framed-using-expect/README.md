# framed-using-expect

Simple framed tcp server using `TCPConnection`. Reads bytes in a framed format off the network using `TCPConnection`'s `expect` call. This results in a high number of system calls if messages have a small size.

Outputs bytes received per second when the connection is closed.

## Build

```bash
ponyc
```

## Start

```bash
sudo cset proc -s user -e numactl -- -C 3,17 chrt -f 80 ./framed-using-expect --ponythreads=1 --ponynoblock --ponypinasio
```
