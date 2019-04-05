import argparse
import json
import sys

def main(args:[str]) -> int:
	print('Hello, world! This is mangen, the json-to-manpage generator!')
	return 0

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))