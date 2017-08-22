#trying again via merge##
##couldnt be bothered to put the file names for all these, but they should be apparent
##step 1: make a base##
#use monarch_genome.bed
scaffbase=read.table(file.choose())
colnames(scaffbase)=c("Scaffold","Length")
#step 2: add to it by reading in and appending##
m36=read.table(file.choose())
colnames(m36)=c("Scaffold","M36M")
inprog=merge(scaffbase,m36,by="Scaffold",all=T)
##step 3: the rest of the appends look like this
m38=read.table(file.choose())
colnames(m38)=c("Scaffold","M38F")
inprog=merge(inprog,m38,by="Scaffold",all=T)
##and again
stm123=read.table(file.choose())
colnames(stm123)=c("Scaffold","STM123F")
inprog=merge(inprog,stm123,by="Scaffold",all=T)
stm146=read.table(file.choose())
colnames(stm146)=c("Scaffold","STM146M")
inprog=merge(inprog,stm146,by="Scaffold",all=T)
HI035=read.table(file.choose())
colnames(HI035)=c("Scaffold","HI035F")
inprog=merge(inprog,HI035,by="Scaffold",all=T)
HI004=read.table(file.choose())
colnames(HI004)=c("Scaffold","HI004M")
inprog=merge(inprog,HI004,by="Scaffold",all=T)
#finally save it
write.table(inprog,file="/Users/Andrew/Downloads/test/mergedcount.txt")

###let's try this with the depth of coverage too###
scaffbase=read.table(file.choose())
colnames(scaffbase)=c("Scaffold","Length")
#step 2: add to it by reading in and appending##
m36=read.table(file.choose())
colnames(m36)=c("Scaffold","M36M")
inprog=merge(scaffbase,m36,by="Scaffold",all=T)
##step 3: the rest of the appends look like this
m38=read.table(file.choose())
colnames(m38)=c("Scaffold","M38F")
inprog=merge(inprog,m38,by="Scaffold",all=T)
##and again
stm123=read.table(file.choose())
colnames(stm123)=c("Scaffold","STM123F")
inprog=merge(inprog,stm123,by="Scaffold",all=T)
stm146=read.table(file.choose())
colnames(stm146)=c("Scaffold","STM146M")
inprog=merge(inprog,stm146,by="Scaffold",all=T)
HI035=read.table(file.choose())
colnames(HI035)=c("Scaffold","HI035F")
inprog=merge(inprog,HI035,by="Scaffold",all=T)
HI004=read.table(file.choose())
colnames(HI004)=c("Scaffold","HI004M")
inprog=merge(inprog,HI004,by="Scaffold",all=T)
#finally save it
write.table(inprog,file="/Users/Andrew/Downloads/test/mergedcoveragedepth.txt")

##with the actual read count
#trying again via merge##
##couldnt be bothered to put the file names for all these, but they should be apparent
##step 1: make a base##
#use monarch_genome.bed
scaffbase=read.table(file.choose())
colnames(scaffbase)=c("Scaffold","index","Length")
#step 2: add to it by reading in and appending##
m36=read.table(file.choose())
colnames(m36)=c("Scaffold","index","Length","M36M")
inprog=merge(scaffbase,m36,by=c("Scaffold","index","Length"),all=T)
##step 3: the rest of the appends look like this
m38=read.table(file.choose())
colnames(m38)=c("Scaffold","index","Length","M38F")
inprog=merge(inprog,m38,by=c("Scaffold","index","Length"),all=T)
##and again
stm123=read.table(file.choose())
colnames(stm123)=c("Scaffold","index","Length","STM123F")
inprog=merge(inprog,stm123,by=c("Scaffold","index","Length"),all=T)
stm146=read.table(file.choose())
colnames(stm146)=c("Scaffold","index","Length","STM146M")
inprog=merge(inprog,stm146,by=c("Scaffold","index","Length"),all=T)
HI035=read.table(file.choose())
colnames(HI035)=c("Scaffold","index","Length","HI035F")
inprog=merge(inprog,HI035,by=c("Scaffold","index","Length"),all=T)
HI004=read.table(file.choose())
colnames(HI004)=c("Scaffold","index","Length","HI004M")
inprog=merge(inprog,HI004,by=c("Scaffold","index","Length"),all=T)
#finally save it
write.table(inprog,file="/Users/Andrew/Downloads/test/mergedmulticount.txt")

##specifically scaffold 28##
#start with M36
inprog=read.table(file.choose())
colnames(inprog)=c("Scaffold","Base","M36M")
#step 2: add to it by reading in and appending##
##step 3: the rest of the appends look like this
m38=read.table(file.choose())
colnames(m38)=c("Scaffold","Base","M38F")
inprog=merge(inprog,m38,by=c("Scaffold","Base"),all=T)
##and again
stm123=read.table(file.choose())
colnames(stm123)=c("Scaffold","Base","STM123F")
inprog=merge(inprog,stm123,by=c("Scaffold","Base"),all=T)
stm146=read.table(file.choose())
colnames(stm146)=c("Scaffold","Base","STM146M")
inprog=merge(inprog,stm146,by=c("Scaffold","Base"),all=T)
HI035=read.table(file.choose())
colnames(HI035)=c("Scaffold","Base","HI035F")
inprog=merge(inprog,HI035,by=c("Scaffold","Base"),all=T)
HI004=read.table(file.choose())
colnames(HI004)=c("Scaffold","Base","HI004M")
inprog=merge(inprog,HI004,by=c("Scaffold","Base"),all=T)
#finally save it
write.table(inprog,file="/Users/Andrew/Downloads/test/merged28.txt")
