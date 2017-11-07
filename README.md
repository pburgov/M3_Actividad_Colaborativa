
---
title: "LimpiezaDeDataset.Rmd"
author: "Pedro Burgo Vazquez"
date: "06/11/2017"
output: html_document
---
SCRIPT: LimpiezaDeDataset.Rmd

AUTHOR: Pedro Burgo Vázquez

DATE: 06/11/2017

OUTPUT: cleanData_yyyy-mm-dd_hh-mm.ss.csv

PURPOSE: Limpieza de un dataset para poder usarlo con posteriodad

DATA SOURCE: https://raw.githubusercontent.com/rdempsey/dataiku-posts/master/building-data-pipeline-data-science-studio/dss_dirty_data_example.csv

INPUT DATA: dss_dirty_data_example.csv

### Descripción Breve

El dataset seleccionado es parte de un proyecto de <a href=" https://github.com/rdempsey/dataiku-posts/blob/master/building-data-pipeline-data-science-studio/Create%20a%20Fake%20Dataset.ipynb">Robert Dempsey</a> para el que crea un <i> fake dataset</i> para proceder a limpiarlo
El dataset contiene datos de personas, direcciones, teléfonos y <i>e-mails</i> particulares y de trabajo, así como una fecha de alta de la cuenta. Podría asimilarse a un registro cualquiera en muchas de las <i>web</i> a las que estamos acostumbrados a visitar. 
