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
#' @param includeIssue Bool where TRUE includes the original issue, and FALSE
#' includes only the issue comments.
#' @export
issueReport <- function(issueNumber = 1, outputFile = NULL, outputDir = NULL,
                        githubUsername = "caesar",
                        githubToken = "abcdefghijklmnopqrstuvwxyz12345",
                        githubUrl = "https://api.github.com/",
                        githubRepo = "author/Repo", setTitle = "Issue Notes",
                        setAuthor = "Julius Caesar", includeIssue = TRUE){
    rmarkdown::render("R/report.Rmd",
                      output_file=outputFile,
                      output_dir = outputDir,
                      params=list(issue_number=issueNumber,
                                  github_username = githubUsername,
                                  github_token = githubToken,
                                  github_url = githubUrl,
                                  github_repo = githubRepo,
                                  set_title = setTitle,
                                  set_author = setAuthor,
                                  include_issue = includeIssue))
}
