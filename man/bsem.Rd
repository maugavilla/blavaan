\name{bsem}
\alias{bsem}
\title{Fit Structural Equation Models}
\description{
Fit a Structural Equation Model (SEM).}
\usage{
bsem(..., cp = "srs",
     dp = NULL, n.chains = 3, burnin, sample,
     adapt, mcmcfile = FALSE, mcmcextra = list(), inits = "prior",
     convergence = "manual", target = "stan", save.lvs = FALSE,
     jags.ic = FALSE, seed = NULL, bcontrol = list())
}
\arguments{
\item{...}{Default lavaan arguments.  See \code{\link{lavaan}}.}
\item{cp}{Handling of prior distributions on covariance parameters: possible values are \code{"srs"} or
    \code{"fa"}.  Option \code{"srs"} is more flexible and better from a
    theoretical standpoint, but it is also slower.}
\item{dp}{Default prior distributions on different types of
    parameters, typically the result of a call to \code{dpriors()}.
    See the \code{dpriors()} help file for more information.}
\item{n.chains}{Number of desired MCMC chains.}
\item{burnin}{Number of burnin iterations, NOT including the adaptive
  iterations.}
\item{sample}{The total number of samples to take after burnin.}
\item{adapt}{The number of adaptive iterations to use at the start of
  the simulation.}
\item{mcmcfile}{If \code{TRUE}, the JAGS/Stan model will be written to file
  (in the lavExport directory). Can also supply a character
  string, which serves as the name of the directory to which files will be written.}
\item{mcmcextra}{A list with potential names \code{syntax} and
  \code{monitor}. The \code{syntax} object is a text string containing extra
  code to insert in the JAGS/Stan model syntax, and the \code{monitor} object
  is a character vector containing extra JAGS/Stan parameters to sample.}
\item{inits}{If it is a character string, the options are currently
    \code{"simple"}, \code{"Mplus"}, \code{"prior"} (default), and
    \code{"jags"}.  In the first two
    cases, parameter values are set as though they will be estimated via
    ML (see \code{\link{lavaan}}).  The starting parameter value for
    each chain is then perturbed from the original values through the
    addition of uniform noise.  If \code{"prior"} is used, the starting
    parameter values are obtained based on the prior distributions
    (while also trying to ensure that the starting values will not crash
    the model estimation).  If \code{"jags"}, no starting values are
    specified and JAGS will choose values on its own.
    If \code{start} is a fitted
    object of class \code{\linkS4class{lavaan}}, the estimated values of
    the corresponding parameters will be extracted, then perturbed in
    the manner described above. If it is a model list,
    for example the output of the \code{paramaterEstimates()} function,
    the values of the \code{est} or \code{start} or \code{ustart} column
    (whichever is found first) will be extracted.}
\item{convergence}{If \code{"auto"}, parameters will be
  sampled until convergence is achieved (via \code{autorun.jags}). In
  this case, the arguments \code{burnin} and \code{sample} are passed to
  \code{autorun.jags} as \code{startburnin} and \code{startsample},
  respectively. Otherwise, parameters
  are sampled as specified by the user (or by the \code{run.jags}
  defaults).}
\item{target}{Desired MCMC package, with \code{"stan"} (pre-compiled) as
  default. Other options include \code{"jags"} and \code{"stanclassic"},
  which provide greater functionality than \code{"stan"} but is much slower.}
\item{save.lvs}{Should sample latent variables (factor scores) be saved? Logical; defaults to FALSE}
\item{jags.ic}{Should DIC be computed the JAGS way, in addition to the BUGS way? Logical; defaults to FALSE}
\item{seed}{A vector of length \code{n.chains} (for target
  \code{"jags"}) or an integer (for target \code{"stan"}) containing random
  seeds for the MCMC run. If \code{NULL}, seeds will be chosen randomly.}
\item{bcontrol}{A list containing additional parameters passed to
    \code{run.jags} (or \code{autorun.jags}) or \code{stan}.  See the manpage of those functions for an
    overview of the additional parameters that can be set.}
}
\details{
    The \code{bsem} function is a wrapper for the more general
    \code{\link{blavaan}} function, using the following default
    \code{\link{lavaan}} arguments:
    \code{int.ov.free = TRUE}, \code{int.lv.free = FALSE},
    \code{auto.fix.first = TRUE} (unless \code{std.lv = TRUE}),
    \code{auto.fix.single = TRUE}, \code{auto.var = TRUE},
    \code{auto.cov.lv.x = TRUE},
    \code{auto.th = TRUE}, \code{auto.delta = TRUE},
    and \code{auto.cov.y = TRUE}.
  }
\value{
  An object of class \code{\linkS4class{lavaan}}, for which several methods
  are available, including a \code{summary} method.
}
\references{
Yves Rosseel (2012). lavaan: An R Package for Structural Equation
Modeling. Journal of Statistical Software, 48(2), 1-36. URL
http://www.jstatsoft.org/v48/i02/.

Edgar C. Merkle & Yves Rosseel (2018). blavaan: Bayesian Structural
Equation Models via Parameter Expansion. Journal of Statistical
Software, 85(4), 1-30. URL http://www.jstatsoft.org/v85/i04/.
}
\seealso{
\code{\link{blavaan}}
}
\examples{
\dontrun{
## The industrialization and Political Democracy Example
## Bollen (1989), page 332
model <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + a*y2 + b*y3 + c*y4
     dem65 =~ y5 + a*y6 + b*y7 + c*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'

## unique priors for mv intercepts; parallel chains
fit <- bsem(model, data=PoliticalDemocracy,
            dp=dpriors(nu="normal(5,10)"))
summary(fit)
}
}
