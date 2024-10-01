# SEEFLEX ANALYSIS

The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

## Data Pipeline

This data pipeline enables the user to access the corpus files in different ways depending on their intended use. The README is structured around these uses.


### 0. Setting up the corpus mark-up

The SEEFLEX contains xml mark-up to modify the corpus texts for the researcher's needs. The motivation for this arose from certain parts of the learner texts having a significant influence on analyses in pilot studies. These included quoted content from source texts on e.g. lexical sophistication measures using NLP software like TAALES (Kyle, Crossley & Berger, 2018). The included mark-up elements and their descriptions can be found in **Pauls (2024)** and the [config](code/data pipeline/config.yml) as well as the [bundles](code/data pipeline/bundles.yml) file.


#### 0.1 Using Bundles:
1. Choose a bundle in the [bundles](code/data pipeline/bundles.yml) file
2. Type the name of the bundle (leftmost indentation of the tree) in line 42 `use_bundle` in the [config](code/data pipeline/config.yml) file. 
3. Set the path to the directory of the **!!!INSERT!!!** in the [config](code/data pipeline/config.yml) file.

#### 0.2 Using an individual set-up:
1. Set the path to the directory of the **!!!INSERT!!!** in the [config](code/data pipeline/config.yml) file.
2. Go through the mark-up elements below `text_cleaning` and choose `true` or `false` using the comments as guide (e.g. `remove_quotes: false` = quotes are not removed)
3. Save the [config](code/data pipeline/config.yml) file.



### 1. Using the corpus as individual text files

The corpus texts can be exported as individual text files to be used with NLP software (e.g. https://www.linguisticanalysistools.org/) or simply viewed manually by the user. This step takes into account the configuration above. No changes to the [config](code/data pipeline/config.yml) file will result in the default bundle being used. This includes text, i.e. the text as it was submitted by the student.

1. Change the paths in lines 161 and 162 of the [export file](code/data pipeline/export_files.R) file to the paths on your machine. If you downloaded the repository as a whole, the folders need not be changed (NB: The date of the output folder can be adjusted).
2. Run the entire **export_files.R** R script (default output format = .txt -> cf. l. 166).
3. The corpus files have been written to the specified `output_directory`.



### 2. Loading the corpus in CQP

For implementing the corpus in a local or web-based CQP environment (Evert & The CWB Development Team 2020) the corpus needs to be collapsed to one file containing all texts within a `<text>` element that contains the individial text ids. The [collapse file](code/data pipeline/collapse.R) will automatically add this element, concatenate all files and export them as one single txt file.

1. Check the `directory` and `output_file` path.
2. Run the entire [collapse file](code/data pipeline/collapse.R) script.

The next step will require a version of the CLAWS (Garside, 1987) installed on your machine.

3. Execute the command `run_claws 20240618_SEEFLEX.txt` (with the filename matching your output file)
4. Convert the corpus to a vertical format using the command `convert -v2ksupp -rare -nosos 20240709_SEEFLEX.txt.c7 20240709_SEEFLEX.vrt 20240709_SEEFLEX.txt.c7.supp` (with the filenames matching your files created by CLAWS)


#### 2.1 SEEFLEX on a CQPweb instance

The SEEFLEX can be used for research purposes using CQPweb at RWTH Aachen University. For access, please contact [Tobias Pauls](mailto:tobias.pauls@ifaar.rwth-aachen.de).


#### 2.2 SEEFLEX on a local CQP instance

See [The IMS Open Corpus Workbench (CWB) Corpus Encoding and Management Manual](https://cwb.sourceforge.io/files/CWB_Encoding_Tutorial.pdf) for detailed instructions on how to encode the corpus on your local CQP.

5. Execute the following commands
```
cwb-encode -d /path/to/directory -f corpus_filename.vrt -R reg/corpus_name -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity -S foreign:0+xml:lang -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph;

cwb-make -r reg CORPUS_NAME;

cqp -e -r reg

CORPUS_NAME; 

## my code
cwb-encode -d /home/tbecker/corpus -f 20240831_SEEFLEX.vrt -R reg/seeflex -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg:1+type -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan  -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity+unit -S foreign:0+xml_lang;

cwb-make -r reg SEEFLEX;

cqp -e -r reg

SEEFLEX; 
```


### 3. Extracting the features using the CQP Feature Extraction Script (Neumann & Evert 2021)

The corpus

```
cqp -r reg -c -D SEEFLEX -f get_features.cqp | perl featex.perl seeflex.tsv

```


### 4. Performing operations on the corpus files (advanced)

#### 4.1 Meta Data

The final meta data table can be found in the `data` folder. The various meta data contained in the corpus can be viewed with the [meta_data file](code/data pipeline/meta_data.R). The calculations for the various tests are performed here.


#### 4.2 XML Manipulation 

The [xml_manipulation file](code/data pipeline/xml_manipulation.R) provides functions to edit node elements. This includes renaming nodes or attributes, as well as replacing node content or attribute values.



### References

- Evert, S. & The CWB Development Team. (2020). The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5) [Computer software]. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Garside, R. (1987). The CLAWS Word-tagging System. In R. Garside, G. Leech, & G. Sampson (Eds.), The computational analysis of English: A corpus-based approach (pp. 30–41). Longman.
- Kyle, K., Crossley, S. A., & Berger, C. (2018). The tool for the analysis of lexical sophistication (TAALES): Version 2.0. Behavior Research Methods 50(3), pp. 1030-1046. https://doi.org/10.3758/s13428-017-0924-4
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu