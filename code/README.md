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
| subset_corpus.R | This script can be used to subset the corpus corpus files according to metadata variables |
| tasks.R | This script can be used to make alterations to the ```xml``` files regarding the tasks and genres using the Excel files in the [data folder](../data/) |
| xml_manipulation.R | This script can be used to rename, replace, count ```xml``` tags. |
| xml_utils.R | Utilities file for the scripts working with the ```xml``` files. |



## Shiny Apps

Within the [app.R](shiny_app/app.R) file, the application can be launched. In the top pane, users can switch between the *scatterplot viewer* and the *feature weights* viewer (based on Neumann and Evert, 2021), as well as the additional SEEFLEX *feature value* and *student text* viewer. Alternatively, the applications can be viewed [here](https://seeflex.otc.coscine.dev).

<a href="https://seeflex.otc.coscine.dev" target="_blank" style="display: inline-block; padding: 10px 20px; font-size: 16px; color: white; background-color: #00559F; text-align: center; text-decoration: none; border-radius: 5px;">Shiny Apps</a>



## GMA Analysis

The SEEFLEX was compiled to investigate register variation in EFL exams in German upper secondary schools. The study adopted the Geometric Multivariate Analysis developed by Diwersy et al. (2014) and further developed by Stella Neumann and Stephanie Evert (Evert & Neumann, 2017; Neumann & Evert, 2021). The following table explains some of the files necessary to prepare and perform the analysis. 

| Filename | Function      |
|:--------| :-------------|
| create_macros.R | This script creates Corpus Query Preocessor (CQP) macros from .txt files. CQP does not allow multi-word sequences in word lists making this workaround necessary. The macros uses pipes ```|``` to separate individual multi-word queries. The script allows for options within the queries: The boolean operator ```?``` can be used after an entire word to give the option of including it (e.g. ```funnily enough?```). The boolean operator can also be used after a part of the word wrapped in parentheses to make part of an individual word optional (e.g. ```third(ly)?```). The script also allows the negation ```!``` before a word. In these cases, the script formats the CQP as negated word in a zero-width assertion query, meaning that the word must not be included, but no additional token is consumed if the word is not matched (Evert & The CWB Development Team, 2022). This is necessary in query parts that follow the created macros to avoid including any token that does not match the negated word. |
| gma_data.R | This script saves necessary data for the GMA analysis to an .rda file. The script needs to be run prior to [shiny_data](gma_analysis/shiny_data.R) |
| gma_seeflex.rmd | This R markdown file is based on the work by Stephanie Evert and Stella Neumann and their markdown file in the online supplement to Neumann and Evert (2021). The file has been adapted for use with the SEEFLEX (last accessed original file on March 24, 2025) |
| gma_utils.R | This is the original utilities file from Neumann and Evert (2021) that contains the necessary functions to perform the GMA (Geometric Multivariate Analysis) (last accessed on March 24, 2025) |
| seeflex_count_to_features.R | This adapted version was built upon the original script from Neumann and Evert (2021) which turns the counts created by the CQP feature extractions script into features for the [Shiny applications](https://seeflex.otc.coscine.dev) (last accessed on March 24, 2025). |
| seeflex_cross_validation.R | This file provides the code to perform leave-one-out cross validation (LOOCV) and grouped cross validation (GCV) using linear discriminant analysis (LDA), as well as support vector machines (SVM). |
| seeflex_gma_utils.R | This script is sourced by the [GMA markdown file](/gma_analysis/gma_seeflex.rmd) |
| shiny_data.R | NB: Script [gma_data](gma_analysis/gma_data.R) needs to be run prior to running this file. This script creates the data necessary to run the  |



## Plots

| Filename | Function      |
|:--------| :-------------|
| densities.R | This script creates density plot of selected linguistic features and operators. |
| feature_heatmap.R | This plot creates a heatmap of the linguistic features used in the Shiny applications. |
| feature_weights.R | This script creates boxplots of selected linguistic features and operators. |
| lextale_scores.R | This plot creates an overview of the students' LexTALE scores across grades. |
| operator_centroids.R | This file creates a scatterplot of the centroids (class means) of the different operators across the first and second component in the principal component analysis (PCA) or linear discriminant analysis (LDA). |
| pca_weights.R | This plot locates the PCA loadings (weights) of the linguistic features for the first and second principal component on a coordinate system. |
| reading_habits.R | This file creates a barplot showcasing the amount of time the students' reading habits across different media. |
| text_count_per_curriculum_task.R | This barplot shows the number of texts per operator with a color scheme for the different curricular tasks. |
| vlt_scores.R | This plots the students' Vocabulary Levels Test (VLT) scores across grades and VLT levels. |


## References

- Evert, S. & The CWB Development Team. (2022). *The IMS Open Corpus Workbench (CWB)—CQP Interface and Query Language Manual (CWB Version 3.5)*. https://cwb.sourceforge.io/files/CQP_Manual.pdf.
- Neumann, S. (2014). *Contrastive Register Variation: A Quantitative Approach to the Comparison of English and German*. Trends in Linguistics. Studies and Monographs: Vol. 251. Mouton de Gruyter.
- Neumann, S., & Evert, S. (2021). A register variation perspective on varieties of English. In E. Seoane & D. Biber (Eds.), *Corpus-based approaches to register variation* (pp. 143–178). Benjamins. https://doi.org/10.1075/scl.103.06neu