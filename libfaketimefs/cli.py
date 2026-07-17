import argparse
import logging

from libfaketimefs import Faketime
from libfaketimefs.vendored.fusepy.fuse import FUSE


def main():
    parser = argparse.ArgumentParser(prog="libfaketimefs")
    parser.add_argument(
        "mountpoint",
        help="Mount point for the filesystem",
    )
    parser.add_argument(
        "--allow-other",
        action="store_true",
        help="Allow other users to access the filesystem",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Print debug information",
    )

    args = parser.parse_args()

    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)

    FUSE(
        Faketime(),
        args.mountpoint,
        allow_other=args.allow_other,
        foreground=True,
    )


if __name__ == "__main__":
    main()
