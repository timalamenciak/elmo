
# Adding components to an ODK repo

For details on what components are, please see component section of [repository file structure document](../odk-workflows/RepositoryFileStructure.md).

To add custom components to an ODK repo, please follow the following steps:

1) Locate your odk yaml file and open it with your favourite text editor (src/ontology/elmo-odk.yaml)
2) Search if there is already a component section to the yaml file, if not add it accordingly, adding the name of your component:

```
components:
  products:
    - filename: your-component-name.owl
```

3) Add the component to your catalog file (src/ontology/catalog-v001.xml)

```
  <uri name="https://w3id.org/elmo/elmo/components/your-component-name.owl" uri="components/your-component-name.owl"/>
```

4) Add the component to the edit file (src/ontology/elmo-edit.obo)
for .obo formats: 

```
import: https://w3id.org/elmo/elmo/components/your-component-name.owl
```

for .owl formats: 

```
Import(<https://w3id.org/elmo/elmo/components/your-component-name.owl>)
```

5) Refresh your repo by running `sh run.sh make update_repo` - this should create a new file in src/ontology/components.

6) Add your template .tsv in src/templates.

7) Make the file by running `sh run.sh make components/your-component-name.owl`

