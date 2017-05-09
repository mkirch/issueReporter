#' @title Generate a PDF report from a GitHub issue thread.
#'
#' @description
#' For a given GitHub issue, extracts all issue comments and generates a PDF
#' report of each user's contributions to the thread. View /inst/examples/
#' to see a quick sample and output besides the usage below.
#'
#' @param issueNumber Integer GitHub issue number.
#' @param outputFile String containing file name for R Markdown pdf output,
#' \code{report.Rmd} if NULL.
#' @param outputDir String containing directory address for R markdown output,
#' working directory if NULL.
#' @param githubUsername String of GitHub username to authenticate with.
#' @param githubToken String containing GitHub personal access token, as
#' generated from the settings area in your GitHub account.
#' @param githubUrl String containing the API URL for GitHub. If using a GitHub
#' Enterprise account, use http(s)://hostname/api/v3/ instead of default. Please
#' make sure to append a \code{`/`}.
#' @param githubRepo String of format \code{user/repo} specifying the GH repo.
#' @param setTitle String containing report title.
#' @param setAuthor String containing report author.
#' @param includeTitle Bool where TRUE includes the title, and FALSE excludes.
#' @param includeBody Bool where TRUE includes the original issue, and FALSE
#' includes only the issue comments.
#' @param test Bool If we are using this in test mode.
#' @import tint
#' @import httpuv
#' @import jsonlite
#' @export
issueReport <- function(issueNumber = 1,
                        outputFile = NULL,
                        outputDir = NULL,
                        githubUsername = "xxxxxxxxxxxxxxxxxxxx",
                        githubToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                        githubUrl = "https://api.github.com/",
                        githubRepo = "mkirch/issueReporter",
                        setTitle = "Issue Notes",
                        setAuthor = "Julius Caesar",
                        includeTitle = TRUE,
                        includeBody = TRUE,
                        test = FALSE){
  dat <- issuesData(
    issueNumber = issueNumber,
    githubUsername = githubUsername,
    githubToken = githubToken,
    githubUrl = githubUrl,
    githubRepo = githubRepo
  )
  md <- issuesData2md(issuesData = dat,
                      includeTitle = includeTitle,
                      includeBody = includeBody)
  issuesGenPDF(
    style = "tint",
    RmdLocation =  system.file("rmarkdown/templates/",
                               "tint.Rmd",
                               package = "issueReporter"),
    outputFile = outputFile,
    outputDir = outputDir,
    md = md,
    setTitle = setTitle,
    setAuthor = setAuthor
  )
}

#' @title Get Issues data from GitHub.
#'
#' @description
#' For a given GitHub issue, extracts all issue comments.
#'
#' @param issueNumber Integer GitHub issue number.
#' @param githubUsername String of GitHub username to authenticate with.
#' @param githubToken String containing GitHub personal access token, as
#' generated from the settings area in your GitHub account.
#' @param githubUrl String containing the API URL for GitHub. If using a GitHub
#' Enterprise account, use http(s)://hostname/api/v3/ instead of default. Please
#' make sure to append a \code{`/`}.
#' @param githubRepo String of format \code{user/repo} specifying the GH repo.
#' @return Returns a list of \code{list(title,body, c(users), c(nicknames), c(notes))}.
#' @export
issuesData <- function(issueNumber = 1,
                       githubUsername = "xxxxxxxxxxxxxxxxxxxx",
                       githubToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                       githubUrl = "https://api.github.com/",
                       githubRepo = "mkirch/issueReporter" ){
  httr::set_config( httr::config( ssl_verifypeer = 0L ) )
  issueBody <- httr::content(httr::GET(paste0(githubUrl,"repos/",
                                              githubRepo,"/issues/",
                                              issueNumber),
                                       httr::authenticate(githubUsername,
                                                          githubToken,
                                                          type = "basic")))
  issueComments <- httr::content(httr::GET(paste0(githubUrl,"repos/",
                                                  githubRepo,"/issues/",
                                                  issueNumber,"/comments"),
                                           httr::authenticate(githubUsername,
                                                              githubToken,
                                                              type = "basic")))
  users <- c()
  nicks <- c()
  notes <- c()
  for (i in seq_along(issueComments)){
    usr <- httr::content(httr::GET(paste0(githubUrl,"users/",
                                          issueComments[[i]]$user$login),
                                   httr::authenticate(githubUsername,
                                                      githubToken,
                                                      type = "basic")))
    users[i] <- issueComments[[i]]$user$login
    nicks[i] <- usr$name
    notes[i] <- issueComments[[i]]$body
  }
  return(list(title=issueBody$title, body=issueBody$body, users=users, nicks=nicks, notes=notes))
}


#' @title Convert GitHub Issues data to Markdown.
#'
#' @description
#' After being passed GitHub Issues data for a given thread, extracts and
#' formats the material in Markdown.
#'
#' @param issuesData The list output from \code{issuesData()} containing
#' GitHub Issues data.
#' @param includeTitle Bool where TRUE includes the title, and FALSE excludes.
#' @param includeBody Bool where TRUE includes the original issue, and FALSE
#' includes only the issue comments.
#' @return Returns a character vector containing the markdown formatted text.
#' @export
issuesData2md <- function(issuesData = readRDS(system.file("extdata",
                                                           "dataExample.rds",
                                                           package = "issueReporter")),
                          includeTitle = TRUE,
                          includeBody = TRUE){
  md <- ""
  # Sometimes we may not need the initial issue text
  if(includeTitle){
    md <- paste0(md,"#",issuesData$title,"\n\n")
  }
  if(includeBody){
    md <- paste0(md,gsub("\n","\n\n",issuesData$body),"\n\n")
  }
  for (i in seq_along(issuesData$users)){
    md <- paste0(md,"# ",issuesData$nicks[i]," (",issuesData$users[i],") \n\n")
    # gsub for proper markdown line formatting
    md <- paste0(md,gsub("\n","\n\n",issuesData$notes[i]),"\n\n")
  }
  md
}

#' @title Generate a PDF report from a GitHub issue thread.
#'
#' @description
#' For a given GitHub issue, extracts all issue comments and generates a PDF
#' report of each user's contributions to the thread. View /inst/examples/
#' to see a quick sample and output besides the usage below.
#'
#' @param style Character string containing style. Tint is the only available
#' for now until we add more styles/themes.
#' @param RmdLocation Character string designating location of model Rmd.
#' @param outputFile String containing file name for R Markdown pdf output,
#' \code{report.Rmd} if NULL.
#' @param outputDir String containing directory address for R markdown output,
#' working directory if NULL.
#' @param md Character string containing markdown code to use in the report.
#' Should be generated by \code{issuesData2md()}.
#' @param setTitle String containing report title.
#' @param setAuthor String containing report author.
#' @export
issuesGenPDF <- function(style = "tint",
                         RmdLocation =  system.file("rmarkdown/templates/",
                                                    "tint.Rmd",
                                                    package = "issueReporter"),
                         outputFile = NULL,
                         outputDir = NULL,
                         md = "markdownHere",
                         setTitle = "Issue Notes",
                         setAuthor = "Julius Caesar"){
  if (style == "tint"){
    rmarkdown::render(RmdLocation,
                      output_file = outputFile,
                      output_dir = outputDir,
                      params=list(mdString = md,
                                  setTitle = setTitle,
                                  setAuthor = setAuthor))
  }
  # TODO: provide support for other styles
}

