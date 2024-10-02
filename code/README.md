# SEEFLEX
The Corpus of **Se**condary School **E**nglish As A **F**oreign **L**anguage (EFL) **Ex**ams

## Data Pipeline

The data pipeline provides various options to (pre-)process the data for different analyses. Some of the output may already provide the corpus in the correct format. The table below gives a brief description of the files' purpose in *SEEFLEX*:

| Filename | Function      |
|:--------| :-------------|
| bundles.yml | (See also: config.yml, export_files.R) The bundles file gives the option to set options for the ```xml``` manipulation and save them in presets. The presents can then be selected in the config.yml file |
| collapse.R | Collapses all corpus xml-files into one plain text file with individual text IDs as attributes inside a ```<text>``` tag. This is needed for encoding the corpus inside a local CQP  environment (Evert and The CWB Development Team, 2020). |
| config.yml | (See also: bundles.yml, export_files.R) Individual settings for the ```xml``` markup in the corpus. Each structural or positional tag can be selected and deselected. The export function in export_files.R will consider the settings in the file |
| config_manager.R | Configuration manager storing code for mark-up manipulation |
| export_files.R | This script gives the option to export the entire corpus as separate ```xml```or .txt files for further usage. The configuration in config.yml is considered. |
| meta_data.R | This script reads the data on the participants from the ```xml```files and merges them with the raw meta data. Calculations are performed on the test results and selected variables are normalized.  |
| meta_utils.R | Utilities file for meta_data.R |
| xml_manipulation.R | This script can be used to rename, replace, count ```xml``` tags. |
| xml_utils.R | Utilities file for the scripts working with the ```xml``` files. |



## Shiny App

Within the [app.R](shiny_app/app.R) file, the application can be launched. In the top pane, users can switch between the scatterplot viewer and the feature weights viewer (based on Neumann and Evert, 2021). Alternatively, the applications can be viewed [here](https://seeflex.otc.coscine.dev).



## GMA Analysis

> to be added...

| Filename | Function      |
|:--------| :-------------|
| file | description |



## Plots

> to be added...

| Filename | Function      |
|:--------| :-------------|
| file | description |



## References

- Neumann, S. (2014). Contrastive Register Variation: A Quantitative Approach to the Comparison of English and German. Trends in Linguistics. Studies and Monographs: Vol. 251. Mouton de Gruyter.
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), Corpus-based approaches to register variation (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu