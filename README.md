# SEEFLEX ANALYSIS

## DESCRIPTION

The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

The SEEFLEX corpus was developed as part of a dissertation project. Pilot studies offered initial insights into secondary school writing in EFL classes in Germany. In their exams, students in the final three grades of secondary school encounter unique yet recurring tasks anchored in curricular requirements regarding targeted text types and register knowledge. Research is needed on a larger scale to understand how students complete these tasks linguistically and whether they meet these requirements. 

This corpus includes data from 45 classes across those three grade levels at three schools in North Rhine-Westphalia. Authentic curriculum-based hand-written examinations were scanned, fully transcribed, and POS-tagged. Extended xml-markup was added to account for inter alia language mistakes, quotes, references, and text structure. Students also participat-ed in a 90-minute contact session. The collected data include standardized receptive vocabu-lary assessments, students’ reading habits, a cognition scale, and the participants’ language experience and proficiency and social background.
SEEFLEX features more than 620.000 tokens across 1967 writing samples (mean wordcount = 317.83; median = 267; SD = 165.67; range = 17-1552; 3-4 texts per participant from 5 possible curriculum-based tasks) by 572 different students. The corpus will function as a pedagogical resource to analyse the linguistic differences between the curricular tasks as well as the offi-cial requirement that these tasks be distinctive from one another. Access to the corpus will be available via CQPweb. An online supplement will provide additional resources.

## Data

The corpus data in its raw format consists of 1967 .xml-files containing the individual student texts. The corpus files each contain a TEI Header  and mark-up that was deleveloped using the P5 Guidelines of the Text Encoding Initiative (TEI) (TEI Consortium 2021). The data is stored in separate folders for each class at one of the three schools. The folders are named "SCHOOL-NAME_GRADE_COURSE-ID_TEACHER-ID" and the files are named "STUDENT-ID.TASK-NUMBER.xml"

## Code

This online supplement comes with three main features, a data pipeline and two Shiny Apps to analyze the data resulting from the pipeline output.

### Data Pipeline

> code/data pipeline/README.md

The data pipeline provides various options to (pre-)process the data for different analyses. The files are:

- collapse.R (Collapsing all corpus xml-files into one plain text file with individual text IDs)
- config.yml (**Configuration of corpus files for individual text output**)
- config_manager.R (Configuration manager storing code on mark-up manipulation)
- export_for_nlp_tools.R (Exporting corpus as separate txt-files for further usage using the configuration of **config.yml**)
- xml_utils.R (Utilities file)


### Shiny App (Scatterplot)

The Scatterplot App offers the viewer scatter plots based on the Geometric Multivariate Analysis (Neumann and Evert 2021) and **!!!INSERT!!!**

### Shiny App (Feature Weights)

The Feature Weights App offers the viewer plots based on the feature weights and distributions of the Geometric Multivariate Analysis (Neumann and Evert 2021) and **!!!INSERT!!!**

### References

- Evert, S. & The CWB Development Team. (2020). The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5) [Computer software]. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu
- The TEI Consortium. (2021). TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.). https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf
