# Barve v Pajku

**Vprašanje:**

... se mogoče da barve custom določati za izvoz v SVG, ali je na voljo samo tisto kar je v paleti pri options?

**Odgovor:**

Obstaja nekaj načinov, kako pobarvati po svoje. Le posebej se je potrebno potruditi.
Poglej v Pajkov priročnik http://mrvar.fdv.uni-lj.si/pajek/pajekman.pdf .

Barve lahko po svoje določiš v Pajkovi datoteki omrežja net ali paj - glej strani 78 in 95 (in vmes) priročnika. Omrežje, ki ga hočeš narisati shraniš na datoteko in določiš barve po svoje. 

Najenostavneje je morda, da ga pobarvaš z obstoječo paleto in v datoteki z opisom slike (SVG, EPS, X3D) samo zamenjaš barve palete z izbranimi. Ker so datoteke s slikami znakovne datoteke, lahko to storiš s katerimkoli znakovnim urejevalnikom.

Naslednja možnost je, če popravkov ni veliko, da barve zamenjaš v programu za urejanje slik - npr. Inkscape.

## Prebarvanje opisa slike v SVG

Pajkov opis slike v SVG je znakovna datoteka. Barve so določene z RGB. Tako vozlišča kot povezave so pravzaprav liki. Pri vsakem liku lahko določimo barvo roba (`stroke`) in barvo notranjosti (`fill`). 

vozlišča
```
<!-- Vertex:    60 -->
<ellipse cx="374.84" cy="404.35" rx="10.00" ry="10.00" style="fill:rgb(255,255,0);stroke:rgb(102,0,0);stroke-width:0.50;"/>
<text x="380.02" y="423.66" style="font-family:Arial;font-weight: bold;font-size:15px;fill:rgb(173,0,0)">Trzin</text>
```
povezave
```
<!-- Edge:    46   73 -->
<path d="M 371.71 370.45 C 369.43 368.15 359.68 351.08 358.85 347.95" style="stroke-width:2.00;stroke:rgb(0,112,145);fill:none"/>
```

Sliko lahko prebarvaš tako, da v izbranem delu opisa vse pojavitve izbrane barve rgb(r1,g1,b1) zamenjaš z drugo barvo rgb(r2,g2,b2), kar omogoča večina znakovnih urejevalnikov. Če bi rad to večkrat naredil, se splača sprogramirati - kakih 10 do 20 vrstic kode.

### Programsko prebarvanje

Za preizkušanje sem pripravil datoteko `barve.paj`. Pobarvamo jo s standardno paleto in izvozimo sliko kot `barve.svg`. Ogledamo si jo.

Najprej sestavimo tabelo pravil prebarvanja. Pravilo [a,b,c] pravi: če tekoča vrstica datoteke vsebuje niz a, potem v njem zamenjaj pojavitve niza b z nizom c.
```
> k <- 8
> rule <- matrix("",nrow=k,ncol=3)
> rule[1,] <- c("ellipse","rgb(255,255,0)","rgb(218,165,32)") # golden rod
> rule[2,] <- c("ellipse","rgb(127,255,0)","rgb(154,205,50)") # yellow green
> rule[3,] <- c("ellipse","rgb(255,0,0)","rgb(100,149,237)") # corn flower blue
> rule[4,] <- c("ellipse","rgb(0,0,255)","rgb(75,0,130)") # indigo
> rule[5,] <- c("ellipse","rgb(255,216,242)","rgb(210,105,30)") # chocolate
> rule[6,] <- c("line","rgb(0,127,255)","rgb(85,107,47)") # dark olive green
> rule[7,] <- c("line","rgb(183,0,0)","rgb(255,20,147)") # deep pink
> rule[8,] <- c("path","rgb(183,0,0)","rgb(255,20,147)") # deep pink / arrow
```
Pri pripravi tabele si lahko pomagamo s seznamom iz https://www.rapidtables.com/web/color/RGB_Color.html .

Prebarvanje opravi funkcija (najbrž se jo da učinkoviteje sprogramirati)
```
> reColor <- function(S,rule) {
+   for(j in 1:length(S)){
+     out <- S[j]
+     for(i in 1:nrow(rule)) if(length(grep(rule[i,1],out,fixed=TRUE))>0){
+       out <- gsub(rule[i,2],rule[i,3],out,fixed=TRUE)
+     }
+     S[j] <- out
+   }
+   return(S)
+ }
```
Sedaj še preberemo izvorno datoteko, jo prebarvamo in shranimo na novo datoteko: 
```
> writeLines(reColor(readLines("barve.svg"),rule),"novebarve.svg")
```

```

```
