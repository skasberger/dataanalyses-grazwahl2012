######################################################
#           								 
#   Title: functions_grw2012.R
#   Description: Functions of the analyses of the 
#								 Grazer Gemeinderatswahlen 2012
#								
#
#   Author: Stefan Kasberger
#   Date: 02.12.2012
#   Version: 1.0
#	  Language: 2.15.2
#   Software: RStudio 0.97.311
#   License: FreeBSD (2-clause BSD)
#   												 
######################################################

#
# Extracts the district out of the parish number
#
# variables
# data: the whole dataframe; 
# colParish: name of the column for the parish
# colDistrict: name of the column for the district
#

ExtractDistrict <- function(data, colParish="numParish", colDistrict="numDistrict") {
  library(stringr)
  temp <- data
  temp[[colParish]] <- NULL
  data <- as.character(data[[colParish]])
  length <- str_length(data)
  district <- str_sub(data, end = length - 2)
  data <- data.frame(as.numeric(data), as.numeric(district), temp)
  names(data)[1] <- colParish
  names(data)[2] <- colDistrict
  rm(temp, length, district)
  data
}

#
# reduce rows into one row per parish and transform the rows with votes per party into columns
#
# variables
#   data: the comlete table (dataframe)
#   colVotes: column name with the votes
#   colParty: column name with the party acronym
#

TransformVotes <- function(data, colVotes, colParty, numParties) {
  # save numbers of parishes and districts 
  tmp <- data[, c("numParish", "numDistrict")]
  tmp <- tmp[!duplicated(tmp),]
  
  # save 
  data <- data[, c("acrParty", "votes")]
  
  rows <- length(data[[colVotes]]) / numParties
  
  new <- data[[colVotes]]
  dim(new) <- c(numParties, rows)
  new <- data.frame(t(new))
  
  colNames <- lapply(data[1:numParties, colParty], paste0, "abs")
  names(new) <- colNames
  data <- cbind(tmp, new)
}


#
# DESCRIPTION
#
# variables
#

SaveJSON <- function(data) {
  filename <- paste0(environment[["folderDataJSON"]], "/", names(data), ".json")
  write(data[[1]],filename)
}


#
# DESCRIPTION
#
# variables
#


Boxplot <- function(data, filename, colors, names, title, yaxis, legend=F, output=T, svg=F, pdf=F, png=F) {
  
  # output to the console
  if(output) {
    boxplot(data, col=colors, names=names, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    
    title(title)
    dev.off()
  }
  
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    boxplot(data, col=colors, names=names, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    
    title(title)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    boxplot(data, col=colors, names=names, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=city[["partycolors"]])
    }
    
    title(title)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    
    boxplot(data, col=colors, names=names, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)

    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
}


#
# DESCRIPTION
#
# variables
#


VotesColumnChart <- function(data, filename, colors, names, title, yaxis, shift, legend=F, output=T, png=F, svg=F, pdf=F) {
  
  # output to the console
  if(output) {
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab=yaxis)
    text(x = bp, y=data + shift , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  round
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab=yaxis)
    text(x = bp, y=data + shift , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab=yaxis)
    text(x = bp, y=data + shift , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab=yaxis)
    text(x = bp, y=data + shift , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
}


#
# DESCRIPTION
#
# variables
#

Histogram <- function(data, filename, colors, title, xaxis, yaxis, output=T, png=F, svg=F, pdf=F) {
  
  # output to the console
  if(output) {
    
    hist(data, col=colors, breaks=100, main=title, xlab=xaxis, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    
    hist(data, col=colors, breaks=100, main=title, xlab=xaxis, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    
    hist(data, col=colors, breaks=100, main=title, xlab=xaxis, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    
    hist(data, col=colors, breaks=100, main=title, xlab=xaxis, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
  
}


#
# DESCRIPTION
#
# variables
#

DensityPlot <- function(data, filename, color, title, yaxis, output=T, png=F, svg=F, pdf=F) {
  
  # output to the console
  if(output) {
    plot(data,lwd=3,col=color, main=title, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    plot(data,lwd=3,col=color, main=title, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    plot(data,lwd=3,col=color, main=title, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    plot(data,lwd=3,col=color, main=title, ylab=yaxis)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=4, adj=1)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
}

#
# DESCRIPTION
#
# variables
#

CalculateCorrelation  <- function(dataParish, dataDistrict, corrMethod="pearson", folder, colors, namesIT, namesAT, yaxis, legend=F, output=T, png=F, svg=F, pdf=F) {
  
  if(dim(dataParish)[2] & length(names) & dim(dataDistrict)[2]) {
    
    numParties <- dim(dataParish)[2]
    
    corCoefPar <- array(NA, dim=c(numParties, numParties))
    corCoefDis <- array(NA, dim=c(numParties, numParties))
    
    for(i in seq_along(1:numParties)) {
      for(j in seq_along(1:numParties)) {
        if(i != j ) {
          corCoefPar[i, j] <- cor(dataParish[, i], dataParish[, j], method=corrMethod)
          corCoefDis[i, j] <- cor(dataDistrict[, i], dataDistrict[, j], method=corrMethod)
        }
      }
    }
    
    for(i in seq_along(1:numParties)) {
      corCoefDis[i, i] <- 1
      corCoefPar[i, i] <- 1
    }
    
    if(corrMethod == "pearson") {
      methName <- "Pearson"
      methAcr <- "Pear"
    }
      
    if(corrMethod == "spearman") {
      methName <- "Spearman"
      methAcr <- "Spear"
    }

    # plot correlations as barplots for every party
    for(i in seq_along(1:numParties)) {
      # parish
      CorrelationColumnChart(corCoefPar[i,], 
                             filename=paste0(folder, "barCorr", namesIT[i], methAcr, "ParAbs"), 
                             colors=colors, 
                             names=namesAT,
                             title=paste0(methName, " Korrelationen von ", namesAT[i], " nach Sprengel"), 
                             legend=legend, output=output, png=png, svg=svg, pdf=pdf)
      
      # district
      CorrelationColumnChart(corCoefDis[i,], 
                             filename=paste0(folder, "barCorr", namesIT[i], methAcr, "DisAbs", methAcr), 
                             colors=colors, 
                             names=namesAT,
                             title=paste0(methName, " Korrelationen von ", namesAT[i], " nach Bezirke"), 
                             legend=legend, output=output, png=png, svg=svg, pdf=pdf)
    }
    
    
  } else {
    print("Error: Length of names vector is not the same as number of columns in the dataset!")
  } 
}


#
# DESCRIPTION
#
# variables
#


CorrelationColumnChart <- function(data, filename, colors, names, title, legend=F, output=T, png=F, svg=F, pdf=F) {
  colText <- data
  colText[data<0] <- 0
  # output to the console
  if(output) {
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab="Korrelationskoeffizient")
    abline(h=mean(data), col="gray", lwd=2)
    text(x = bp, y=colText + 0.05 , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab="Korrelationskoeffizient")
    abline(h=mean(data), col="gray", lwd=2)
    text(x = bp, y=colText + 0.05 , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab="Korrelationskoeffizient")
    abline(h=mean(data), col="gray", lwd=2)
    text(x = bp, y=colText + 0.05 , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    
    bp <- barplot(data, col=colors, names=names, main=title, ylab="Korrelationskoeffizient")
    abline(h=mean(data), col="gray", lwd=2)
    text(x = bp, y=colText + 0.05 , labels=as.character(round(data, digits=2)), xpd=TRUE)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
  
}

#
# DESCRIPTION
#
# variables
#

WriteCSV <- function(data, filename, folder = "QGIS", enc = "UTF-8") {
  write.csv(data, paste0(folder, "/", filename, "_comma[", enc, "].csv"), fileEncoding = enc)
  write.csv2(data, paste0(folder, "/", filename, "_semicolon[", enc, "].csv"), fileEncoding = enc)
}

BoxplotLR <- function(data, colSeg, filename, colors, names, title, yaxis, legend=F, output=T, svg=F, pdf=F, png=F) {
  
  # output to the console
  if(output) {
    boxplot(data ~ colSeg, col=colors, names=names)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    title(title)
    dev.off()
  }
  
  # export png
  if(png) {
    png(file=paste0(filename, ".png"), height=400, width=600)
    boxplot(data ~ colSeg, col=colors, names=names)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=colors)
    }
    
    title(title)
    dev.off()
  }
  
  # export svg
  if(svg) {
    svg(file=paste0(filename, ".svg"), height=4, width=6, onefile=TRUE)
    boxplot(data ~ colSeg, col=colors, names=names)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)
    
    if(legend) {
      legend("topright", names, fill=city[["partycolors"]])
    }
    
    title(title)
    dev.off()
  }
  
  # export pdf
  if(pdf) {
    boxplot(data ~ colSeg, col=colors, names=names)
    mtext("Datenquelle: Stadt Graz - data.graz.gv.at, CC-by", side=1, line=3, adj=1)

    if(legend) {
      legend("topright", names, fill=colors)
    }
    title(title)
    dev.copy2pdf(file=paste0(filename, ".pdf"))
  }
}


