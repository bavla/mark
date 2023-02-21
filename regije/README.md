# Regije

## Zemljevid

- https://dataoko.wordpress.com/2013/12/22/zapiski-zemljevid-obcin-gis-itd-1/
- https://www.stat.si/obcine/sl
- https://www.eea.europa.eu/data-and-maps/data/eea-reference-grids-2/gis-files/slovenia-shapefile
- http://www.diva-gis.org/gdata
- https://skupnostobcin.si/podatki/zemljevid-obcin-tabela/#p2
- https://www.gov.si/teme/obcine-v-stevilkah/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/Data/05C4003S.px/

Na http://www.diva-gis.org/gdata poberemo datoteko shape `SVN_adm.zip` za Slovenijo in jo razpakiramo v podpodročje `svn`.
Uporabimo recept iz  http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:clu:counties:bk . Morda bo potrebno namestiti paket `maptools`.

```
> setwd("C:/Users/vlado/DL/shape")
> library(maptools)
> gpclibPermit()
> SIout <- readShapeSpatial("svn/SVN_adm0.shp")
> SIsta <- readShapeSpatial("svn/SVN_adm1.shp")
> SIobc <- readShapeSpatial("svn/SVN_adm2.shp")
> str(SIobc,max.level=3)
> # plot(UScou,xlim=c(-124,-67),ylim=c(25,49),col=col[clu],bg="grey97",border="grey",lwd=0.001,asp=1.3)
> plot(SIobc,col="yellow",bg="grey97",border="grey",lwd=0.001,asp=1.3)
> plot(SIsta,lwd=0.005,border="blue",asp=1.3,add=TRUE)
> plot(SIout,lwd=0.008,border="black",asp=1.3,add=TRUE)

```
Žal nam `str` pokaže, da vsebujejo podatki v datoteki shape le 192 občin - so zastareli.

## Sveži podatki

Po kar nekaj googlanja sem našel čisto sveže podatke na 

Geodetska uprava Republike Slovenije,
Portal Prostor > Zbirke podatkov > Prostorske enote, naslovi > Register prostorskih enot:
https://ipi.eprostor.gov.si/jgp/data :
Prostorske enote: 19.02.2023 / shape

Datoteko `Prostorske_enote_DRZAVA_1.zip` sem si namestil na disk in razpakiral v podpodročje `slo`. To vsebuje več ZIPov. Datototeko `RPE_SLO_PROSTORSKE_ENOTE_obcine_20230219.zip` sem razpakiral v podpodpodročje `obcine`. Sedaj sem pripravljen za risanje
```
> SIobc <- readShapeSpatial("slo/obcine/RPE_SLO_PROSTORSKE_ENOTE_OBCINE_poligon.shp")
> str(SIobc,max.level=3)
> plot(SIobc,col="yellow",bg="grey97",border="grey",lwd=0.001,asp=1.3)
```
Tokrat nam `str` pokaže 212 občin - zemljevidski podatki so sveži. Žal zgleda, da novi `SIobc` ni usklajen s starima `SIsta` in `SIout`.

Lahko pa iz novega `SIobc` dobimo seznam imen občin za vozlišča v Pajkovi datoteki

```
> head(SIobc@data[,c("SIFRA","NAZIV")])
  SIFRA       NAZIV
0   143       Zavrč
1   146   Železniki
2    25   Dravograd
3    30 Gornji Grad
4    37          Ig
5    89     Pesnica
> obcine <- SIobc@data[,c("SIFRA","NAZIV")]
> p <- order(obcine$SIFRA)
> imena <- obcine[p,]
> head(imena)
   SIFRA      NAZIV
64     1 Ajdovščina
65     2   Beltinci
66     3       Bled
67     4     Bohinj
16     5  Borovnica
68     6      Bovec
> tail(imena)
    SIFRA                            NAZIV
142   208                     Log-Dragomer
143   209                Rečica ob Savinji
144   210 Sveti Jurij v Slovenskih goricah
145   211                       Šentrupert
146   212                            Mirna
63    213                          Ankaran
> 

```

## Relecija sosednosti občin

Morda bo potrebno namestiti paket `spdep`.

```
> sp2Pajek <- function(sp,file="neighbors.net",name=0,queen=TRUE){
+   library(spdep)
+   nbs <- poly2nb(sp,queen=queen)
+   n <- length(nbs); L <- card(nbs)
+   xy <- coordinates(sp)
+   IDs <- as.character(if(name>0) sp[[name]] else 1:n)
+   net <- file(file,"w")
+   cat("% sp2Pajek:",date(),"\n*vertices",n,"\n",file=net)
+   for(i in 1:n) cat(i,' "',IDs[i],'" ',xy[i,1],' ',xy[i,2],' 0.5\n',sep='',file=net)
+   cat("*edgeslist\n",file=net)
+   for(i in 1:n) if(L[i]>0) cat(i,nbs[[i]],"\n",file=net)
+   close(net)
+ }
> sids<-readShapePoly("slo/obcine/RPE_SLO_PROSTORSKE_ENOTE_OBCINE_poligon.shp")
> str(sids,max.level=2)
Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
  ..@ data       :'data.frame': 212 obs. of  6 variables:
  .. ..- attr(*, "data_types")= chr [1:6] "C" "N" "C" "N" ...
  ..@ polygons   :List of 212
  ..@ plotOrder  : int [1:212] 93 29 173 69 78 68 62 89 20 107 ...
  ..@ bbox       : num [1:2, 1:2] 374837 31292 622606 193753
  .. ..- attr(*, "dimnames")=List of 2
  ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slot
  ..$ comment: chr "FALSE"
> str(sids@data)
'data.frame':   212 obs. of  6 variables:
 $ EID_OBCINA: Factor w/ 212 levels "110200000110265167",..: 145 146 25 30 36 62 67 72 96 102 ...
 $ SIFRA     : int  143 146 25 30 37 89 100 107 129 136 ...
 $ NAZIV     : Factor w/ 212 levels "Ajdovščina","Ankaran",..: 206 207 37 43 54 120 136 147 186 197 ...
 $ OZNAKA_MES: int  0 0 0 0 0 0 0 0 0 0 ...
 $ DATUM_SYS : Date, format: "2022-05-30" "2022-05-30" "2022-05-30" "2022-05-30" ...
 $ NAZIV_DJ  : Factor w/ 0 levels: NA NA NA NA NA NA NA NA NA NA ...
 - attr(*, "data_types")= chr [1:6] "C" "N" "C" "N" ...
> sp2Pajek(sids,file="SIsosed.net",name="NAZIV")
```
Na datoteki `SIsosed.net` dobimo relacijo sosednosti slovenskih občin. Za pravilno delovanje znakov č, š, ž je z nekim znakovnim urejevalnikom (Emeditor, Textpad) preberemo in shranimo kot UTF-8 z BOM.

Drug problem je, da datoteka ne vsebuje vozlišča 145 (ima 212 vozlišč). Za povezovanje z drugimi datotekami je morda ustrezneje, če za ime/oznako vzamemo sestavo SIFRA-NAZIV.
```
> sids@data$ime <- paste(sids@data$SIFRA,sids@data$NAZIV,sep=":")
> str(sids@data)
'data.frame':   212 obs. of  7 variables:
 $ EID_OBCINA: Factor w/ 212 levels "110200000110265167",..: 145 146 25 30 36 62 67 72 96 102 ...
 $ SIFRA     : int  143 146 25 30 37 89 100 107 129 136 ...
 $ NAZIV     : Factor w/ 212 levels "Ajdovščina","Ankaran",..: 206 207 37 43 54 120 136 147 186 197 ...
 $ OZNAKA_MES: int  0 0 0 0 0 0 0 0 0 0 ...
 $ DATUM_SYS : Date, format: "2022-05-30" "2022-05-30" "2022-05-30" "2022-05-30" ...
 $ NAZIV_DJ  : Factor w/ 0 levels: NA NA NA NA NA NA NA NA NA NA ...
 $ ime       : chr  "143:Zavrč" "146:Železniki" "25:Dravograd" "30:Gornji Grad" ...
 - attr(*, "data_types")= chr [1:6] "C" "N" "C" "N" ...
> sp2Pajek(sids,file="SIsosedskost.net",name="ime")
```
Datoteki `SIsosedskost.net` sem dodal BOM in jo prebral v Pajka, kjer sem jo spravil v Pajkov koordinatni sistem in prezrcalil. Tako popravljeno datoteko sem shranil kot `SIsosediSN.net`.

