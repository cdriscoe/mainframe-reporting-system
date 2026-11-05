      ****************************************************************
      *                                                              *
      * PROGRAM NAME:  SALESRPT                                      *
      *                                                              *
      * FUNCTION:  THIS PROGRAM READS CALLS BUILDTBL TO BUILD A TABLE*
      *            OF MUTUAL FUNDS AND THEIR PRICES. THEN READS THE  *
      *            SALES-RECORD TO BUILD AN OUTPUT REPORT.           *
      *                                                              *
      * INPUT:     SALESFLE - CONTAINS INFORMATION ABOUT MUTUAL FUND *
      *                       SALES BROKERS AND THEIR SALES          *
      * OUTPUT:    PRINT-FILE -  132 BYTE PRINT LINE                 *
      *                                                              *
      ****************************************************************

       IDENTIFICATION DIVISION.

       PROGRAM-ID.    SALESRPT.
       AUTHOR.        CONOR DRISCOE.
       DATE-WRITTEN.  11/11/2018.
       DATE-COMPILED. 11/11/2018

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT SALES-FILE ASSIGN TO SALESFLE.
           SELECT PRINT-FILE ASSIGN TO COBOUT.

       DATA DIVISION.

       FILE SECTION.

       FD  SALES-FILE
           RECORDING MODE IS F.

           COPY SALESREC.

       FD  PRINT-FILE
           RECORDING MODE IS F.

       01  PRINT-RECORD                   PIC X(132).

       WORKING-STORAGE SECTION.

       01 DETAIL-LINE.
           05  OUT-BRANCH-NME          PIC X(25).
           05  FILLER                  PIC X(2) VALUE SPACES.
           05  OUT-BROKER-NME          PIC X(25).
           05  FILLER                  PIC X(4) VALUE SPACES.
           05  OUT-FUND-NBR            PIC 9(2).
           05  FILLER                  PIC X(4) VALUE SPACES.
           05  OUT-FUND-NME            PIC X(25).
           05  FILLER                  PIC X(3) VALUE SPACES.
           05  OUT-DEP-AMT             PIC $$$,$$$,$$9.99.
           05  FILLER                  PIC X(9) VALUE SPACES.
           05  OUT-PRC-FLG             PIC X.
           05  OUT-SHR-AMT             PIC Z,ZZZ,ZZZ,ZZ9.9999.

       01  TOTAL-OUT.
           05  FILLER                PIC X(44) VALUE SPACES.
           05  OUT-SALES-CTR         PIC ZZ9.
           05  FILLER                PIC X(11) VALUE SPACES.
           05  OUT-TOT-DEP-AMT       PIC $$,$$$,$$$,$$9.99.
           05  FILLER                PIC X(15) VALUE SPACES.
           05  OUT-AVG-DEP-AMT       PIC $$$,$$$,$$$.99.
           05  FILLER                PIC X(16) VALUE SPACES.

       01 VARIABLES-AND-FLAGS.
           05  EOF-FLAG                PIC X VALUE 'N'.
           05  SALES-CTR               PIC S9(3)
                                        PACKED-DECIMAL VALUE 0.
           05  PAGE-CTR                PIC S9(3)
                                        PACKED-DECIMAL VALUE 0.
           05  LINE-CTR                PIC S9(2)
                                        BINARY SYNC VALUE 20.
           05  SHR-AMT                 PIC S9(10)V9(3)
                                        PACKED-DECIMAL VALUE 0.
           05  TEMP-SHR-AMT            PIC S9(10)V9(3)
                                        PACKED-DECIMAL VALUE 0.
           05  TEMP-PRC                PIC S9(3)V99
                                        PACKED-DECIMAL VALUE 0.
           05  TEMP-DEP-AMT            PIC 9(8)V99
                                        PACKED-DECIMAL VALUE 0.
           05  AVG-DEP-AMT             PIC 9(8)V99
                                        PACKED-DECIMAL VALUE 0.
           05  TOT-DEP-AMT             PIC S9(10)V99
                                        PACKED-DECIMAL VALUE 0.
           05  BLANK-BRANCH-NME        PIC X(25) VALUE ' '.
           05  BLANK-BROKER-NME        PIC X(25) VALUE ' '.
           05  FUND-NOT-FOUND-NME      PIC X(25)
                              VALUE '**** FUND NOT FOUND *****'.
           05  FUND-NOT-FOUND-FLG      PIC X VALUE '-'.
           05  PROG-NME                PIC X(8)
                              VALUE 'BUILDTBL'.

       01 SUBS.
          05  SUB-1                    PIC S9(2) BINARY SYNC.

       01  FUND-TBL.
           05  TBL-FUND-CTR             PIC S9(2)
                                        BINARY SYNC VALUE 0.
           05  TBL-FUND-NTRY            OCCURS 1 TO 99
                                        DEPENDING ON TBL-FUND-CTR
                                        ASCENDING KEY TBL-FUND-NBR
                                        INDEXED BY TBL-FUND-NDX.
               COPY FUNDTBL.

       01  HEADER-1A.
           05  OUT-CURRENT-DATE.
               10  CURRENT-MONTH    PIC 9(2).
               10  FILLER           PIC X VALUE '/'.
               10  CURRENT-DAY      PIC 9(2).
               10  FILLER           PIC X VALUE '/'.
               10  CURRENT-YEAR     PIC 9(4).
           05  FILLER               PIC X(43) VALUE SPACES.
           05  DIS-FUND-NME         PIC X(23)
                                VALUE 'GETTYSBURG MUTUAL FUNDS'.
           05  FILLER               PIC X(47) VALUE SPACES.
           05  FILLER               PIC X(6)
                                              VALUE 'PAGE: '.
           05  OUT-PAGE-CTR                   PIC ZZ9.

       01  HEADER-2A.
           05 OUT-CURRENT-TIMEA.
               10  CURRENT-HOUR                PIC 9(2).
               10  FILLER                      PIC X VALUE ':'.
               10  CURRENT-MINUTE              PIC 9(2).
               10  FILLER                      PIC X VALUE ':'.
               10  CURRENT-SECOND              PIC 9(2).
           05 FILLER                           PIC X(39) VALUE SPACES.
           05 FILLER                           PIC X(35)
                       VALUE 'MUTUAL FUND END-OF-DAY SALES REPORT'.
          05 FILLER                            PIC X(50) VALUE SPACES.

       01  HEADER-2B.
           05 OUT-CURRENT-TIMEB.
               10  CURRENT-HOUR                PIC 9(2).
               10  FILLER                      PIC X VALUE ':'.
               10  CURRENT-MINUTE              PIC 9(2).
               10  FILLER                      PIC X VALUE ':'.
               10  CURRENT-SECOND              PIC 9(2).
           05 FILLER                           PIC X(39) VALUE SPACES.
           05 FILLER                           PIC X(35)
                       VALUE 'MUTUAL FUND END-OF-DAY SALES TOTALS'.
          05 FILLER                            PIC X(50) VALUE SPACES.

       01  HEADER-2C.
           05  FILLER                         PIC X(55) VALUE SPACES.
           05  FILLER                         PIC X(19)
                            VALUE 'SALES REPORT TOTALS'.
           05  FILLER                         PIC X(58) VALUE SPACES.

       01  HEADER-3A.
           05  FILLER                PIC X(54) VALUE SPACES.
           05  FILLER                PIC X(4) VALUE 'FUND'.
           05  FILLER                PIC X(39) VALUE SPACES.
           05  FILLER                PIC X(7) VALUE 'DEPOSIT'.
           05  FILLER                PIC X(5) VALUE SPACES.
           05  FILLER                PIC X(5) VALUE 'PRICE'.
           05  FILLER                PIC X(18) VALUE SPACES.

       01  HEADER-4A.
           05  FILLER                PIC X(11)
                                        VALUE 'BRANCH NAME'.
           05  FILLER                PIC X(16) VALUE SPACES.
           05  FILLER                PIC X(11)
                                        VALUE 'BROKER NAME'.
           05  FILLER                PIC X(17) VALUE SPACES.
           05  FILLER                PIC X(3) VALUE 'NBR'.
           05  FILLER                PIC X(4) VALUE SPACES.
           05  FILLER                PIC X(9) VALUE 'FUND NAME'.
           05  FILLER                PIC X(27) VALUE SPACES.
           05  FILLER                PIC X(6) VALUE 'AMOUNT'.
           05  FILLER                PIC X(6) VALUE SPACES.
           05  FILLER                PIC X(4) VALUE 'FLAG'.
           05  FILLER                PIC X(7) VALUE SPACES.
           05  FILLER                PIC X(11)
                                        VALUE 'SHARES SOLD'.

       01  HEADER-4B.
           05  FILLER                PIC X(36) VALUE SPACES.
           05  FILLER                PIC X(11)
                                        VALUE 'TOTAL SALES'.
           05  FILLER                PIC X(14) VALUE SPACES.
           05  FILLER                PIC X(14)
                                        VALUE 'TOTAL DEPOSITS'.
           05  FILLER                PIC X(14) VALUE SPACES.
           05  FILLER                PIC X(15)
                                        VALUE 'AVERAGE DEPOSIT'.
           05  FILLER                PIC X(28) VALUE SPACES.

       01  HEADER-5A.
           05 FILLER                 PIC X(25) VALUE ALL '-'.
           05 FILLER                 PIC X(2) VALUE SPACES.
           05 FILLER                 PIC X(25) VALUE ALL '-'.
           05 FILLER                 PIC X(2) VALUE SPACES.
           05 FILLER                 PIC X(4) VALUE ALL '-'.
           05 FILLER                 PIC X(4) VALUE SPACES.
           05 FILLER                 PIC X(25) VALUE ALL '-'.
           05 FILLER                 PIC X(5) VALUE SPACES.
           05 FILLER                 PIC X(12) VALUE ALL '-'.
           05 FILLER                 PIC X(5) VALUE SPACES.
           05 FILLER                 PIC X(5) VALUE ALL '-'.
           05 FILLER                 PIC X(3) VALUE SPACES.
           05 FILLER                 PIC X(15) VALUE ALL '-'.

       01  HEADER-5B.
           05  FILLER               PIC X(36) VALUE SPACES.
           05  FILLER               PIC X(11) VALUE ALL '-'.
           05  FILLER               PIC X(14) VALUE SPACES.
           05  FILLER               PIC X(14) VALUE ALL '-'.
           05  FILLER               PIC X(14) VALUE SPACES.
           05  FILLER               PIC X(15) VALUE ALL '-'.
           05  FILLER               PIC X(28) VALUE SPACES.

       01  CURRENT-DATE-FIELDS.
           05  CURRENT-DATE.
               10  CURRENT-YEAR      PIC 9(4).
               10  CURRENT-MONTH     PIC 9(2).
               10  CURRENT-DAY       PIC 9(2).
           05  CURRENT-TIME.
               10  CURRENT-HOUR      PIC  9(2).
               10  CURRENT-MINUTE    PIC  9(2).
               10  CURRENT-SECOND    PIC  9(2).
               10  CURRENT-MS        PIC  9(2).
           05  DIFF-FROM-GMT         PIC S9(4).

       PROCEDURE DIVISION.

       0000-MAIN.

           PERFORM 0100-GET-DATE-AND-TIME.

           CALL PROG-NME USING FUND-TBL.

           OPEN INPUT SALES-FILE
                OUTPUT PRINT-FILE.

           READ SALES-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

           PERFORM 0500-PROCESS-SALES-REC
             UNTIL EOF-FLAG = 'Y'.

           PERFORM 0800-PROCESS-FUND-TOTALS.

           CLOSE PRINT-FILE
                 SALES-FILE.

           GOBACK.

       0000-EXIT. EXIT.
      * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  THIS FUNCTION CALLS THE CURRENT DATE FUNCTION    *
      *  AND MOVES THE RESULTS TO THE APPROPRIATE HEADERS *
      *                                                   *
      * * * * * * * * * * * * * * * * * * * * * * * * * *
       0100-GET-DATE-AND-TIME.

           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-FIELDS.

           MOVE CORRESPONDING CURRENT-DATE TO OUT-CURRENT-DATE.

           MOVE CORRESPONDING CURRENT-TIME TO OUT-CURRENT-TIMEA.
           MOVE CORRESPONDING CURRENT-TIME TO OUT-CURRENT-TIMEB.

       0100-EXIT. EXIT.

      * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0200 INCREMENTS THE PAGE COUNTER, MOVES *
      *  IT TO OUTPUT AND PRINTS ALL THE APPROPRIATE      *
      *  REPORT HEADERS, WHILE RESETTING THE LINE COUNTER *
      * * * * * * * * * * * * * * * * * * * * * * * * * *
       0200-WRITE-HEADERS-1.

           ADD 1 TO PAGE-CTR.
           MOVE PAGE-CTR TO OUT-PAGE-CTR.
           WRITE PRINT-RECORD FROM HEADER-1A AFTER PAGE.
           WRITE PRINT-RECORD FROM HEADER-2A AFTER 1.
           WRITE PRINT-RECORD FROM HEADER-3A AFTER 2.
           WRITE PRINT-RECORD FROM HEADER-4A AFTER 1.
           WRITE PRINT-RECORD FROM HEADER-5A AFTER 1.
           MOVE 0 TO LINE-CTR.

       0200-EXIT. EXIT.

      * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0500 DOES THE SALES RECORD PROCESSING.  *
      *  IT MOVES THROUGH THE SALES RECORD AND FORMATS    *
      *  THE OUTPUT REPORT, DECIDING IF BROKER AND BRANCH *
      *  NAMES SHOULD BE PRINTED. IT ALSO USES A SEARCH   *
      *  TO SEE IF A MATCHING FUND IS FOUND IN OUR RECORDS*
      *  TO FIND THE NUMBER OF SHARES PURCHASED           *
      * * * * * * * * * * * * * * * * * * * * * * * * *

       0500-PROCESS-SALES-REC.

           ADD 1 TO SALES-CTR.

           PERFORM VARYING SALE-NDX FROM 1 BY 1
             UNTIL SALE-NDX > 4 OR SALE-FUND-NBR (SALE-NDX) = 0

             IF SALE-NDX = 1
               MOVE SALES-BRANCH-NME TO OUT-BRANCH-NME
               MOVE SALES-BROKER-NME TO OUT-BROKER-NME
             ELSE
               MOVE SPACES TO OUT-BRANCH-NME
               MOVE SPACES TO OUT-BROKER-NME
             END-IF

             SEARCH ALL TBL-FUND-NTRY
               AT END
                 PERFORM 0700-FUND-NOT-FOUND
               WHEN TBL-FUND-NBR (TBL-FUND-NDX) =
                          SALE-FUND-NBR (SALE-NDX)
                 PERFORM 0900-FUND-FOUND
             END-SEARCH

             IF LINE-CTR > 15
               PERFORM 0200-WRITE-HEADERS-1
             END-IF
             WRITE PRINT-RECORD FROM DETAIL-LINE AFTER 2
             ADD 1 TO LINE-CTR

           END-PERFORM.

           READ SALES-FILE
             AT END MOVE 'Y' TO EOF-FLAG
           END-READ.

       0500-EXIT. EXIT.
      * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0700 IS ACTIVATED WHEN A MATCHING FUND  *
      *  IS NOT FOUND IN THE TABLE. IN THIS CASE IT SIMPLY*
      *  MOVES THE AVAILIBLE INFO TO OUTPUT AND STATES    *
      *  THAT THE GIVEN FUND HASN'T BEEN FOUND.           *
      * * * * * * * * * * * * * * * * * * * * * * * * *

       0700-FUND-NOT-FOUND.

           MOVE SALE-FUND-NBR (SALE-NDX) TO OUT-FUND-NBR.
           MOVE FUND-NOT-FOUND-FLG TO OUT-PRC-FLG.
           MOVE FUND-NOT-FOUND-NME TO OUT-FUND-NME.
           MOVE 0 TO OUT-SHR-AMT.
           MOVE SALE-DEP-AMT (SALE-NDX) TO OUT-DEP-AMT.

           COMPUTE TOT-DEP-AMT ROUNDED
                        = TOT-DEP-AMT + SALE-DEP-AMT (SALE-NDX).

       0700-EXIT. EXIT.
      * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0800 RESETS THE PAGE COUNTER BEFORE     *
      *  PRINTING THE APPROPRIATE HEADERS FOR THE REPORT  *
      *  TOTALS PROCESSED IN THE OTHER FUNCTIONS.         *
      *  BEFORE OUTPUT IT CALCULATES THE AVG DEPOSIT      *
      * * * * * * * * * * * * * * * * * * * * * * * * *

       0800-PROCESS-FUND-TOTALS.

           MOVE 1 TO PAGE-CTR.
           MOVE PAGE-CTR TO OUT-PAGE-CTR.
           WRITE PRINT-RECORD FROM HEADER-1A AFTER PAGE.
           WRITE PRINT-RECORD FROM HEADER-2A AFTER 1.
           WRITE PRINT-RECORD FROM HEADER-2C AFTER 1.
           WRITE PRINT-RECORD FROM HEADER-4B AFTER 2.
           WRITE PRINT-RECORD FROM HEADER-5B AFTER 1.

           COMPUTE AVG-DEP-AMT ROUNDED =
                            TOT-DEP-AMT / SALES-CTR.
           MOVE SALES-CTR TO OUT-SALES-CTR.
           MOVE TOT-DEP-AMT TO OUT-TOT-DEP-AMT.
           MOVE AVG-DEP-AMT TO OUT-AVG-DEP-AMT.
           WRITE PRINT-RECORD FROM TOTAL-OUT.

       0800-EXIT. EXIT.

      * * * * * * * * * * * * * * * * * * * * * * * * *
      *  FUNCTION 0900 IS CALLED WHEN A MATCHING FUND IS  *
      *  FOUND IN FUNCTION 0500. IT MOVES THE SALES REC   *
      *  DATA TO OUTPUT BEFORE SEARCHING THE TABLE FOR    *
      *  APPROPRIATE PRICE FOR A GIVEN SALE TO            *
      *  CALCULATE THE AMOUNT OF SHARES SOLD.             *
      * * * * * * * * * * * * * * * * * * * * * * * * *

       0900-FUND-FOUND.

           MOVE SALE-FUND-NBR (SALE-NDX) TO OUT-FUND-NBR.
           MOVE SALE-PRC-FLG (SALE-NDX) TO OUT-PRC-FLG.
           MOVE SALE-DEP-AMT (SALE-NDX) TO OUT-DEP-AMT.

           SET TBL-PRC-NDX TO SALE-PRC-FLG (SALE-NDX).

           MOVE SALE-DEP-AMT (SALE-NDX) TO TEMP-DEP-AMT.
           MOVE TBL-FUND-PRC(TBL-FUND-NDX, TBL-PRC-NDX)
                                TO TEMP-PRC.
           MOVE 0 TO SHR-AMT.

           CALL 'CALCSHRS' USING TEMP-DEP-AMT
                                 TEMP-PRC
                                 SHR-AMT.

           MOVE SHR-AMT TO OUT-SHR-AMT.


           MOVE TBL-FUND-NME (TBL-FUND-NDX) TO OUT-FUND-NME.

           COMPUTE TOT-DEP-AMT ROUNDED
                        = TOT-DEP-AMT + SALE-DEP-AMT (SALE-NDX).

       0900-EXIT. EXIT.

