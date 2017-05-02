#!/usr/bin/env Rscript

# Simple usage of the issueReport() function.
issueReport(issueNumber = 1,
            githubUsername = "mkirch",
            # NOTE: Please replace githubToken with your own token!
            githubToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            githubUrl = "https://api.github.com/",
            githubRepo = "mkirch/issueReporter",
            setTitle = "Example Issue Report",
            setAuthor = "Michael Kirchner",
            outputDir = "/inst/examples/",
            outputFile = "exampleReportOne.pdf",
            includeIssue = TRUE)
