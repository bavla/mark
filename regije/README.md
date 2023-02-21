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
Uporabimo recept iz  http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:clu:counties:bk

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

Sveži podatki

Po kar nekaj googlanja sem našel čisto sveže podatke na 

Geodetska uprava Republike Slovenije,
Portal Prostor > Zbirke podatkov > Prostorske enote, naslovi > Register prostorskih enot:
https://ipi.eprostor.gov.si/jgp/data :
Prostorske enote: 19.02.2023 / shape

Datoteko `Prostorske_enote_DRZAVA_1.zip` sem si namestil disk in razpakiral v podpodročje `slo`. To vsebuje več ZIPov. Datototeko `RPE_SLO_PROSTORSKE_ENOTE_obcine_20230219.zip` sem razpakiral v podpodpodročje `obcine`. Sedaj sem pripravljen za risanje
```
> SIobc <- readShapeSpatial("slo/obcine/RPE_SLO_PROSTORSKE_ENOTE_OBCINE_poligon.shp")
> str(SIobc,max.level=3)
> plot(SIobc,col="yellow",bg="grey97",border="grey",lwd=0.001,asp=1.3)
```
Tokrat nam `str` pokaže 212 občin - zemljevidski podatki so sveži. Žal zgleda, da novi SIobc ni usklajen s starima SIsta in SIout.

Lahko pa iz SIobc dobimo seznam imen občin za vozlišča v Pajkovi datoteki

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

