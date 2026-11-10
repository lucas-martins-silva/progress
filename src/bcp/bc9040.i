def temp-table tt-trans-02 no-undo
    field cod-versao-integracao as INT                       LABEL "Vers∆o Integraá∆o"
    field i-sequen              as INT                       LABEL "Sequencia"
    field cd-trans              as char format "x(8)"        LABEL "Transaá∆o"
    field conteudo-trans        as RAW                
    field detalhe               as char format "x(60)"       LABEL "Detalhe"
    field nr-trans              as deci format "zzzzzzzzz9"  LABEL "Nr  Transaá∆o"
    field usuario               as char format "x(12)"       LABEL "Usu†rio"
    field atualizada            as LOGICAL                   LABEL "Atualizada?"
    field etiqueta              as logical                   LABEL "Gera Etiqueta?"  /*  No - Gera Transaá∆o de Movimento
                                               Yes - Gera Transaá∆o de Etiqueta*/
    index ch-seq is unique primary i-sequen.

