# SEEFLEX
Version 0.1.0

## Decription

The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Over the decades, learner corpora have covered a variety of languages and proficiency levels. In English as a Foreign Language (EFL) classes in Germany, students in upper secondary school encounter recurring tasks in their exams anchored in curricular requirements regarding targeted text types and register knowledge. The *SEEFLEX* was developed as a pedagogical resource to understand how students complete these tasks linguistically and whether they meet these requirements. *SEEFLEX* contains data from 575 transcribed authentic curriculum-based examinations (1979 texts, ~625.000 words). The meta-data include standardized receptive vocabulary assessments, a cognition scale, the participants’ reading habits and their language experience and proficiency and social background. Extensive ```xml```mark-up was added to investigate e.g. influence of source material and language mistakes. This online supplement provides full-text access as well as ample additional resources.

## Data

The corpus data in its raw format consists of 1979 ```xml```-files containing the individual student texts. The corpus files each contain a TEI Header and mark-up that was deleveloped using the P5 Guidelines of the Text Encoding Initiative (TEI) (TEI Consortium, 2021). Detailed information on the mark-up can be found in the data README file.

## Code

The code contained in this online supplement comes with three main features: 
1. A data pipeline for various analyses.
2. Material for a GMA analysis (Neumann and Evert, 2021)
3. A Shiny application containing both the scatterplot viewer and the feature weights viewer developed in Neumann & Evert (2021)

## Output

The output section contains exemplary figure output. Consecutive versions will include e.g. further analyses and output data.

### References

- Evert, S. & The CWB Development Team. (2020). The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5) [Computer software]. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu
- The TEI Consortium. (2021). TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.). https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf
