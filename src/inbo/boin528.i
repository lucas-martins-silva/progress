def temp-table tt-rep-parada-ctrab NO-UNDO
    field cod-ctrab    like ctrab.cod-ctrab
    field des-ctrab    like ctrab.des-ctrab
    FIELD cod-operador AS CHAR
    FIELD cod-equipe   AS CHAR
    field l-existe     as logical
    field l-elimina    as logical
    field rw-rep       as rowid.
