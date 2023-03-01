# wdir <- ".../2023/mark/SVGviewer"
# setwd(wdir)
makeSVGviewer <- function(svgFile,viewFile,width=0,height=0){
  scr <- readLines("https://raw.githubusercontent.com/bavla/mark/main/R/script.txt")
  svg <- readLines(svgFile)
  i <- grep("<svg",svg)[1]
  if(is.na(i)) {cat("bad SVG file\n"); return(NULL)}
  head <- "<html>\n<h1>SVG viewer</h1>\n<table bgcolor=lightskyblue width=90%>\n<tr><td align=center>\n"
  svgHead <- '<svg id="svgImage" '
  if(width*height>0) svgHead <- paste(svgHead,'width=',width,' height=',height,sep="")
  svg[i] <- gsub("<svg",svgHead,svg[i])
  writeLines(c(head,svg,scr),viewFile)
}

# makeSVGviewer("tooltips2.svg","svgPajek.html",width=500,height=400)
