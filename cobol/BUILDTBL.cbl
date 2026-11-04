
       IDENTIFICATION DIVISION.

       PROGRAM-ID.    BUILDTBL.
       AUTHOR.        CONOR DRISCOE.
       DATE-WRITTEN.  12/11/2018.
       DATE-COMPILED. 12/11/2018

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT FUND-FILE ASSIGN TO FUNDFLE.
           SELECT SHARE-PRC-FILE ASSIGN TO PRCFLE.

       DATA DIVISION.

       FILE SECTION.

       FD  FUND-FILE
           RECORDING MODE IS F.

           COPY FUNDREC.
               05  FILLER             PIC X(53).

       FD  SHARE-PRC-FILE
           RECORDING MODE IS F.

           COPY PRCREC.

       WORKING-STORAGE SECTION.

       01 VARIABLES.
          05  SUB-1                    PIC S9(2) BINARY SYNC.
          05  EOF-FLAG                PIC X VALUE 'N'.

       LINKAGE SECTION.

       01  FUND-TBL.
           05  TBL-FUND-CTR             PIC S9(2)
                                        BINARY SYNC.
          05  TBL-FUND-NTRY            OCCURS 1 TO 99
                                        DEPENDING ON TBL-FUND-CTR
                                        ASCENDING KEY TBL-FUND-NBR
                                        INDEXED BY TBL-FUND-NDX.
               COPY FUNDTBL.

       PROCEDURE DIVISION USING FUND-TBL.

       0000-MAIN.

           OPEN INPUT  FUND-FILE.

           READ FUND-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

           READ FUND-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

           PERFORM 0300-BUILD-TBL-FUNDS
              VARYING TBL-FUND-NDX FROM 1 BY 1
              UNTIL EOF-FLAG = 'Y'
              OR TBL-FUND-NDX > 99.

           CLOSE FUND-FILE.

           MOVE 'N' TO EOF-FLAG.

           OPEN INPUT  SHARE-PRC-FILE.

           READ SHARE-PRC-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

           PERFORM 0400-BUILD-TBL-PRICES
             VARYING TBL-FUND-NDX FROM 1 BY 1
             UNTIL TBL-FUND-NDX > TBL-FUND-CTR
                OR EOF-FLAG = 'Y'.

           CLOSE SHARE-PRC-FILE.

           MOVE 'N' TO EOF-FLAG.

           MOVE '0' TO RETURN-CODE.

           GOBACK.

       0000-EXIT. EXIT.
      * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0300 USES A PERFORM VARYING WHEN CALLED *
      *  TO BUILD THE FIRST DIMMENSION OF THE COBOL TABLE *
      *  FROM THE SORTED DATA SET FUND-FILE UP TO 99 TIMES*
      * * * * * * * * * * * * * * * * * * * * * * * * * *
       0300-BUILD-TBL-FUNDS.

           ADD 1 TO TBL-FUND-CTR.
           MOVE IN-FUND-NBR TO TBL-FUND-NBR (TBL-FUND-NDX).
           MOVE IN-FUND-NME TO TBL-FUND-NME (TBL-FUND-NDX).

           READ FUND-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

       0300-EXIT. EXIT.
      * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0400 USES ANOTHER PERFORM VARYING TO    *
      *  BUILD THE SECOND DIMMENSION OF THE COBOL TABLE,  *
      *  THIS TIME RETREIVING THE THREE PRICES PER FUND   *
      * * * * * * * * * * * * * * * * * * * * * * * * * *
       0400-BUILD-TBL-PRICES.

           PERFORM VARYING TBL-PRC-NDX FROM 1 BY 1
               UNTIL TBL-PRC-NDX > 3
               SET SUB-1 TO TBL-PRC-NDX
               MOVE IN-FUND-PRC (SUB-1) TO
                   TBL-FUND-PRC (TBL-FUND-NDX, TBL-PRC-NDX)
           END-PERFORM.

           READ SHARE-PRC-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

       0400-EXIT. EXIT.
