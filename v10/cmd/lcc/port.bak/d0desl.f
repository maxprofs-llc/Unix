      SUBROUTINE D0DESL(X,NX,GLBMAX,GLBMXO)
C
C  TO LOAD THE GLOBAL MAXIMUM.
C
      DOUBLE PRECISION X(NX)
      REAL GLBMAX(NX),GLBMXO(NX)
C
      DO 10 I=1,NX
         GLBMAX(I)=ABS(SNGL(X(I)))
 10      GLBMXO(I)=GLBMAX(I)
C
      RETURN
C
      END