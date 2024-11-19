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

Excerpt from the created RDF
```
$ head gene_orthologs.ttl
@prefix orth: <http://purl.org/net/orth#> .
@prefix taxid: <http://identifiers.org/taxonomy/> .
@prefix ncbigene: <http://identifiers.org/ncbigene/> .
@prefix : <https://dbcls.github.io/ncbigene-rdf/ontology.ttl#> .

ncbigene:30037 orth:hasOrtholog ncbigene:129711934 .
ncbigene:129711934 orth:hasOrtholog ncbigene:30037 .
ncbigene:30037 :taxid taxid:7955 .
ncbigene:129711934 :taxid taxid:7782 .

```

Creator
* Hirokazu Chiba

Schema
* https://raw.githubusercontent.com/dbcls/ncbi-orthologs-rdf/master/config/schema.svg

SPARQL
* [human_mouse_orthologs.rq](https://github.com/dbcls/ncbi-orthologs-rdf/blob/main/sparql/human_mouse_orthologs.rq)
