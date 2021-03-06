\name{lr.test}
\alias{lr.test}
\title{
Perform a log-ratio test for all models specified
}
\description{
Compare model fit performance among the models specified based on log-likelihood ratio's.
Different in log-likelihood is calculated and degrees of freedom are given. P values
are specified assuming a chi-quared distribution.
}
\usage{
lr.test(object,...,type="sequential")
}
\arguments{
  \item{object}{An \code{\link{FLSAM}} or \code{\link{FLSAMs}} object}
  \item{\dots}{
    In combination with an \code{\link{FLSAM}} object: additional objects of the same type (need at least 1)
  }
  \item{type}{
    The type of comparison to make. A "sequential" comparison compares object 1 against object 2, object 2 against object 3,... whilt a "first" comparison compares object 1 against object 2, object 1 against object 3,...
  }
}
\value{
A summary table of the test characteristics is returned}

\section{Warning!}{Log-likelihood tests can only be used for nested models (i.e. model parameterisation is different) and are not appropriate for different input data or different model types.
}
\author{
Code by Anders Nielsen, implemented by Niels T. Hintzen and Mark R. Payne
}
\seealso{
\code{\link{looi}}
}
\examples{
#- Load the data
data(HERAS.sams)

#- Run lr ratio test on example FLSAMs object
lr.test(HERAS.sams)

#- Run lr ratio test on individual FLSAM objects
lr.test(HERAS.sams[[1]],HERAS.sams[[2]],HERAS.sams[[3]])
}
