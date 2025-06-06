# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

Use the toggle lists below to receive detailed instructions on the steps that need to be taken for each file. Contact [Tobias Pauls](mailto:tobias.pauls@ifaar.rwth-aachen.de) for additional information or assistance.

## Data Pipeline

### bundles.yml


<details>
  <summary>Using bundles with bundles.yml</summary>

1. Choose a bundle in the [bundles.yml](bundles.yml) file
2. Type the name of the bundle (leftmost indentation of the tree) in line 42 `use_bundle` in the [config.yml](config.yml) file. 
3. Set the path to the directory of the **!!!INSERT!!!** in the config.yml file.

</details>

### config.yml

<details>
  <summary>Using an individual setting in config.yml</summary>
  
1. Set the path to the directory of the **!!!INSERT!!!** in the [config.yml](config.yml) file.
2. Go through the mark-up elements below `text_cleaning` and choose `true` or `false` using the comments as guide (e.g. `remove_quotes: false` = quotes are not removed)
3. Save the config.yml file.

</details>

<details>
  <summary>Using an individual setting in config.yml</summary>
  
The corpus texts can be exported as individual text files to be used with NLP software (e.g. https://www.linguisticanalysistools.org/) or simply viewed manually by the user. This step takes into account the configuration above. No changes to the [config](code/data pipeline/config.yml) file will result in the default bundle being used. This includes the entire text as it was submitted by the student.

1. Change the paths in lines 161 and 162 of the export_files.R file to the paths on your machine. If you downloaded the repository as a whole, the folders need not be changed (NB: The date of the output folder can be adjusted).
2. Run the entire [export_files](export_files.R) script (default output format = .txt -> cf. l. 166).
3. The corpus files have been written to the specified `output_directory`.

</details>

### Encoding the corpus in CQP locally

<details>
  <summary>Encoding the corpus in a local CQP instance</summary>
  
For implementing the corpus in a local or web-based CQP environment (Evert & The CWB Development Team 2020) the corpus needs to be collapsed to one file containing all texts within a `<text>` element that contains the individial text ids. The [collapse.R](collapse.R) file will automatically add this element, concatenate all files and export them as one single txt file.

1. Check the `directory` and `output_file` path.
2. Run the entire [collapse.R](collapse.R) script.

The next step will require a version of the CLAWS (Garside, 1987) installed on your machine.

3. Execute the command `run_claws 20240618_SEEFLEX.txt` (with the filename matching your output file)
4. Convert the corpus to a vertical format using the command `convert -v2ksupp -rare -nosos 20240709_SEEFLEX.txt.c7 20240709_SEEFLEX.vrt 20240709_SEEFLEX.txt.c7.supp` (with the filenames matching your files created by CLAWS)

See [The IMS Open Corpus Workbench (CWB) Corpus Encoding and Management Manual](https://cwb.sourceforge.io/files/CWB_Encoding_Tutorial.pdf) for detailed instructions on how to encode the corpus on your local CQP.

5. Execute the following commands
```
cwb-encode -d /path/to/directory -f corpus_filename.vrt -R reg/corpus_name -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity -S foreign:0+xml:lang -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph;

## my code
cwb-encode -d /home/tbecker/corpus -f 20240831_SEEFLEX.vrt -R reg/seeflex -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg:1+type -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan  -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity+unit -S foreign:0+xml_lang;## my code
cwb-encode -d /home/tbecker/seeflexorig -f 20250405_seeflex_orig.vrt -R reg/orig/seeflexorig -P pos -P lemma -S text:0+id -S body -S head -S s -S qs -S p -S l -S lg:1+type -S u:0+who -S sp -S speaker -S address -S addrLine -S quote -S q -S choice -S orig -S reg -S abbr -S expan  -S surplus -S add -S date -S link -S email -S salute -S signed -S stage -S kinesic -S desc -S emph -S ref:0+target+type -S name:0+type -S gap:0+reason+quantity+unit -S foreign:0+xml_lang;

cwb-make -r reg CORPUS_NAME;

## my code
cwb-make -r reg SEEFLEXORIG;

cqp -e -r reg

CORPUS_NAME; 

## my code
SEEFLEX;

## to run the cqp get_features.cqp script, exit cqp and run the following line

cqp -c -r reg/orig -D SEEFLEXORIG -f get_features_seeflex.cqp | perl featex.perl 20250407_SEEFLEX.tsv 

```

</details>



## References

- Evert, S. & The CWB Development Team. (2020). The IMS Open Corpus Workbench (CWB) CQP Query Language Tutorial (CWB Version 3.5) [Computer software]. http://cwb.sourceforge.net/files/CQP_Tutorial/
- Garside, R. (1987). The CLAWS Word-tagging System. In R. Garside, G. Leech, & G. Sampson (Eds.), The computational analysis of English: A corpus-based approach (pp. 30–41). Longman.