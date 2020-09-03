      SUBROUTINE H12 (MODE,LPIVOT,L1,M,U,IUE,UP,C,ICE,ICV,NCV)

C     C.L.LAWSON AND R.J.HANSON, JET PROPULSION LABORATORY, 1973 JUN 12
C     TO APPEAR IN 'SOLVING LEAST SQUARES PROBLEMS', PRENTICE-HALL, 1974

C     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
C     HOUSEHOLDER TRANSFORMATION  Q = I + U*(U**T)/B

C     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
C     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
C     L1,M   IF L1 <= M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
C            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.
C            IF L1 > M THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
C     U(),IUE,UP
C            ON ENTRY TO H1 U() STORES THE PIVOT VECTOR.
C            IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
C            ON EXIT FROM H1 U() AND UP STORE QUANTITIES DEFINING
C            THE VECTOR U OF THE HOUSEHOLDER TRANSFORMATION.
C            ON ENTRY TO H2 U() AND UP
C            SHOULD STORE QUANTITIES PREVIOUSLY COMPUTED BY H1.
C            THESE WILL NOT BE MODIFIED BY H2.
C     C()    ON ENTRY TO H1 OR H2 C() STORES A MATRIX WHICH WILL BE
C            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
C            TRANSFORMATION IS TO BE APPLIED.
C            ON EXIT C() STORES THE SET OF TRANSFORMED VECTORS.
C     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
C     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
C     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED.
C            IF NCV <= 0 NO OPERATIONS WILL BE DONE ON C().

      INTEGER          INCR, ICE, ICV, IUE, LPIVOT, L1, MODE, NCV
      INTEGER          I, I2, I3, I4, J, M
      DOUBLE PRECISION U,UP,C,CL,CLINV,B,SM,ONE,ZERO
      DIMENSION        U(IUE,*), C(*)
      DATA             ONE/1.0D+00/, ZERO/0.0D+00/

      IF (0.GE.LPIVOT.OR.LPIVOT.GE.L1.OR.L1.GT.M) GOTO 80
      CL=ABS(U(1,LPIVOT))
      IF (MODE.EQ.2)                              GOTO 30

C     ****** CONSTRUCT THE TRANSFORMATION ******

          DO 10 J=L1,M
             SM=ABS(U(1,J))
   10     CL=MAX(SM,CL)
      IF (CL.LE.ZERO)                             GOTO 80
      CLINV=ONE/CL
      SM=(U(1,LPIVOT)*CLINV)**2
          DO 20 J=L1,M
   20     SM=SM+(U(1,J)*CLINV)**2
      CL=CL*SQRT(SM)
      IF (U(1,LPIVOT).GT.ZERO) CL=-CL
      UP=U(1,LPIVOT)-CL
      U(1,LPIVOT)=CL
                                                  GOTO 40
C     ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C ******

   30 IF (CL.LE.ZERO)                             GOTO 80
   40 IF (NCV.LE.0)                               GOTO 80
      B=UP*U(1,LPIVOT)
      IF (B.GE.ZERO)                              GOTO 80
      B=ONE/B
      I2=1-ICV+ICE*(LPIVOT-1)
      INCR=ICE*(L1-LPIVOT)
          DO 70 J=1,NCV
          I2=I2+ICV
          I3=I2+INCR
          I4=I3
          SM=C(I2)*UP
              DO 50 I=L1,M
              SM=SM+C(I3)*U(1,I)
   50         I3=I3+ICE
          IF (SM.EQ.ZERO)                         GOTO 70
          SM=SM*B
          C(I2)=C(I2)+SM*UP
              DO 60 I=L1,M
              C(I4)=C(I4)+SM*U(1,I)
   60         I4=I4+ICE
   70     CONTINUE
   80 END
   