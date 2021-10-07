# Make PDF package

This version of the package produces a PDF output from TEI files including Manuscripts 
encoded following the [Beta maṣāḥǝft Guidelines](https://betamasaheft.eu/Guidelines/) 
and inscriptions encoded following the [EpiDoc guidelines](https://epidoc.stoa.org/gl/latest/). While it is recommended that the input is uniform the package demonstrate both types of input usage together. Non relevant parts / steps can be omitted accordingly. 

ATTENTION!! RENDERING OF ATTRIBUTION OF SOURCES, which is available in the data IS currently INSUFFICIENT. This is not implemented in this demo application because it is easy enough to do for anyone. ***Please see the included files for appropriate attribution of the sources included in the output.***

The output produced follows most of the layout requirements of [Aethiopica](https://doaj.org/toc/2194-4024) and the Supplements to Aethiopica. Changing this settings is easy in the relevant `fo:` elements into the PDF.xql script.

This version produced for the [DTS Hackathon ](https://distributed-text-services.github.io/workshops/events/2021-hackathon/) demonstrates some basic functionalities using DTS APIs.

Some of the data listed in the catalogue of written artefacts is fetch from the Beta Masaheft DTS API declaratively. The Xquery switches from document to collection endpoint to find out if there is a IIIF manifest. If so it prints a footnote with the attribution from the Manifest and prints at the end of the booklet the first 5 images available.

Other APIs, like the Zotero API for the Beta Masaheft bibliography are used to populate information accordingly so that the result is a mash up of sources from diverse remote locations.

Inscriptions are preprocessed using the FO variant of the Example Stylesheets from the EpiDoc repository.

The example output is thus inconsistent as it is inconsistent the data used for the example. Use only manuscripts or only from one source and select one or the other way of disposing images to have a better starting point.

The results of calls to the Collection and Navigation Api are parsed as json as per the support offered in XQuery 3.1 for maps and arrays.

An additional use of the DTS API is demonstrated with regard to references contained in the text. 

A local list of abbreviations aligned to selected available source texts is added in the driver as a common "list of abbreviations". This maps the content of a `@cRef` to a specific identifier and a DTS endpoint, abbreviated using the `<prefixDef>` element. This allows to define the endpoints once and select the texts only one time, then go with the citations as text and rely on that mapping. Based on the rend attribute if a quote is required this is built into the output calling the document API. This guarantees that citations are consistent to their citation reference system and source.
Information about the source text is printed alongside relevant pointers in the "list of abbreviations". 

- The parts of the ouput can be customized in the settings.
- The layout can be customized in the PDF.xql
- The XML driver file defines where to look for what and organizes the content (source documents, images, etc.).
- Many further parameters can be set for the consistent rendering of inscriptions with the EpiDoc Stylesheets parameters.

The resulting XSL-FO can eventually be further fine tuned after beeing produced.

This can eventually be modified for other TEI based projects.

This is part of the efforts to support concrete flexible and multiple user needs 
for the project  Beta maṣāḥǝft: Manuscripts of Ethiopia and 
Eritrea (Schriftkultur des christlichen Äthiopiens und Eritreas: eine multimediale Forschungsumgebung)

This package will be updated to include a schema to check several of the rules of style but it does not yet do so.


## Setup
You need [OxygenXML Editor](http://www.oxygenxml.com/) to run this package. The package relies
on the XQuery enging and FOP processor delivered with Oxygen and is set up to do that.
If asked to allow modifications to Oxygen preferences, please, say yes.

Once you have downloaded, or forked and cloned this repository, open from `catalogue.xpr`. If you are working in a team, you can each have this locally and try out sharing settings.

This will open as a project in Oxygen and present you a Project view, by default on the left.

Your main file here is `driver.xml`. In here you write your article using TEI elements
or your book, and include manuscripts for your catalogue, 
and add or include all its parts.

    
### EpiDoc parameters
If runnign the epidocFO transformation scenario, you can benefit from all parameters supported by the EpiDoc example Stylesheet library, including its Zotero lookup functionality, setting the parameters accordingly. You may have to edit the `inscriptions2fo.xslt` or edit the transformation scenario to pass on the parameters. If you have inscriptions in EpiDoc included in your driver, before clicking the red play button, open the driver.xml and run the `epidocFO` transformation scenario which is preset for the project. This will create parts of the File Object using the EpiDoc stylesheets and store them in a directory which will then be used by the PDF.xql to include the information. This expects the Stylesheets to be stored alongside the makepdf package directory which should be the case if you use the default location for cloning Git repositories. otherways, please update paths in `inscriptions2fo.xslt`.

### Settings
You have two setting files. 
1. One is the Apache FOP configuration file. This is needed by the package, but you should not need to edit it unless you actually know that you need to
2. Your `settings.xml`file allows you to decide on some parts of the output. For example if it is going to be a book or an article, if to include indexes or not, where to put the bibliography, etc.

### Directories
There are then three directories, 
 - one for the manuscripts TEI files (`mss`), 
 - one for images (`images`), and 
 - one for other files (`other`), e.g. institutions if they are defined locally, or locally defined authority files.
 
Note that the img folder contains instead the image used in this documentation page, and is not used by the script.
Once you open the project, allow it to set up your software and make sure you can 
use xi:include in the preferences. This should be set by the project itself for you.
![img/XInclude.png](img/XInclude.png)

You will need to create a directory called fonts and store in it the fonts listed in `fopconfig.xml`. My [collection is linked in this presentation](https://docs.google.com/presentation/d/e/2PACX-1vSe763ALF1tB4B3Jwuf9YVwoN1aB67Cu6eZJJTGq7WU06ikWdQzRSTbm_ScZIwKcPrTEVGOCl2icHI-/pub?start=false&loop=false&delayms=3000&slide=id.gde2f7d93e5_0_0).

## Make the PDF
To make the PDF, with the project open, select driver.xml and click the small red play button at the top in your Oxygen editor. 

This is already setup to run the `PDF.xql` script, unless you have changed that to produce the EpiDoc parts, in which case, select the catalogue2PDF transformation scenario before clicking play.
PDF.xql will take into consideration your settings, as defined in `settings.xql`. Some more details about
this process and how you can adapt it follow. Anything can be adapted and is likely
to need adaptation to meet your encoding choices and desired output in the limits of
authorial decisions.
The produced PDF will open in your preferred system application for that.



## driver.xml
This package was designed for catalogues, although it can be 
used for other purposes as well, by simply not including the manuscripts.
This source file uses `<teiCorpus>` to group under 
one `<teiHeader>` the selection of manuscripts. You can 
thus add all the information regarding this group of manuscripts, 
regardless of your selection. You may store your manuscripts as a local 
copy in mss or point to another directory in the xi:nclude elements. 
Thus you can also include a local path 
to a GitHub repository, if you want to maintain a single flow for your data. Mixing is also fine, but tidiness always helps.
This is an example of including a file with a relative path to the provided manuscripts directory.
```xml
<xi:include 
        xmlns:xi="http://www.w3.org/2001/XInclude" 
        href="mss/simple.xml">
      <xi:fallback>
         <p>Psalter</p>
      </xi:fallback>
   </xi:include>
```
If you have on the desktop your a folder with cloned repositories from GitHub, switched at any branch,
you can point to that.

```xml
<xi:include 
        xmlns:xi="http://www.w3.org/2001/XInclude" 
        href="/path/to/my/github/manuscripts/repository/mss1.xml">
      <xi:fallback>
         <p>fallback name of the manuscript</p>
      </xi:fallback>
   </xi:include>
```

Having a fallback will help you in case you have many files and one cannot be found to find quickly which one is missing.

By default manuscripts are printed and ordered regardless of their position of inclusion in `driver.xml`, looking instead at their shelfmark.

Note that the print process supports lightly as well as more deeply encoded manuscripts. The example has three paragraphs of information as text, no further encoding.
The package was developed to support manuscripts deeply encoded as, e.g. those 
of the (Dayr as-Suryān Collection)[https://betamasaheft.eu/DSintro.html].

### General behaviours

The Package uses
- the [EthioStudies Library](https://www.zotero.org/groups/358366/ethiostudies/items) and the [HLZ CSL Style](https://betamasaheft.github.io/bibliography/) to print citations and bibliography
- the [DTS APIs listed in the DTS aggregator](https://dts-browser.herokuapp.com/) to resolve refs.

If these resources happen to be unavailable or you have 
no internet connection to let Oxygen access them, this will not work.
This also means that there is a certain amount of dependency on 
the Beta maṣāḥǝft research environment and Zotero API, all of which can be updated by changing the relevant parts, no setting facility has been provided for this.

Validation with a specific style schema is on the way and will be included in driver.xml, so that it does not affect the included TEI files and their schema association.

Indexes rely on the presence of encode `persName`, `placeName` and `term` elements. If these are not present, no index will be printed.
These will use only the latest available version in the research environment, not the eventually available newer version in one of your local branches for
[persons](https://github.com/BetaMasaheft/Persons) or [places](https://github.com/BetaMasaheft/Places) repositories.

#### TEI elements used in driver.xml

In driver.xml you can write any parts of your proposed contribution which are not 
encoded as manuscripts. Introduction, other chapters, appendixes, etc.

Links
```xml
<ref target="http://www.thelevantinefoundation.co.uk">the levantine</ref>
```                    
 ref with type figure, internal, manuscript, work with 
respectively the ids of a figure in a figure element, a chapter 
or any other node with a xml:id, a manuscript in BM a work in BM
 
bibliographical citations
 ```xml
 <bibl>
 <ptr target="bm:Meinardus1961Monks"/>
 <citedRange unit="page">117</citedRange>
 </bibl>
```

persons and places
```xml
<placeName ref="LOC6126WadinN"></placeName>

<persName ref="PRS7185Mosesof"></persName>
```
currently wikidata pointers and other external pointers are  not supported.

footnotes
```xml
<note>to make a footnote</note>
```

citations/quotes of sources
```xml
<ref cRef="Aesch" corresp="221" rend="cit">Aeschilus, Prometeus Bound, verse 221</ref>
```


For lists, quotes and tables, standard TEI can be used. These are formatted according to Aethiopica Supplements requirements (2018).

#### TEI elements used in Manuscripts (mss/)

Please see 
[‘Beta maṣāḥǝft Guidelines on encoding Manuscripts](https://betamasaheft.eu/Guidelines/?id=manuscripts)

Everything which is documented there is ok, but may not be printed out. 
Please ask if something is missing, either opening an issue or using the discussion feature.
You can work with this also if your encoding is not very detailed (see example files).

#### TEI elements used in Inscriptions 

Please see 
[EpiDoc guidelines](https://epidoc.stoa.org/gl/latest/) and relevant project guidelines.


#### Bibliography

The bibliography is compiled from the Zotero EthioStudies Group using both for citations and references the HLZ styles.
This does not guarantee the correctness of it, please see the relative documentation linked above. 

Other bibliography encoding methods are currently not supported.

#### Identifies entities (persons, places, works)
If you use `persName` and `placeName`, these will be made into links and if they do not contain text, they will print out the 
current standard name from BM. In the case of Works this follows some more complex requirements, which can be adjusted for specific use cases
and include the Clavis Aethiopica number.

### Figures

You may have your local files or not yet published images.
These can be put into the images folder and refer to by their filename.

```xml
<figure>
      <graphic url="images/myImage.jpeg" >
              <desc>Caption of my image</desc>
       </graphic>
</figure>
```
In the url attribute you may also point to an image available via any IIIF server, using its URL. Make sure you have permission to do so if that is required by the provider of the images.
```xml
<figure>
      <graphic url="https://betamasaheft.eu/iiif/AP/046/AP-046_014.tif/665,1084,465,125/full/0/default.jpg" >
              <desc>Caption of my image</desc>
       </graphic>
</figure>
```


You can also organize images in columns, for example
adding the images into a table

```xml
<table>
      <row role="label">
            <cell></cell>
            <cell></cell>
       </row>
       <row>
          <cell>
            <figure>
           <graphic url="images/imageleft.jpeg" >
              <desc>Caption of my image to the left</desc>
           </graphic>
           </figure>
         </cell>
            <cell>
            <figure>
               <graphic url="images/imegeright.jpeg">
                  <desc>Caption of my image to the right</desc>
               </graphic>
            </figure>
            </cell>
         </row>
         </table>
```

## Settings
In the file `settings.xml` you can decide on some of the features of your output. More customization options can be added upon request and the file itself contains these instructions.
The `settings.xml`file has already some configuration, if you want to get back to all defaults, edit or copy over from `settingstempalte.xml`.

` <format>book</format>`

This value can be set to "book", for the layout of a supplement 
        for Aethiopica or to "article" for a contribution to the 
        journal Aethiopica. In the second case, 
        items in orderOfParts like title page, acknowledgments, 
        toc, indexes should be omitted.
  
If your manuscripts all use a specific prefix for identification, please state it in the following element
 `  <localPrefix>Addis Ababa </localPrefix>`

In `<orderOfParts>` you can set the order and existence of parts of your catalogue
        simply move the tags and add the value 'yes' or 'no'.
        more parts can be added, but will require modifications to the package. If a manuscript does not contain a given part this will not be used.

  If you are printing a catalogue, into `<catalogueEntries>` you can decide in which order to
    treat the different parts of your entry, and which to include or not.
  Commonly you will list the contents of each manuscript. If you have selected this in   `<catalogueEntries>`
  you can further define what will be printed out in `<contentsStructure>`.
  
Exceptions are the rule and there are several you can set for contents, additions, keywords.
If you set indexes to be part of your publication, in `<indexes>` you can decide which indexes to print
    there can be more, and they can be better specified for selection and rendering, 

