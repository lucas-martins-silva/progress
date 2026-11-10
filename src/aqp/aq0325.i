/********************************************************************************
Include compartilhada entre criação e eliminação da nota
*******************************************************************************/
ASSIGN qtde-aux = 0.
            
FOR EACH item-doc-est
    FIELDS(serie-docto nro-docto cod-emitente nat-operacao quantidade)
    WHERE item-doc-est.serie-docto  = tt-docum-est.serie-docto
      AND item-doc-est.nro-docto    = tt-docum-est.nro-docto
      AND item-doc-est.cod-emitente = tt-docum-est.cod-emitente
      AND item-doc-est.nat-operacao = tt-docum-est.nat-operacao NO-LOCK:
            
    ASSIGN qtde-aux = qtde-aux + item-doc-est.quantidade.
            
END.
            
RUN emptyRowErrors IN h-boin090.
            
RUN setConstraintChave IN h-boin090 (INPUT tt-docum-est.serie-docto,
                                     INPUT tt-docum-est.nro-docto,
                                     INPUT tt-docum-est.cod-emitente,
                                     INPUT tt-docum-est.nat-operacao).

RUN openQueryStatic in h-boin090 (INPUT "Main":U) NO-ERROR.

RUN gotokey IN h-boin090 (INPUT tt-docum-est.serie-docto,
                          INPUT tt-docum-est.nro-docto,
                          INPUT tt-docum-est.cod-emitente,
                          INPUT tt-docum-est.nat-operacao).

RUN setDocumEst    IN h-boad00463 (INPUT tt-docum-est.r-rowid,
                                  OUTPUT r-rowidEsoc).
RUN deleteRecord   IN h-boin090.
RUN getRowErrors   IN h-boin090 (OUTPUT TABLE RowErrors).