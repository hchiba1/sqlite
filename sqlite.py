#!/usr/bin/env python3
import sys
import re
import argparse
import subprocess

parser = argparse.ArgumentParser(description='SQLite client')
parser.add_argument('db', help='Database file')
parser.add_argument('-F', '--table', help='from table')
parser.add_argument('-L', '--limit', help='limit')
parser.add_argument('-C', '--count', action='store_true', help='count')
parser.add_argument('-k', '--key', help='where key=value')
parser.add_argument('-v', '--value', help='where key=value')
parser.add_argument('-s', '--schema', help='schema of table')
parser.add_argument('-H', '--no_header', action='store_true', help='omit header line')
parser.add_argument('-l', '--list', action='store_true', help='list mode')
parser.add_argument('-c', '--column', action='store_true', help='column mode')
parser.add_argument('-i', '--import_file', help='import fom tsv file')
parser.add_argument('-j', '--import_table', help='import into table')
parser.add_argument('-q', '--quit', action='store_true', help='show query and quit')
args = parser.parse_args()

mode = ''
if args.column:
    mode = '.mode column\n'
elif args.list:
    mode = ''
else:
    mode = '.mode tabs\n'

header = '.headers ON\n'
if args.no_header:
    header = ''

query = "SELECT *"
if args.table:
    if args.count:
        header = ''
        query = "SELECT COUNT(*)"
    query += f' FROM {args.table}'
    if args.key and args.value:
        query += f' WHERE "{args.key}" = "{args.value}"'
else:
    header = ''
    query = "select name from sqlite_master where type='table'"

if args.limit:
    query += f' LIMIT {args.limit}'

query = mode + header + query

if args.import_file:
    table_name = re.sub('.tsv$', '', args.import_file)
    if args.import_table:
        table_name = args.import_table
    query = '.mode tab\n'
    query += f'.import {args.import_file} {table_name}'

if args.quit:
    print(query)
    sys.exit()
    
subprocess.run(['sqlite3', args.db], input=query, universal_newlines=True)
