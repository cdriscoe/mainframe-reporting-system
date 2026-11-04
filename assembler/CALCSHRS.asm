         PRINT NOGEN
*
CALCSHRS   CSECT
           STM   14,12,12(13)      STANDARD LINKAGE
           LR    12,15                    STANDARD ENTRY LINKAGE
           USING CALCSHRS,12
           LA    14,SAVEAREA
           ST    13,4(14)
           ST    14,8(13)
           LR    13,14
*
           LM    2,4,0(1)                       R2-> DEP-AMT (6)BYTES
           ZAP   PSHRAMT(11),0(6,2)            R3-> SHR-PRC  (3)BYTES
           SRP   PSHRAMT(11),4,0                R4-> SHR-AMT (8)BYTES
           DP    PSHRAMT(11),0(3,3)
           SRP   PSHRAMT(8),64,5
           SRP   PSHRAMT(8),1,0
           ZAP   0(8,4),PSHRAMT(8)
*
         L     13,4(,13)             R13 -> CALLER'S SAVE AREA
         L     14,12(,13)            RESTORE R14
         LM    14,12,12(13)
*
         BR    14
*
         LTORG
*
         ORG   CALCSHRS+((*-CALCSHRS+31)/32)*32
         DC    C'HERE IS THE STORAGE FOR: CALCSHRS'
*
SAVEAREA   DC    18F'-1'
*
PSHRAMT  DC    PL11'0'
*
CALCSHRS AMODE 31           SPECIFY AMODE OVERRIDE
CALCSHRS RMODE ANY          SPECIFY RMODE OVERRIDE
*
           END   CALCSHRS
