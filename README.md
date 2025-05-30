# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Version 1.0.0

**Author:** Tobias Pauls<br>
**Contact:** tobias.pauls@ifaar.rwth-aachen.de

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13906356.svg)](https://doi.org/10.5281/zenodo.13906356)

This repository contains the complete dataset, various scripts for data manipulation, as well as supplementary resources for the Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams (SEEFLEX).

Corpus citation:
Pauls, T. (2024). SEEFLEX - The Corpus of Secondary English as a Foreign Language (EFL) Exams (0.1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.13906356


## Decription

The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Over the decades, learner corpora have covered a variety of languages and proficiency levels. In English as a Foreign Language (EFL) classes in Germany, students in upper secondary school encounter recurring tasks in their exams anchored in curricular requirements regarding targeted text types and register knowledge. The *SEEFLEX* was developed as a pedagogical resource to understand how students complete these tasks linguistically and whether they meet these requirements. *SEEFLEX* contains data from 575 transcribed authentic curriculum-based examinations (n<sub>texts</sub> = 1979, words<sub>total</sub> = 625.000). The meta-data include standardized receptive vocabulary assessments, a cognition scale, the participants’ reading habits and their language experience and proficiency and social background. Extensive ```xml```mark-up was added to investigate e.g. influence of source material and language mistakes. This online supplement provides full-text access as well as ample additional resources.


## Data

The data folder contains the following files:
- The `xml`-files containing the individual student texts. The corpus files each contain a TEI Header and mark-up that was deleveloped using the P5 Guidelines of the Text Encoding Initiative (TEI) (TEI Consortium, 2021).
- The meta-data including all variables and test scores.
- The source texts used in the exams, as well as per task information on prompts, registers and genres.
- The output from the feature extraction described in Neumann and Evert (2021) using the features derived from register theory in Neumann (2014).
- The data needed to run the Shiny applications (see below)


## Resources

- (coming soon...) The SEEFLEX can be used for research purposes using CQPweb at RWTH Aachen University. For access, please contact [Tobias Pauls](mailto:tobias.pauls@ifaar.rwth-aachen.de).
- The SEEFLEX Shiny applications can be viewed [here](https://seeflex.otc.coscine.dev).


## Code

The code contained in this online supplement comes with four main features: 
- The data pipeline scripts.
- Scripts to generate sample plots of the data.
- The SEEFLEX version materials necessary to perform the GMA analysis (Neumann & Evert, 2021)
- The code to run the SEEFLEX Shiny applications (originally developed in Neumann & Evert, 2021) locally


## Output

- Different versions of the corpus data (e.g. in the corrected version vs. the original version)
- Output files (e.g. collapsed version of the corpus for CLAWS pos-tagging)
- Sample plots generated from the [plot scripts](code/plots/)

## References

- Evert, S. & The CWB Development Team. (2020). *The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5)*. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Neumann, S. (2014). *Contrastive Register Variation: A Quantitative Approach to the Comparison of English and German*. Trends in Linguistics. Studies and Monographs: Vol. 251. Mouton de Gruyter.
- Neumann, S., & Evert, S. (2021). *A register variation perspective on varieties of English*. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu
- The TEI Consortium. (2021). *TEI P5: Guidelines for Electronic Text Encoding and Interchange (Version 4.3.0.)*. https://tei-c.org/Vault/P5/4.3.0/doc/tei-p5-doc/en/Guidelines.pdf


## License

This work is licensed under a  
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)  

![License](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)

This work is licensed under a
[Creative Commons Attribution-NonCommercial-NoDerivs 4.0 International License][cc-by-nc-nd].

[![CC BY-NC-ND 4.0][cc-by-nc-nd-image]][cc-by-nc-nd]

[cc-by-nc-nd]: http://creativecommons.org/licenses/by-nc-nd/4.0/
[cc-by-nc-nd-image]: https://licensebuttons.net/l/by-nc-nd/4.0/88x31.png
[cc-by-nc-nd-shield]: https://img.shields.io/badge/License-CC%20BY--NC--ND%204.0-lightgrey.svg