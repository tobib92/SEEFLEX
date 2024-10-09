# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

More detailed information about any of sections can be found in the respective chapters of the [corpus report](link to report).

## Written data

The heart of the *SEEFLEX* are the ```xml```files containing the student writing. All writing samples in the corpus stem from curriculum-based examinations. Each file contains a TEI header (TEI Consortium, 2021) containing meta-data to place the file within the corpus:

```{xml}
<?xml version="1.0" encoding="UTF-8"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0" version="4.3.0">
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <title>t1</title>			# Task number
        <author>a11g10_t1</author>		# Student ID
        <name>summarize</name>			# Operator (command word)
      </titleStmt>
      <publicationStmt>
        <publisher>a</publisher>		# School
        <date>20211006</date>			# Date of exam
      </publicationStmt>
      <seriesStmt>
        <title>11</title>			# School year (grade level)
      </seriesStmt>
      <notesStmt>
        <note>time="120min"</note>		# Exam time (for all tasks)
        <note>#tasks="3"</note>			# Total number of tasks
      </notesStmt>
      <sourceStmt>
        <p>gk2</p>				# Course ID
      </sourceStmt>
    </fileDesc>
  </teiHeader>
  <text>
    <body>
    </body>
  </text>
</TEI>
```

The body of the text may be preceded by a header if the task warrants it. The `xml`structure in the *SEEFLEX* is needed for various scripts to work. If the desired output are plain text files, the [export_files.R](../code/data_pipeline/export_files.R) script will export the entire corpus to an output directory. Information on the settings for the `xml`mark-up can be found [here](../code/data_pipeline/README.md).


## Meta-data

The meta-data in the *SEEFLEX* contain the information gained from the contact session with the participants. They include background information, language assessment, and learning habits. student responses in the language and learning habit assessments are in their raw format. To use the data in R and calculate the, the [meta-data](meta_data_anon.csv) file can be loaded with the [meta-data](../code/data_pipeline/meta_data.R) script. The data can be exported from there.


## Shiny data

The [Shiny applications](../README.md#L23) refer to data contained in two .rda files. Both of them are required for the applications to be run locally. The [data](20240903_data.rda) file contains basic information on the corpus, the meta-data needed to filter the output, and the required labels etc. The [shiny_data](20240905_shiny_data.rda) file contains the calculations done with the methodology introduced in Neumann and Evert (2021). The necessary information can be found [here](https://www.stephanie-evert.de/PUB/NeumannEvert2021/).


## References

- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu
- The TEI Consortium. (2021). TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.). https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf
