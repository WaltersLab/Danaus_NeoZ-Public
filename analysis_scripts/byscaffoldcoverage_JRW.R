library(zoo)

# Import median coverage data
#mergedcoveragedepth.txt
coveragedata <- read.table("../input_files/mergedcoveragedepth.txt",header=T, stringsAsFactors = F)

# calculate N90 scaffold size.  
scaffL <- sort(coveragedata$Length, decreasing=T)
genomeSize <- sum(scaffL)
scaffCumsum <- cumsum(scaffL)
genome90 <- 0.90 * genomeSize
n90bp <- scaffL[ scaffCumsum > genome90][1]


##remove incomplete cases
coverageforz <- na.omit(coveragedata)
# require scaffolds have non-zero median coverages in all samples
nonZero <- apply(coverageforz[,3:8],1, function(x) {all(x > 0)} ) 
notShort <- coverageforz$Length > n90bp # exclude short scaffolds
coverageforz <- coverageforz[ nonZero & notShort , ] 


#now we get our normalizer for the individual scaffold stuff
normconverter <- apply(coverageforz[,3:8], 2, mean)

#function to read in, sort by position, and normalize scaffolds
scaffoldpipe <- function(x)
{
	scaff <- read.table(x,header = T)
	scaff <- na.omit(scaff)
	scaff <- scaff[order(scaff$Base),]
	normscaff <- t(t(scaff[3:8])/normconverter)
	return(normscaff)
}


scaff01 <-scaffoldpipe("../input_files/merged01.txt.gz")
M01 <- (scaff01[,1] + scaff01[,4] + scaff01[,6])/3
F01 <- (scaff01[,2] + scaff01[,3] + scaff01[,5])/3

##pls note scaffold 28's merged file is ordered differently for some reason unknown to Man and God alike
scaff28 <-scaffoldpipe("../input_files/merged28.txt.gz")
M28 <- (scaff28[,1] + scaff28[,3] + scaff28[,5])/3
F28 <- (scaff28[,2] + scaff28[,4] + scaff28[,6])/3

##44 also has a goofy order, ten cuidado
scaff44 <-scaffoldpipe("../input_files/merged44.txt.gz")
M44 <- (scaff44[,1] + scaff44[,4] + scaff44[,6])/3
F44 <- (scaff44[,2] + scaff44[,3] + scaff44[,5])/3

scaff403 <-scaffoldpipe("../input_files/merged403.txt.gz")
M403 <- (scaff403[,1] + scaff403[,4] + scaff403[,6])/3
F403 <- (scaff403[,2] + scaff403[,3] + scaff403[,5])/3


# # par(mfrow=c(2,4))
# plot(1:length(M01),M01,ylim=c(0,4),type="h")
# plot(1:length(M28),M28,ylim=c(0,4),type="h")
# plot(1:length(M44),M44,ylim=c(0,4),type="h")
# plot(1:length(M403),M403,ylim=c(0,4),type="h")
# plot(1:length(F01),F01,ylim=c(0,4),type="h")
# plot(1:length(F28),F28,ylim=c(0,4),type="h")
# plot(1:length(F44),F44,ylim=c(0,4),type="h")
# plot(1:length(F403),F403,ylim=c(0,4),type="h")

# Function to plot smoothed, normalized coverage across a single chromosome
smoothCov <- function(bp=M28, winsize=1000, stepsize=100, dataout = FALSE, polycol = "grey", ...) {
	bpsmooth <- rollapply(data= bp, width=winsize, by = stepsize, FUN = median)
	steps <- seq(from = winsize/2, to = (length(bpsmooth)-1) * stepsize + (winsize/2), by = stepsize)
	#bpsmooth <- rollmean(x=bp, k=winsize, by = stepsize, fill="extend")
	plot(y=bpsmooth, x=steps, type = "l", ...)
	polygon(y=c(0,bpsmooth,0), x=c(steps[1],steps,tail(steps, 1)), col = polycol)
	
	if (dataout) {
		return(cbind(bpsmooth, steps))
	}
}

# development code for testing smoothCov()
# par (mfrow = c(2,1))
# smoothCov(bp = M28, winsize=10000, stepsize=1000, ylim = c(0,5))
# smoothCov(bp = F28, winsize=10000, stepsize=1000, ylim = c(0,5))

# par (mfrow = c(2,1))
# smoothCov(bp = M44, winsize=10000, stepsize=1000, ylim = c(0,3))
# smoothCov(bp = F44, winsize=10000, stepsize=1000, ylim = c(0,3))



# This plotting function gives male and female coverage plots plus the running M:F coverage ratio.  It does NOT incorporate breakpoints for Z vs A.
plot.scaff.mf <- function ( mcov, fcov, winsize=5000, stepsize=500, polycol, title.text=NULL, ...) {
	
	labcex <- 0.8
	
	plot.new()
	par(fig=c(0,1,.64,.91), oma = c(0,0,0,0), mar = c(.1,5,.1,1), bty = "n", new = TRUE)
	mcov.smooth <- smoothCov(bp = mcov, winsize = winsize, stepsize=stepsize, ylim = c(0,3), dataout = T, xaxt = "n", yaxt = "n", ylab = "Male coverage\n(Normalized)", cex.lab = labcex, polycol=polycol, ...)
	axis(side = 2, at =0:2)
	
	par(fig=c(0,1,.37,.64), new = TRUE)
	fcov.smooth <- smoothCov(bp = fcov, winsize = winsize, stepsize=stepsize, ylim = c(0,3), dataout = T, xaxt = "n", yaxt = "n", ylab = "Female coverage\n(Normalized)", cex.lab = labcex, polycol=polycol,...)
	axis(side = 2, at =0:2)
	
	par(fig=c(0,1,.1,.37),mar = c(2,5,.1,1), new = TRUE)
	mfratio <- mcov.smooth[, 1] / fcov.smooth[, 1]
	plot(x = mcov.smooth[, 2], y = mfratio, typ = "l", ylim = c(0,3), xaxt = "n", yaxt = "n", ylab = "Male:Female\ncoverage ratio", cex.lab = labcex, col = "red", ...)
	axis(side = 2, at =0:2)
	myticks <- seq(0, 2e6, 2.5e5)
	axis(side = 1, at = myticks, labels = myticks/1e6 )
	mtext("Scaffold Position (Mbp)", side = 1, outer = F, line = 2.5)
	mtext(title.text, side = 3, outer=T, line = -1.8)
}

# This function identifies the major breakpoints between Z & A, plotting the difference in adjacent windows if desired.
find.breaks <- function(mcov, fcov, winsize=NULL, stepsize = NULL, plotit = TRUE, ...) {
	if(is.null(winsize)) {winsize <- round(0.1 * length(mcov))}
	if(is.null(stepsize)) {stepsize = round(0.01 * length(mcov))}

	mfratio <- mcov/fcov
	mfratio.smooth <- rollapply(mfratio, width = winsize, by = stepsize, FUN = function(x) median(x[is.finite(x) & ! is.na(x)]))
	
	steps <- seq(from = winsize/2, to = (length(mfratio.smooth)-1) * stepsize + (winsize/2), by = stepsize)
	offset <- round(winsize/stepsize) #offset is difference in index between non-overlapping windows
	diff <- rep(1,(length(steps)-offset))
	for (i in 1:(length(steps)-offset)) {
		diff[i] <- mfratio.smooth[i] - mfratio.smooth[i+offset]	
	}
		x.pos <- (seq_along(diff) * stepsize) + winsize
	
	if (plotit) {
		plot(x = x.pos/1e6, y = abs(diff), type = "l", ...)
	}
	split <- which(abs(diff) == max(abs(diff)))[1]
	split.pos <- x.pos[split]
	return(split.pos)
}




# this plots contrasts of M & F coverage, as above, but also includes a point indicating Z-A breakpoints. 
plot.scaff.breaks <- function ( mcov, fcov, breakwin=1e4, breakstep=1e3, winsize=5000, stepsize=500, polycol, plotBreaks = TRUE, xTicks = seq(0, 2e6, 2.5e5), title.text=NULL, ...) {
	
	labcex <- 0.8
	
	plot.new()
	par(fig=c(0,1,.64,.91), oma = c(0,0,0,0), mar = c(.1,5,.1,1), bty = "n", new = TRUE)
	mcov.smooth <- smoothCov(bp = mcov, winsize = winsize, stepsize=stepsize, ylim = c(0,3), dataout = T, xaxt = "n", yaxt = "n", ylab = "Male coverage\n(Normalized)", cex.lab = labcex, polycol=polycol, ...)
	axis(side = 2, at =0:2)
	
	par(fig=c(0,1,.37,.64), new = TRUE)
	fcov.smooth <- smoothCov(bp = fcov, winsize = winsize, stepsize=stepsize, ylim = c(0,3), dataout = T, xaxt = "n", yaxt = "n", ylab = "Female coverage\n(Normalized)", cex.lab = labcex, polycol=polycol,...)
	axis(side = 2, at =0:2)
	
	par(fig=c(0,1,.1,.37),mar = c(2,5,.1,1), new = TRUE)
	mfratio <- mcov.smooth[, 1] / fcov.smooth[, 1]
	plot(x = mcov.smooth[, 2], y = mfratio, typ = "l", ylim = c(0,3), xaxt = "n", yaxt = "n", ylab = "Male:Female\ncoverage ratio", cex.lab = labcex, col = "red", ...)
	axis(side = 2, at =0:2)
	myticks <- xTicks
	axis(side = 1, at = myticks, labels = myticks/1e6 )
	
	if(plotBreaks) {
		split.pos <- find.breaks(mcov = mcov, fcov = fcov, winsize=breakwin, stepsize=breakstep, plotit = FALSE)
		points(x = split.pos, y = .25, pch = 8)
	}
	
	mtext("Scaffold Position (Mbp)", side = 1, outer = F, line = 2.5)
	mtext(title.text, side = 3, outer=T, line = -1.8)
}


# Scaff28 clearly has two autosomal segments sandwiching the Z segment.  I'll need to partition the analyses to get these points out.

start.subset <- 1.5e6
m28subset <- start.subset : length(M28)


# Set up window and stepsizes for localizing breakpoints.
# window <- NULL; step<- 5000 # places breaks inside genes 2/3 times, but placements seems quite accurate
#window <- 1e5; step <- 1e4
window.big <- 1.5e5; step.big <- 1e4
window.small <- 1e4; step.small<- 1e3

pdf("../output/max_mf_window_diff.pdf", w = 8, h = 4, pointsize = 10)
par(mar=c(5,7,2,2))
split01   <- find.breaks(mcov = M01, fcov = F01, winsize = window.big, stepsize=step.big, xlab = "Scaffold Position (Mbp)", ylab = "Absolute diference between\nadjacent windows of M:F ratio", main = "DPSCF300001")
split28.1 <- find.breaks(mcov = M28, fcov = F28, winsize = window.big, stepsize=step.big, xlab = "Scaffold Position (Mbp)", ylab = "Absolute diference between\nadjacent windows of M:F ratio", main = "DPSCF300028")
split28.2 <- find.breaks(mcov = M28[m28subset], fcov = F28[m28subset], winsize = window.small , stepsize= step.small, xlab = "Scaffold Position (Mbp)", ylab = "Absolute diference between\nadjacent windows of M:F ratio", main = "DPSCF300028 > 1.5 Mbp")
split44   <- find.breaks(mcov = M44, fcov = F44, winsize = window.small , stepsize= step.small, xlab = "Scaffold Position (Mbp)", ylab = "Absolute diference between\nadjacent windows of M:F ratio", main = "DPSCF300044")
dev.off()
split28.2 <- split28.2 + start.subset # correct reported coordinate for subset.





pdf("../output/coverage_by_posxn.pdf", w = 8, h = 4, pointsize = 10)
window <- 5000; step<- 1000
plot.scaff.breaks(mcov = M28, fcov = F28,   breakwin=window.big, breakstep=step.big,     winsize = window, stepsize=step, xlim = c(1, 2.00e6), xTicks = seq(0, 2e6, 2.5e5), polycol = "steelblue1", title.text = "DPSCF300028" )
points(x = split28.2, y = 0.25, pch = 8)  # manually add 2nd break point to plot
plot.scaff.breaks(mcov = M44, fcov = F44,   breakwin=window.small, breakstep=step.small, winsize = window, stepsize=step, xlim = c(1, 1.25e6), xTicks = seq(0, 1.25e6, 2.5e5), polycol = "steelblue1", title.text = "DPSCF300044" )
plot.scaff.breaks(mcov = M01, fcov = F01,   breakwin=window.big , breakstep=step.big,   winsize = window, stepsize=step, xlim = c(1, 6.25e6), xTicks = seq(0, 6.25e6, 2.5e5), polycol = "steelblue1", title.text = "DPSCF300001", plotBreaks = TRUE )
plot.scaff.breaks(mcov = M403, fcov = F403, winsize = window, stepsize=step, xlim = c(1, .2e6), xTicks = seq(0, .2e6, .25e5), polycol = "steelblue1", title.text = "DPSCF300403", plotBreaks = FALSE )
dev.off()

# plot.scaff.breaks(mcov = M28[m28subset], fcov = F28[m28subset], winsize = window, stepsize=step, xlim = c(1, .4e6), polycol = "steelblue1", title.text = "DPSCF300028: >1.5 Mpb" )

break.points <- c(split01, split28.1, split28.2, split44)
names(break.points) <- c("split01", "split28.1", "split28.2", "split44")
dump("break.points", file = "../output/ZA_chimera_breaks.R")



