# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Use the toggle lists below to receive detailed instructions on the steps that need to be taken for each file. Contact [Tobias Pauls](mailto:tobias.pauls@ifaar.rwth-aachen.de) for additional information.

## Data Pipeline

### Adapting and exporting the corpus

In order to create a different version of the corpus files, the following steps have to be followed:

1. The settings for the markup have to be specified using the [bundles.yml](bundles.yml) and [config.yml](config.yml) files. The pre-defined bundles provide corpus settings for specific purposes, e.g. testing the lexical sophistication of the student language. For this bundle, all content derived from the source texts (quotes `<quote>` and references `<ref>`) are deleted. Further bundles include the original student spelling of the words and the corrected version of the corpus. Further bundles may be added into the file. NB: The layout of the bundles should be followed rigorously to ensure faultless processing. The configuration file allows individial adaptions. These settings are called with the bundle `default` (see below).

<details>
  <summary>Using bundles with bundles.yml</summary>

a) Choose a bundle described in the [bundles.yml](bundles.yml) file <br>
b) Type the name of this bundle (leftmost indentation of the tree) in line 37 `use_bundle` in the [config.yml](config.yml) file. <br>
c) If the bundle is not `default`, it will overwrite the [config.yml](config.yml) settings. <br>
d) Save the files!

</details>

<details>
  <summary>Using an individual setting in config.yml</summary>
  
a) Go through the mark-up elements below `text_cleaning` and choose `true` or `false` using the comments as guide (e.g. `remove_quotes: false` = quotes are not removed) <br>
b) Type `default` in line 37 for `use_bundle` in the [config.yml](config.yml) file. <br>
c) Save the files!

</details>

2. The corpus texts can then be exported as individual text files to be used with NLP software (e.g. https://www.linguisticanalysistools.org/) or simply be viewed manually by the user. This step takes into account the configuration above. No changes to the [config](code/data pipeline/config.yml) file will result in the default bundle being used. This includes the entire text as it was submitted by the student.

<details>
  <summary>Exporting the files using export_files.R</summary>
  
a) Set working directory to the SEEFLEX root folder <br>
b) Give your corpus version a name in line 167 <br>
c) Run the entire [export_files](export_files.R) script (default output format = .txt -> cf. l. 158).
d) The corpus files were written to the output directory.

</details>


### Encoding the corpus in CQP locally

1. For implementing the corpus in a local or web-based CQP environment (Evert & The CWB Development Team 2020) the corpus needs to be collapsed to one file containing all texts within a `<text>` element that contains the individial text ids. The [collapse.R](collapse.R) file will automatically add this element, concatenate all files and export them as one single txt file.

<details>
  <summary>Collapsing the corpus with collapse.R</summary>
  
a) Give your corpus a name in line 138 <br>
b) Set the `directory` to the output directory defined in the step above <br>
c) Run the entire [collapse.R](collapse.R) script.

</details>

2. The next step will require a version of the CLAWS (Garside, 1987) installed on your machine. The corpus needs to be part-of-speech tagged in order to be encoded in CQP.

<details>
  <summary>Annotating the corpus with POS tags using CLAWS</summary>

a) Execute the command `run_claws 20240618_SEEFLEX.txt` (with the filename matching your output file created in the step above) <br>
b) Convert the corpus to a vertical format using the command `convert -v2ksupp -rare -nosos 20240709_SEEFLEX.txt.c7 20240709_SEEFLEX.vrt 20240709_SEEFLEX.txt.c7.supp` (with the filenames matching your files created by CLAWS)

See [The IMS Open Corpus Workbench (CWB) Corpus Encoding and Management Manual](https://cwb.sourceforge.io/files/CWB_Encoding_Tutorial.pdf) for detailed instructions on how to encode the corpus on your local CQP.

</details>

3. To encode the corpus in a local cqp instance, make sure you follow the steps to install the IMS Corpus Workbench on your machine, following the [IMS Open Corpus Workbench (CWB) Corpus Encoding and Management Manual](https://cwb.sourceforge.io/files/CWB_Encoding_Tutorial.pdf).

<details>
  <summary>Encoding a local instance of the corpus using CQP</summary>

a) Execute the following commands (with your adapted filenames and paths): <br>

```
cwb-encode -d /home/tbecker/corpus -f 20240831_SEEFLEX.vrt -R reg/seeflex -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg:1+type -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan  -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity+unit -S foreign:0+xml_lang;## my code
cwb-encode -d /home/tbecker/seeflexorig -f 20250405_seeflex_orig.vrt -R reg/orig/seeflexorig -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg:1+type -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan  -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity+unit -S foreign:0+xml_lang;

cwb-make -r reg SEEFLEXORIG;

cqp -e -r reg

SEEFLEXORIG;
```

</details>

4. To extract the linguistic features (Neumann, 2014; revised in the creating of the SEEFLEX), the SEEFLEX feature extraction CQP script needs to be run in the local CQP instance. The script is based on the original script published in Neumann and Evert (2021).


<details>
  <summary>Extracting the linguistic features using the CQP feature extraction script</summary>

a) To run the cqp get_features.cqp script, exit cqp by typing `exit` in the console and run the following line: <br>

```
cqp -c -r reg/orig -D SEEFLEXORIG -f get_features_seeflex.cqp | perl featex.perl 20250407_SEEFLEX.tsv 
```

</details>



## References

- Evert, S. & The CWB Development Team. (2020). The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5) [Computer software]. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Garside, R. (1987). The CLAWS Word-tagging System. In R. Garside, G. Leech, & G. Sampson (Eds.), The computational analysis of English: A corpus-based approach (pp. 30–41). Longman.
- Neumann, S. (2014). *Contrastive Register Variation: A Quantitative Approach to the Comparison of English and German*. Trends in Linguistics. Studies and Monographs: Vol. 251. Mouton de Gruyter.
- Neumann, S., & Evert, S. (2021). *A register variation perspective on varieties of English*. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu