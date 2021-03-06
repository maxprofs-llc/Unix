      SUBROUTINE ID(K2)
      INTEGER STMT, PSTMT
      LOGICAL ERR, SYSERR, ABORT, DOVAR
      COMMON /DETECT/ ERR, SYSERR, ABORT
      COMMON /INPUT/ NSTMT, PSTMT, STMT(1327)
      COMMON /FACTS/ NAME, NOST, ITYP, IASF
C
C     ROUTINE CHECKS IDENTIFIERS IN <LIST> FOR BEING ARRAY,ARRAY ELEMENT
C      OR VARIABLE.- RETURNS ERR=.TRUE. IF MUST CEASE PROCESSING
C     FIRST CHECK USAGE
C
      K = LOOKUP(K2,.FALSE.)
      IF (SYSERR) GO TO 50
C
C     CHECK USAGE
C
      I3 = IGATT1(K,8)
      IF (I3.NE.0) GO TO 10
      CALL SATT1(K, 8, 10)
      GO TO 20
   10 IF (I3.NE.10) CALL ERROR1(27H ILLEGAL IDENTIFIER IN LIST, 27)
C
C     SET TYPE
C
   20 I3 = IGATT1(K,1)
      IF (I3.NE.0) GO TO 30
      I3 = 1
      IF (STMT(PSTMT).LE.43 .AND. STMT(PSTMT).GE.38) I3 = 2
      CALL SATT1(K, 1, I3)
C
C     CHECK FOR READING INTO DO CONTROL VARIABLE OR LIMIT
C
   30 IF (ITYP.NE.23) GO TO 40
      IF (DOVAR(K)) CALL ERROR1(
     *    57H ILLEGAL TO CHANGE VALUE OF CONTROL VARIABLE OR DO LIMITS,
     *    57)
C
C     MARK VARIABLES AS SET IF VALUES READ IN
C
      CALL SATT1(K, 5, 1)
C
C     SEPARATE OUT ARRAY ELEMENTS AND CHECK SUBSCRIPTS
C
   40 IF (STMT(K2).NE.65) GO TO 50
      I3 = IGATT1(K,7)
      IF (I3.EQ.0) GO TO 60
      PSTMT = K2 + 1
      IF (PSTMT.GE.NSTMT) GO TO 80
      CALL SUBS(K2, I3)
      ERR = .FALSE.
   50 RETURN
   60 CALL ERROR1(40H ILLEGAL SUBSCRIPTING OF SCALAR VARIABLE, 40)
   70 ERR = .TRUE.
      GO TO 50
   80 CALL ERROR1(19H SUBSCRIPTING ERROR, 19)
      GO TO 70
      END
