# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Version 2.0.1

**Author:** Tobias Pauls<br>
**Contact:** tobias.pauls@ifaar.rwth-aachen.de

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13906355.svg)](https://doi.org/10.5281/zenodo.13906355)

This repository contains the complete dataset, various scripts for data manipulation, as well as supplementary resources for the Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams (SEEFLEX).

Corpus report citation:


Corpus citation:
Pauls, T. (2024). SEEFLEX - The Corpus of Secondary English as a Foreign Language (EFL) Exams (0.1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.13906355


## Decription

The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams (SEEFLEX)

This report presents the Corpus of Secondary School English as a Foreign Language (EFL) Exams (SEEFLEX). In Germany, upper secondary school EFL exams feature recurring tasks targeting diverse text types. The SEEFLEX was developed to investigate how students complete these tasks linguistically and whether they meet the curricular requirements. The corpus contains data from 575 transcribed authentic curriculum-based examinations (n<sub>texts</sub> = 1979, total = ~625.000 words). The metadata include standardized receptive vocabulary assessments, a cognition scale, the participants’ reading habits, social background, and their language experience and proficiency. Extensive `xml` mark-up was added to investigate the influence of inter alia source material, structural text features, and selected language mistakes. An online repository provides full-text access as well as ample additional resources, including an interactive Shiny application to investigate register variation in the corpus.


## Data

The data folder contains the following files:
- The `xml`-[files](data/anon/) containing the individual student texts. The corpus files each contain a TEI Header and mark-up that was deleveloped using the P5 Guidelines of the Text Encoding Initiative (TEI) (TEI Consortium, 2021).
- The [metadata file](data/meta_data_anon.csv) includes all variables and test scores.
- The [source texts](data/source_texts/) used in the exams, as well as [per task information](data/tasks_complete.csv) on prompts, registers and genres.
- The [output](data/gma/) from the feature extraction described in Neumann and Evert (2021) using the features derived from register theory in Neumann (2014).
- The [data](data/gma/shiny_data.rda) needed to run the Shiny applications (see below)


## Resources

- (coming soon...) The SEEFLEX can be used for research purposes using CQPweb at RWTH Aachen University. For access, please contact [Tobias Pauls](mailto:tobias.pauls@ifaar.rwth-aachen.de).
- The SEEFLEX Shiny applications can be viewed [here](https://seeflex.otc.coscine.dev). Further information on the Shiny applications can be found [here](code/shiny_app/README.md).


## Code

The code contained in this online supplement is divided into four main components. An overview of the different files can be found [here](code/). 
- The [data pipeline](code/data_pipeline/) scripts.
- Scripts to generate sample [plots](code/plots/) of the data.
- The SEEFLEX version of the [materials](code/gma_analysis/) necessary to perform the GMA analysis (Neumann & Evert, 2021)
- The [code](code/shiny_app/) to run the SEEFLEX Shiny applications (originally developed in Neumann & Evert, 2021) locally. The directory opens the combined Shiny app (hosted version). All individual apps can be run using the `app.R` files in the respective folders [here](code/).


## Output

- Different versions of the corpus data (e.g. in the corrected version vs. the original version)
- Output files (e.g. collapsed version of the corpus for CLAWS pos-tagging)
- Sample plots generated from the [plot scripts](code/plots/)

## References

- Evert, S. & The CWB Development Team. (2020). *The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5)*. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Neumann, S. (2014). *Contrastive Register Variation: A Quantitative Approach to the Comparison of English and German*. Trends in Linguistics. Studies and Monographs: Vol. 251. Mouton de Gruyter.
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), *Corpus-based approaches to register variation* (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu
- The TEI Consortium. (2021). *TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.)*. https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf


## License

This work is licensed under a  
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)