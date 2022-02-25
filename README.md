# sqlite

```
$ echo '.tables' | sqlite3 db/development.sqlite3
ar_internal_metadata  table21               table4              
attributes            table22               table40             
classifications       table23               table41             
distributions         table24               table42             
properties            table25               table43             
relations             table26               table44             
schema_migrations     table27               table45             
table1                table28               table46             
table10               table29               table47             
table11               table3                table48             
table12               table30               table49             
table13               table31               table5              
table14               table32               table50             
table15               table33               table51             
table16               table34               table52             
table17               table35               table53             
table18               table36               table6              
table19               table37               table7              
table2                table38               table8              
table20               table39               table9 
```

```
$ sqlite3.pl db/development.sqlite3
schema_migrations
ar_internal_metadata
attributes
sqlite_sequence
classifications
distributions
relations
properties
table1
table2
table3
...
```

```
$ sqlite3.pl -F attributes db/development.sqlite3
1       gene_chromosome_ensembl ensembl_gene    classification
2       gene_number_of_paralogs_homologene      ncbigene        classification
3       gene_evolutionary_conservation_homologene       ncbigene        classification
...
```

```
$ sqlite3.pl -F table1 -L10 db/development.sqlite3
1       root    root node               0               1       121284  25
2       ENSG00000001617 SEMA3F  03      1       3       3       4       0
3       03      chr3    root    0       1       2       6379    3188
4       ENSG00000005801 ZNF195  11      1       5       6381    6382    0
5       11      chr11   root    0       1       6380    13107   3363
6       ENSG00000006062 MAP3K14 17      1       7       13109   13110   0
7       17      chr17   root    0       1       13108   19223   3057
8       ENSG00000007168 PAFAH1B1        17      1       7       13111   13112   0
9       ENSG00000010319 SEMA3G  03      1       3       5       6       0
10      ENSG00000010379 SLC6A13 12      1       11      19225   19226   0
...
```

```
$ echo 'CREATE TABLE IF NOT EXISTS "table54" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "distribution" varchar NOT NULL, "distribution_label" varchar, "distribution_value" float NOT NULL, "bin_id" varchar, "bin_label" varchar);' | sqlite3 db/development.sqlite3
```

```
$ sql.load_json.pl -t table54 protein_helix_content_ratio.json | sqlite3 db/development.sqlite3
```
