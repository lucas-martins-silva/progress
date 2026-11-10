
/* impapi006.i - define temp-table utilizada pela api imapi006.p */
DEF TEMP-TABLE tt-desp-ja-recalc NO-UNDO
    FIELD cod-desp AS INT FORMAT ">>,>>9".

def temp-table tt-desp-vinc no-undo
    field cod-desp       like desp-imp.cod-desp
    field cod-desp-form  like desp-imp.cod-desp
    index i-desp is primary unique 
          cod-desp cod-desp-form.
