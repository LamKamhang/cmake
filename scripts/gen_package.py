#!/usr/bin/env python3

import os
import argparse
import json

OUTPUT_BASE=os.path.abspath(os.path.join(
    os.path.dirname(__file__), "../packages"))

class PackageGenerator(object):
    def __init__(self) -> None:
        pass

    def generate_header():
        pass

def generate_pkg_file(pkg_config):
    pass

def main():
    app = argparse.ArgumentParser()
    app.add_argument("package_json", type=str)
    args = app.parse_args()
    print(f"receive: {args.package_json}")
    # load `package_json` into json object.
    with open(args.package_json) as fin:
        print(f"load jsonfile: {args.package_json}")
        packages = json.load(fin)
        for pkg in packages:
            generate_pkg_file(pkg)
            print(f"current.package: {pkg}")
        #print(f"loaded_json: {packages}")
    pass

if __name__ == '__main__':
    main()
