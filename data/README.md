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

The body of the text may be preceded by a header if the task warrants it. The `xml`structure in the *SEEFLEX* is needed for various scripts to work. If the desired output are plain text files, the [export_files](code/data_pipeline/export_files.R) script will export the entire to an output directory.

## Meta-data

The meta-data in the *SEEFLEX* contain the information gained from the contact session with the participants


## References

- The TEI Consortium. (2021). TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.). https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf
