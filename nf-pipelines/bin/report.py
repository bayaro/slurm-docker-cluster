#!/usr/bin/env python

import argparse
import sys
import os
import csv

def ARGS(args = None):
    global ARGS
    ARGS = args
    return ARGS

def parse_args():
    global ARGS
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        usage='%(prog)s [options]',
        allow_abbrev=True#,
        # exit_on_error=False  # python 3.10 ?
    )
    parser.add_argument('-i', '--input', nargs="?", required=True, help='input path')
    parser.add_argument('-o', '--output', nargs="?", required=True, help='output path')
    parser.add_argument('-c', '--csv', nargs="?", required=True, help='report file')
    try:
        ARGS(parser.parse_args())
    except:
        parser.print_help()
        sys.exit(1)

    ARGS.input = ARGS.input.rstrip("/") + "/fastq"
    ARGS.output = ARGS.output.rstrip("/") + "/"

def scan_input():
    all_samples = set()
    for root, _, files in os.walk(ARGS.input):
        for file in files:
            all_samples.add(file.split("_")[0])
    print("%d samples found" % (len(all_samples)))
    return all_samples

def scan_output(samples):
    states = []
    for sample in samples:
        one = [ARGS.input + "/" + sample]
        out_path = ARGS.output + sample
        one.append(out_path if os.path.exists(out_path) else "ABSENT")
        one.append("OK" if os.path.exists(out_path + "/bai") else "ERR")
        states.append(one)
    return states

def save_csv(report):
    path = ARGS.csv
    with open(path, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(report)
    print("Report saved to %s" % (path))

def main():
    parse_args()
    all_samples = scan_input()
    samples_state = scan_output(all_samples)
    save_csv(samples_state)

if __name__ == "__main__":
    main()
