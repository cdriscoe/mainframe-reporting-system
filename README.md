# Mainframe Mutual-Fund Sales Reporting

**University coursework (2018) · COBOL · IBM HLASM Assembly · JCL · Batch Processing**

This project is an academic IBM mainframe batch job for processing mutual-fund price and sales data and producing formatted financial summaries. The JCL coordinates input sorting, COBOL compilation, Assembly compilation, linking and program execution. One COBOL module calls an Assembly subroutine named `CALCSHRS` to perform a share calculation. A second COBOL module, `BUILDTBL`, constructs reference data used in reporting.

## Source files

- `cobol/SALESRPT.cbl` — reporting program that reads sales records and produces output
- `cobol/BUILDTBL.cbl` — supporting COBOL module used to construct the mutual-fund lookup table
- `assembler/CALCSHRS.asm` — IBM mainframe Assembly calculation routine
- `jcl/JOB_FLOW_EXCERPT.jcl` — documented excerpt of the original seven-step job-control workflow, with in-stream code omitted and institutional dataset names sanitized

## Important limitations

This is **historical university mainframe code**, preserved for code review rather than a standalone executable. The original JCL expects institutional mainframe facilities, compiler/linker programs, input datasets and COBOL `COPY` members (including `SALESREC` and `FUNDTBL`) that are not provided here. Some assembler include references likewise depend on the original environment. It has **not been compiled or executed in the current environment**.

The extracted COBOL and Assembly files preserve the archived coursework implementation. The JCL file is **an excerpt**, not a complete executable job: it summarizes the original steps while omitting the large in-stream source blocks and utility allocations. It uses anonymized job/dataset identifiers and cannot be submitted unchanged as a working job.

## What it demonstrates

- COBOL program structure, file I/O and formatted reporting
- IBM mainframe Assembly instructions and calling conventions
- Invoking an Assembly subroutine from COBOL
- JCL job steps and batch-processing workflows
- Structured business and financial data processing

## Portfolio context

This project was completed as part of Northern Illinois University coursework and is included to demonstrate historical academic familiarity with mainframe programming. It does not represent professional production mainframe experience.