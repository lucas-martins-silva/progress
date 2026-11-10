def temp-table tt-log-erros-atualiz no-undo
    field tta-cod-estab       as character format "x(3)"
    field tta-cod-refer       as character format "x(10)"
    field tta-num-seq-refer   as integer format ">>>9"
    field ttv-num-mensagem    as integer format ">>>>,>>9"
    field ttv-des-msg-erro    as character format "x(60)"
    field ttv-des-msg-ajuda   as character format "x(40)"
    field ttv-ind-tip-relacto as character format "X(15)"
    field ttv-num-relacto     as integer format ">>>>,>>9"
    .
