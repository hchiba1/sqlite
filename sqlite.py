#!/usr/bin/env python3
import sys
import argparse
import subprocess

parser = argparse.ArgumentParser(description='SQLite client')
parser.add_argument('db', help='Database file')
parser.add_argument('-T', '--table', help='from table')
parser.add_argument('-L', '--limit', help='limit')
parser.add_argument('-C', '--count', action='store_true', help='count')
parser.add_argument('-k', '--key', help='where key=value')
parser.add_argument('-v', '--value', help='where key=value')
parser.add_argument('-s', '--schema', help='schema of table')
parser.add_argument('-H', '--no-header', action='store_true', help='omit header line')
parser.add_argument('-l', '--list', action='store_true', help='list mode')
parser.add_argument('-c', '--column', action='store_true', help='column mode')
parser.add_argument('--import', action='store_true', help='import')
parser.add_argument('-q', '--quit', action='store_true', help='show query and quit')
args = parser.parse_args()

query = "SELECT *"
if args.table:
    query += f'FROM {args.table}'
    if args.key and args.value:
        query += f' WHERE "{args.key}" = "{args.value}"'
else:
    query = "select name from sqlite_master where type='table'"

if args.limit:
    query += f' LIMIT {args.limit}'

mode = ""
if args.column:
    mode = '.mode column\n'
else:
    mode = '.mode tabs\n'

header = '.headers ON\n'
query = mode + header + query

if args.quit:
    print(query)
    sys.exit()
    
subprocess.run(['sqlite3', args.db], input=query, universal_newlines=True)
