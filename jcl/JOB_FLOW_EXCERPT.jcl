//********************************************************************
//* HISTORICAL JCL WORKFLOW EXCERPT (NOT A RUNNABLE JOB)             *
//* Source: 2018 academic assignment, sanitized identifiers          *
//*                                                                *
//* Original in-stream COBOL and Assembly source has been extracted *
//* into the separate cobol/ and assembler/ source files.           *
//* The large in-stream source bodies, utility allocations, and     *
//* some blank/comment lines have been omitted from this excerpt.   *
//********************************************************************
//STUJOB01 JOB ,'DRISCOE',MSGCLASS=H
//* Step 1: sort mutual-fund data
//JSTEP01  EXEC PGM=SORT,PARM='CMP=CLC'
//SORTIN   DD DSN=ACADEMY.CSCI465.DATAFA18(DATA7A),DISP=SHR
//SORTOUT  DD DSN=&&SORTED,SPACE=(TRK,(1,5)),DISP=(NEW,PASS)
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
  SORT FIELDS(1,2,ZD,A)
/*
//* Step 2: compile SALESRPT (in-stream source omitted here)
//JSTEP02  EXEC PGM=IGYCRCTL,REGION=0M,PARM='APOST'
//SYSLIB   DD DSN=ACADEMY.CSCI465.COPYLIB,DISP=SHR
//* SOURCE EXTRACTED TO cobol/SALESRPT.cbl
//SYSLIN   DD DSN=&&OBJMOD,
//            SPACE=(CYL,(1,1)),
//            DISP=(MOD,PASS,DELETE)
//SYSPRINT DD SYSOUT=*
//* Step 3: assemble CALCSHRS (in-stream source omitted here)
//JSTEP03  EXEC PGM=ASMA90,PARM=ASA,COND=(0,LT)
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//* SOURCE EXTRACTED TO assembler/CALCSHRS.asm
//SYSLIN   DD  DSN=&&ASMOBJ,
//             SPACE=(3040,(40,40),,,ROUND),
//             DISP=(MOD,PASS)
//SYSPRINT DD SYSOUT=*
//* Step 4: link reporting and assembler modules
//JSTEP04  EXEC PGM=HEWL,COND=(0,LT)
//SYSLIB   DD DSN=CEE.SCEELKED,DISP=SHR
//SYSLIN   DD DSN=&&OBJMOD,
//            DISP=(OLD,DELETE)
//         DD DSN=&&ASMOBJ,DISP=(OLD,DELETE)
//SYSLMOD  DD DSN=STUJOB.CSCI465.LOADLIB(SALESRPT),
//            SPACE=(1024,(50,20,1)),DSNTYPE=LIBRARY,
//            DISP=(MOD,KEEP,KEEP)
//SYSPRINT DD SYSOUT=*
//* Step 5: compile BUILDTBL (in-stream source omitted here)
//JSTEP05  EXEC PGM=IGYCRCTL,REGION=0M,PARM='APOST'
//SYSLIB   DD DSN=ACADEMY.CSCI465.COPYLIB,DISP=SHR
//* SOURCE EXTRACTED TO cobol/BUILDTBL.cbl
//SYSLIN   DD DSN=&&TBLOBJ,
//            SPACE=(CYL,(1,1)),
//            DISP=(MOD,PASS,DELETE)
//SYSPRINT DD SYSOUT=*
//* Step 6: link BUILDTBL
//JSTEP06  EXEC PGM=HEWL,COND=(0,LT)
//SYSLIB   DD DSN=CEE.SCEELKED,DISP=SHR
//SYSLIN   DD DSN=&&TBLOBJ,DISP=(OLD,DELETE)
//SYSLMOD  DD DSN=STUJOB.CSCI465.LOADLIB(BUILDTBL),
//            SPACE=(1024,(50,20,1)),DSNTYPE=LIBRARY,
//            DISP=(MOD,KEEP,KEEP)
//SYSPRINT DD SYSOUT=*
//* Step 7: execute the report
//JSTEP07  EXEC PGM=SALESRPT,COND=(0,LT)
//STEPLIB  DD DSN=STUJOB.CSCI465.LOADLIB,DISP=SHR
//FUNDFLE  DD DSN=&&SORTED,DISP=(MOD,DELETE,DELETE)
//PRCFLE   DD DSN=ACADEMY.CSCI465.DATAFA18(DATA7B),DISP=SHR
//SALESFLE DD DSN=ACADEMY.CSCI465.DATA7(SALES),DISP=SHR
//COBOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//