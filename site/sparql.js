async function fetchDatabySPARQL(taxname1, taxname2, input) {
  const endpointUrl = 'https://spang.dbcls.jp/sparql';
  const sparqlQuery = `
PREFIX orth: <http://purl.org/net/orth#>
PREFIX taxid: <http://identifiers.org/taxonomy/>
PREFIX ncbigene: <http://identifiers.org/ncbigene/>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX : <https://dbcls.github.io/ncbigene-rdf/ontology.ttl#>

SELECT DISTINCT ?gene1 ?label1 ?description1 ?gene2 ?label2 ?description2
WHERE {
  VALUES (?gene1) { ${input} }
  ?gene1 orth:hasOrtholog+ ?gene2 .
  ?gene1 :taxid ?taxid1 .
  ?gene1 rdfs:label ?label1 .
  ?gene1 dct:description ?description1 .
  ?taxid1 rdfs:label "${taxname1}" .
  ?gene2 :taxid ?taxid2 .
  ?gene2 rdfs:label ?label2 .
  ?gene2 dct:description ?description2 .
  ?taxid2 rdfs:label "${taxname2}" .
}
ORDER BY ?gene1 ?gene2
`;

  try {
    const response = await fetch(endpointUrl, {
      method: 'POST',
      headers: {
        'Accept': 'application/sparql-results+json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: `query=${encodeURIComponent(sparqlQuery)}`
    });
    if (!response.ok) {
      // response.ok === true if the status code is 2xx
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error(`Could not fetch data: ${error}`);
  }
}

