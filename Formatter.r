# A Stata HTML formatter in R

# Load up your Stata do file.
txt <- readLines(
  "https://raw.github.com/EconometricsBySimulation/2013-07-30-Diff-n-Diff/master/Code.do")

# First subsititute out all of the < and > which can be misinterpretted as 
# tags in HTML.
txt <- gsub("<","&lt;",txt) 
txt <- gsub(">","&gt;",txt) 

# Choose the formatting tags you would like applied to each field type.
comment.start <- '<span style="color: #669933">'
comment.end   <- '</span>'

# I would like to auto format all numbers but I have nto yet been able to figure
# out how to do this.
num.start <- '<span style="color: #990000"><b>'
num.end   <- '</b></span>'

punc.start <- '<span style="color: #0000FF">'
punc.end   <- '</span>'

command1.start <- '<span style="color: #0000CC"><b>'
command1.end   <- '</b></span>'

command2.start <- '<span style="color: #9900FF">'
command2.end   <- '</span>'

command3.start <- '<span style="color: #990033">'
command3.end   <- '</span>'

# I am not sure where exactly I got this 
stata.commands1 <- unlist(strsplit(readLines(
  "https://raw.github.com/EconometricsBySimulation/RFormatter/master/Stata/C1.txt")
                            , split=" "))
stata.commands2 <- unlist(strsplit(readLines(
  "https://raw.github.com/EconometricsBySimulation/RFormatter/master/Stata/C2.txt")
                            , split=" "))
stata.commands3 <- unlist(strsplit(readLines(
  "https://raw.github.com/EconometricsBySimulation/RFormatter/master/Stata/C3.txt")
                            , split=" "))

punc <- unlist(strsplit(readLines(
  "https://raw.github.com/EconometricsBySimulation/RFormatter/master/Stata/Punc.txt")
                           , split=" "))

# I want to figure out how to highlight the puncuation as well but I am having trouble
# with that.
# for (v in punc) txt<-  gsub(v, 
#        paste0(punc.start,v,punc.end), txt)

# Create a vector to tell R to ignore entire lines.
comment <- (1:length(txt))*0

# '*' Star comment recognizer
for (i in grep("[:*:]", txt)) {
  # Break each line to discover is the first symbol which is not a space is a *
  txt2 <- strsplit(txt[i], split=" ")[[1]]
  if (txt2[txt2!=""][1]=="*") {
    txt.rep <- paste(c(comment.start,txt[[i]],comment.end), collapse="")
    txt[[i]] <- txt.rep
    comment[i] <- 1
  }
}

# '//' Comment recognizer
for (i in (grep("//", txt))) if (comment[i]==0) {
  txt2 <- strsplit(txt[i], split=" ")[[1]]
  comment.place <- grep("//", txt2)[1]-1
  txt.rep <- paste(c(txt2[1:comment.place], comment.start, 
                     txt2[-(1:comment.place)],comment.end), collapse=" ")
    txt[[i]] <- txt.rep
}

# Format stata commands that match each list
# "\\<",v,"\\>" ensures only entire word matches
# are used.
for (v in stata.commands1) txt[comment==0]<-
  gsub(paste0("\\<",v,"\\>"), 
       paste0(command1.start,v,command1.end), 
       txt[comment==0])

for (v in stata.commands2) txt[comment==0]<-
  gsub(paste0("\\<",v,"\\>"), 
       paste0(command2.start,v,command2.end), 
       txt[comment==0])

for (v in stata.commands3) txt[comment==0]<-
  gsub(paste0("\\<",v,"\\>"), 
       paste0(command3.start,v,command3.end), 
       txt[comment==0])

# This is my attempt at highlighting all numbers that are not words.
# It did not work.  
# <a href ="http://stackoverflow.com/questions/18160131/replacing-numbers-r-regular-expression">stackoverflow topic</a>
# txt <- gsub(".*([[:digit:]]+).*", paste0(num.start,"\\1",num.end), txt)

# Add tags to the end and beginning to help control the general format.
txt <- c('<pre><span style="font-family: monospace',txt,'</span></pre>')

# Copy formatted HTML to the clipboard.
writeClipboard(paste(txt, collapse="\n"))
