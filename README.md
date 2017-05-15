## issueReporter
Create reports from GitHub Issues threads in R.

### Background and Motivation

Sometimes you've got Issues. There is occasionally a need to create a quality document from these threads. I needed a professional-looking PDF to take notes on, originating from the content of a GitHub Issues thread, and I needed it to be produced on a regular basis. This satisfies that use case, and allows for the generation of general documents from Issues on both GitHub and GitHub Enterprise with a simple wrapper.

### Getting Started

You must first create a Personal Access Token in your GitHub or GitHub Enterprise account settings. Instructions to do so can be found [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

Documents are well styled thanks to Dirk Eddelbuettel's [tint](http://dirk.eddelbuettel.com/code/tint.html) package. Note that all of the requirements for tint must be fulfilled. Future themes/styles will come in the future, as well as support for HTML output.

## Example: Issue Thread
![issuethread](https://cloud.githubusercontent.com/assets/7461887/25644371/2c210778-2f6b-11e7-8953-2950ea71da22.JPG)

## Example: Report Generated from Issue Thread
![reportpdf](https://cloud.githubusercontent.com/assets/7461887/25644373/2e1ddb00-2f6b-11e7-95ac-4fc29a1fb58a.JPG)
