# Medley - a compendium of small scripts / utilities

## About

This repository contains small helper scripts or utilities that don't seem to
merit their own repository, but probably deserve a better home than a
throwaway Gist.

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

## License

The [MIT license](https://github.com/muxup/medley/blob/main/LICENSE).
