"""Search every layer and config blob of a `docker save` archive for markers.

Usage: docker save IMAGE | python3 scan_image.py MARKER...

Works with both the classic and the OCI layout that `docker save` writes,
because it simply opens every regular file in the archive and, if that file
is itself a (possibly compressed) tar, every file inside it.
"""

import io
import sys
import tarfile


def scan(name, data, markers, found):
    for m in markers:
        if m.encode() in data:
            found.append((m, name))


def main():
    markers = sys.argv[1:]
    outer = tarfile.open(fileobj=io.BytesIO(sys.stdin.buffer.read()))
    found = []
    for member in outer.getmembers():
        if not member.isfile():
            continue
        blob = outer.extractfile(member).read()
        scan(member.name, blob, markers, found)
        try:
            layer = tarfile.open(fileobj=io.BytesIO(blob), mode="r:*")
        except tarfile.TarError:
            continue
        for inner in layer.getmembers():
            if inner.isfile():
                data = layer.extractfile(inner).read()
                scan(f"{member.name}:{inner.name}", data, markers, found)
    for m in markers:
        where = [n for f, n in found if f == m]
        print(f"{m}: {'FOUND in ' + ', '.join(where) if where else 'not found'}")


if __name__ == "__main__":
    main()
