# merge {{{
# merge results from FLSAM into FLStock
if (!isGeneric("merge")) {
    setGeneric("merge", useAsDefault = merge)
}
setMethod("merge", signature(x="FLStock", y="FLSAM"),
  function(x, y, ...)
  {
    quant <- quant(stock.n(x))
    dnx <- dimnames(stock.n(x))
    dny <- dimnames(y@stock.n)

    # check dimensions match
    if(!all.equal(dnx[c(-2,-6)], dny[c(-2,-6)]))
      stop("Mismatch in dimensions: only year can differ between stock and assess")

    # same plusgroup
    if(x@range['plusgroup'] != x@range['plusgroup'])
      stop("Mismatch in plusgroup: x and y differ")

    # year ranges match?
    if(!all(dny[['year']] %in% dnx[['year']]))
    {
      years <- as.numeric(unique(c(dnx$year, dny$year)))
      x <- window(x, start=min(years), end=max(years))
      y <- window(y, start=min(years), end=max(years))
    }
    x@desc <- paste(x@desc, "+ FLSAM:", y@name)
    x@stock.n <- y@stock.n
    x@harvest <- y@harvest
    x@range=c(unlist(dims(x)[c('min', 'max', 'plusgroup','minyear', 'maxyear')]),
      x@range[c('minfbar', 'maxfbar')])
        
    return(x)
  }
)   # }}}

# "+"      {{{
setMethod("+", signature(e1="FLStock", e2="FLSAM"),
  function(e1, e2) {
    if(validObject(e1) & validObject(e2))
      return(merge(e1, e2))
    else
      stop("Input objects are not valid: validObject == FALSE")
    }
)
setMethod("+", signature(e1="FLSAM", e2="FLStock"),
	function(e1, e2) {
    if(validObject(e1) & validObject(e2))
      return(merge(e2, e1))
    else
      stop("Input objects are not valid: validObject == FALSE")
    }
)   # }}}



#General helper function to extract a given parameter from an FLSAM object
#and return it as a FLQuantPoint
.params2flqp <- function(object,param) {
   dat <- subset(object@params,name==param)
   flq <- FLQuant(dat$value,dimnames=list(age="all",
              year=object@range["minyear"]:object@range["maxyear"]))
   flqp <- FLQuantPoint(flq)
   uppq(flqp) <- dat$value + 0.674*dat$std.dev
   lowq(flqp) <- dat$value - 0.674*dat$std.dev
   return(flqp)
}


#ssb          {{{
setMethod("ssb", signature(object="FLSAM"),
        function(object, ...) {
          flqp <- .params2flqp(object,"logssb")
          flqp <- exp(flqp)
          return(flqp) 
        }
)       # }}}

setMethod("fbar", signature(object="FLSAM"),
        function(object, ...) {
          flqp <- .params2flqp(object,"logfbar")
          flqp <- exp(flqp)
          return(flqp) 
        }
)       # }}}

setMethod("tsb", signature(object="FLSAM"),
        function(object, ...) {
          flqp <- .params2flqp(object,"logtsb")
          flqp <- exp(flqp)
          return(flqp)
        }
)       # }}}

setMethod("rec", signature(object="FLSAM"),
        function(object, ...) {
          flqp <- object@stock.n[1,] 
	  return(flqp)
        }
)       # }}}


