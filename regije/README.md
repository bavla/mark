# Regije

## Zemljevid

- https://dataoko.wordpress.com/2013/12/22/zapiski-zemljevid-obcin-gis-itd-1/
- https://www.stat.si/obcine/sl
- https://www.eea.europa.eu/data-and-maps/data/eea-reference-grids-2/gis-files/slovenia-shapefile
- http://www.diva-gis.org/gdata
- https://skupnostobcin.si/podatki/zemljevid-obcin-tabela/#p2
- https://www.gov.si/teme/obcine-v-stevilkah/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/Data/05C4003S.px/

```
# http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:clu:counties:bk

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
