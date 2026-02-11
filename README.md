# Medley - a compendium of small scripts / utilities

## About

This repository contains small helper scripts or utilities that don't seem to
merit their own repository, but probably deserve a better home than a
throwaway Gist.

# shandbox

A simple sandbox setup using `unshare` and `nsenter`, that will set up a
shared environment for running less-trusted applications (e.g. agents and
their output). See [the Muxup page on shandbox](https://muxup.com/shandbox)
for more details.

## suite-helper

A helper script for working with llvm-test-suite build configurations. Written
up in more detail at [the Muxup suite-helper
page](https://muxup.com/suite-helper).

## instruction_to_pcode

A simple wrapper around [pypcode](https://github.com/angr/pypcode) to dump the
P-code (Ghidra's intermediate language for instruction semantics) for an
instruction specified in hex. e.g.

```
$ ./instruction_to_pcode aarch64 b874c925
-- 0x0: ldr w5, [x9, w20, SXTW #0x0]
0) unique[0x5f80:8] = sext(w20)
1) unique[0x7200:8] = unique[0x5f80:8]
2) unique[0x7200:8] = unique[0x7200:8] << 0x0
3) unique[0x7580:8] = x9 + unique[0x7200:8]
4) unique[0x28b80:4] = *[ram]unique[0x7580:8]
5) x5 = zext(unique[0x28b80:4])
```

As different tools dump instruction encodings in little endian or big endian,
you may need to use `--[no-]reverse-input` to convert the input.

The intended use case is to save a trip to the ISA manual if you need to
confirm the precise semantics of a given encoded instruction.

This was written against pypcode 1.1.2 (as packaged for Arch at the time of
writing), though the API seems like it may have changed a bit in 2.0.

See the [accompanying blog
post](https://muxup.com/2024q1/clarifying-instruction-semantics-with-p-code)
for more information.

## rootless-debootstrap-wrapper

Uses `fakeroot` and user namespaces to provide rootless cross-architecture debootstrap.

A "hello world" usage example (assuming debootstrap, qemu-user-static, and
qemu-user-static-binfmt are already installed):

```sh
./rootless-debootstrap-wrapper \
  --arch=riscv64 \
  --suite=sid \
  --cache-dir="$HOME/debcache" \
  --target-dir=hello-sid-riscv64 \
  --include=build-essential
cat <<EOF > hello-sid-riscv64/hello.c
#include <stdio.h>
#include <sys/utsname.h>

int main() {
  struct utsname buffer;
  if (uname(&buffer) != 0) {
      perror("uname");
      return 1;
    }
  printf("Hello from %s\n", buffer.machine);
  return 0;
}
EOF
./hello-sid-riscv64/_enter sh -c "gcc hello.c && ./a.out"
```

See the [accompanying blog
post](https://muxup.com/2024q4/rootless-cross-architecture-debootstrap) for
more information.

## License

The [MIT-0 license](https://github.com/muxup/medley/blob/main/LICENSE).
