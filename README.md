
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

El dataset seleccionado es parte de un proyecto de <a href="https://github.com/rdempsey/dataiku-posts/blob/master/building-data-pipeline-data-science-studio/" > Robert Dempsey </a> para el que crea un <i>fake dataset</i> para proceder a limpiarlo
El dataset contiene datos de personas, direcciones, teléfonos y <i>e-mails</i> particulares y de trabajo, así como una fecha de alta de la cuenta. Podría asimilarse a un registro cualquiera en muchas de las <i>web</i> a las que estamos acostumbrados a visitar. 
Para realizar la práctica solamente vamos a usar las columnas relativas a dirección teléfono e <i>e-mail</i> personales. 
Obviamos las correspondientes al trabajo (work,work.address,work.city,work.state,work.zipcode,work.phone,work.email) porque únicamente nos llevaría a repertir la misma acción en columnas distintas  y no aporta valor añadido a lo que se pretende mostrar aquí.
Las acciones que se van a realizar principalmente son:
<ul style="list-style-type:disc">
  <li>El desdoblamiento de la columna <code>name</code> en  <code>name</code> y  <code>surname</code>  </li>
  <li>El desdoblamiento de la columna <code>address</code> en <code>addres</code> (dirección) y <code>flat</code> (piso). Algunos de los registros, no todos, detallan también además de la dirección,  el piso en el que vive la persona registrada. Se denota con <b>apartamento</b> (<i>Apt.</i>) o <b>suite</b> (<i>Suite</i>). Para homogueneizar las direcciones y considerando que para un uso posterior del dataset limpio, el piso no se considera un detalle relevante se elimina. Para ello usamos el método <code>separate</code> y la <i>regex</i> siguiente <code>(?=((Apt\\.))|(Suite))</code> </li>
  <li>Procesado de la columna <code>created</code> : 
      <ol>
        <li> Algunos de los registros presentan la parte de horas, minutos y segundos. Se elimina esta parte en aquellos que los contienen y nos quedamos con la fecha.
             Además <i>a priori</i> viendo los datos no parece que la hora de creación de la cuenta que sea algo importante para conservar. Para ello usamos el método                   <code>separate</code>
        </li>
        <li></li>
      </ol>
  </li>
  
</ul>  


