# NCBI Orthologs RDF

## Original data

NCBI Gene

* Data provider
  * National Center for Biotechnology Information
* License
  * https://www.ncbi.nlm.nih.gov/home/about/policies/
* Download
  * ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_orthologs.gz

## Created RDF

```
$ ./bin/ncbi_orthologs_rdf.pl data/gene_orthologs > data/gene_orthologs.ttl
```

Creator
* Hirokazu Chiba

SPARQL
* [human_mouse_orthologs.rq](https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/sparql/human_mouse_orthologs.rq)

## Summary

For 19,584 human genes, orthologous genes were identified in other organisms

List of 578 organisms:
* https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/tsv/ncbi_orthologs_human.organism_list.tsv

Number of organisms that have orthologs for each of the 19,584 human genes
* https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/tsv/ncbi_orthologs_human.count_organisms.tsv

Binary profile for each human gene (19,584 rows x 578 columns)
* https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/tsv/ncbi_orthologs_human.binary_pattern

Orthologous genes for each human gene (19,584 rows x 578 columns)
* https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/tsv/ncbi_orthologs_human.gene_ids
