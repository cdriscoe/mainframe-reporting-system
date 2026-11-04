# Mainframe Mutual-Fund Sales Reporting

**University coursework (2018) · COBOL · IBM HLASM Assembly · JCL · Batch Processing**

This project is an academic IBM mainframe batch job for processing mutual-fund price and sales data and producing formatted financial summaries. The JCL coordinates input sorting, COBOL compilation, Assembly compilation, linking and program execution. One COBOL module calls an Assembly subroutine named `CALCSHRS` to perform a share calculation. A second COBOL module, `BUILDTBL`, constructs reference data used in reporting.

## Source files

- `cobol/SALESRPT.cbl` — reporting program that reads sales records and produces output
- `cobol/BUILDTBL.cbl` — supporting COBOL module used to construct the mutual-fund lookup table
- `assembler/CALCSHRS.asm` — IBM mainframe Assembly calculation routine
- `jcl/ASSIGN8_sanitized.jcl` — original integrated job-control listing, with identifiers and institutional data-set owner names replaced for privacy

## Important limitations

This is **historical university mainframe code**, preserved for code review rather than a standalone executable. The original JCL expects institutional mainframe facilities, compiler/linker programs, input datasets and COBOL `COPY` members (including `SALESREC` and `FUNDTBL`) that are not provided here. Some assembler include references likewise depend on the original environment. It has **not been compiled or executed in the current environment**.

The extracted COBOL and Assembly files are copied from the archived in-stream compiler input, not rewritten modern implementations. The JCL has anonymized job/dataset identifiers; it cannot be submitted unchanged as a working job in a new environment.

## What it demonstrates

- COBOL program structure, file I/O and formatted reporting
- IBM mainframe Assembly instructions and calling conventions
- Invoking an Assembly subroutine from COBOL
- JCL job steps and batch-processing workflows
- Structured business and financial data processing

## Portfolio context

This project was completed as part of Northern Illinois University coursework and is included to demonstrate historical academic familiarity with mainframe programming. It does not represent professional production mainframe experience.