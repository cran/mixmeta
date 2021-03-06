###
### R routines for the R package mixmeta (c)
#
gradchol.reml <-
function(par,U,invtXWXtot,ind1,ind2,Xlist,invSigmalist,reslist,nalist,k) {
#
################################################################################
# FUNCTION TO COMPUTE THE MATRIX DERIVATIVES IN TERMS OF PARAMETERS OF
# THE CHOLESKY DECOMPOSITION (ONLY FOR SINGLE-LEVEL AND UNSTRUCTURED RANDOM)
#
  grad <- sapply(seq_along(par),function(i) {
    # COMPUTE THE DERIVATIVE OF Psi IN TERMS OF ITS CHOLESKY DECOMPOSITION U
    A <- B <- C <- diag(0,k)
    A[ind2[i],] <- B[,ind2[i]] <- U[ind1[i],]
    C[ind2[i],] <- C[,ind2[i]] <- 1
    D <- C*A+C*B
    # COMPUTE THE GRADIENT
    gr <- sum(mapply(function(X,invSigma,res,na) {
      E <- invSigma%*%D[!na,!na]%*%invSigma
      F <- crossprod(res,E)%*%res
      G <- sum(diag(invSigma%*%D[!na,!na]))
      H <- sum(diag(invtXWXtot%*%crossprod(X,E)%*%X))
      return(as.numeric(0.5*(F-G+H)))},Xlist,invSigmalist,reslist,nalist))
  })
#
  grad
}
