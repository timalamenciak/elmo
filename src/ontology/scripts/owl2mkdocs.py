#!/usr/bin/env python3
"""
Script to create a Mkdocs compatible markdown file.
This is mainly used to make URIs that validate.
Syntax is python owl2mkdocs.py <ontology> 
"""

import sys
from rdflib import Graph, Namespace, URIRef
from rdflib.namespace import RDF
from jinja2 import Environment, FileSystemLoader

def main():
        
    #load the ontology file
    o_file = sys.argv[1]
    
    #Load in the graph
    g = Graph()
    g.parse(o_file)
    elmo = Namespace("https://w3id.org/elmo/elmo_")
    g.namespace_manager.bind('elmo', elmo)

    #Declare the URIs that we need to search for
    subclass = URIRef("http://www.w3.org/2000/01/rdf-schema#subClassOf")
    label = URIRef("http://www.w3.org/2000/01/rdf-schema#label")
    definition = URIRef("http://purl.obolibrary.org/obo/IAO_0000115")
    
    #Now we build the term tree
    terms = {}
    #Fetch all unique CURIEs
    subjects = g.subjects(object=URIRef("http://www.w3.org/2002/07/owl#Class"), predicate=URIRef("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"))

    for s in subjects:
        if s.startswith(elmo):
            curie = g.namespace_manager.curie(s)
            curie_safe = curie.replace(":", "_")
            t_label = f"{next(g.objects(subject=URIRef(s), predicate=label))}"
            parent = g.value(subject=URIRef(s), predicate=subclass)
            t_definition = g.value(subject=s, predicate=definition)
            terms[curie] = {}
            terms[curie]["uri"] = s
            terms[curie]["curie_safe"] = curie_safe
            terms[curie]["label"] = t_label
            terms[curie]["parent"] = parent
            terms[curie]["definition"] = t_definition
        
    # Set up the Jinja2 environment
    file_loader = FileSystemLoader('/work/elmo/src/ontology/scripts')
    env = Environment(loader=file_loader)

    # Load the template
    template = env.get_template('onto_jinja.html')

    # Render the template with the data
    output = template.render(terms=terms)

    #Write to a csv file
    output_file_path = f'/work/elmo/docs/elmo.html'
    with open(output_file_path, 'w', encoding='utf-8') as file:
        file.write(output)

    print(f"Output has been written to {output_file_path}")

if __name__ == "__main__":
    main()