# Use the default data to avoid token requirement for testing purposes
# Generate markdown text string
library(issueReporter)
setwd(tempdir())

testMD <- issuesData2md()

# Use default data to generate PDF
issuesGenPDF(style = "tint",
             RmdLocation =  system.file("rmarkdown/templates/", "tint.Rmd",
                                        package = "issueReporter"),
             outputFile = tempfile(pattern="ir", fileext=".pdf"),
             outputDir = tempdir(),
             md = testMD,
             setTitle = "Example Notes",
             setAuthor = "Author Name")
