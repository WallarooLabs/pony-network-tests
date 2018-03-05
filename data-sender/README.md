# data-sender

Blasts out framed data!

## Build

```bash
ponyc
```

## Start

```bash
sudo cset proc -s user -e numactl -- -C 2,17 chrt -f 80 ./data-sender wallaroo-leader-1 7669 1000 --ponythreads=1 --ponynoblock --ponypinasio
```
