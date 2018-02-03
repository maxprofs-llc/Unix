      SUBROUTINE DOSTMT
      LOGICAL TOKLAB, ERR, SYSERR, ABORT
      INTEGER STMT, PSTMT
      COMMON /INPUT/ NSTMT, PSTMT, STMT(1327)
      COMMON /DETECT/ ERR, SYSERR, ABORT
C
C     ROUTINE PROCESSES A DO STMT. DOSTMT PEELS OFF THE
C     LABEL. CALLS DOSPEC TO GET THE <DO-SPECIFICATION>
C
      IF (TOKLAB(1,K2,KK,.FALSE.)) GO TO 10
      CALL ERROR1(23H MISSING LABEL AFTER DO, 23)
      GO TO 20
   10 IF (SYSERR) GO TO 20
      PSTMT = K2
      CALL DOSPEC(KK, K2, .FALSE.)
   20 RETURN
      END