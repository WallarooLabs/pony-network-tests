# framed-by-hand-in-received

Like `framed-using-expect` except instead of using expect to control the size of the buffer passed to the `read` syscall, it reads as much data as it can from the socket and chunks according to expect to pass along to `received` method on the supplied connection notify.

Outputs bytes received per second when the connection is closed.

Starts up bound to all interfaces at port 7669.

## Build

```bash
ponyc
```

## Start

```bash
sudo cset proc -s user -e numactl -- -C 3,17 chrt -f 80 ./framed-by-hand --ponythreads=1 --ponynoblock --ponypinasio
```
