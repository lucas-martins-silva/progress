/*------------------------------------------------------------------------------
  Purpose:     procedure atualizaUnidNegoc
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-cod-depos AS CHAR NO-UNDO.
    DEF PARAM BUFFER b-movto-estoq FOR movto-estoq.

    DEF BUFFER b2-movto-estoq FOR movto-estoq.

    /*** Se o dep¢sito da tt-item-un-negoc foi passado em branco, e existe um registro na tabela unid-negoc-depos para o movto-estoq,
         n∆o atualiza a unidade de negocio do movto, passa para o proximo registro. ***/
    IF  p-cod-depos = "" THEN
        IF  CAN-FIND(FIRST unid-negoc-depos
                     WHERE unid-negoc-depos.it-codigo = b-movto-estoq.it-codigo
                       AND unid-negoc-depos.cod-estab = b-movto-estoq.cod-estabel
                       AND unid-negoc-depos.cod-depos = b-movto-estoq.cod-depos) THEN
            RETURN "OK":U.

    /*** Localiza a unidade de neg¢cio para o movto-estoq ***/
    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT b-movto-estoq.cod-estabel,
                                             INPUT b-movto-estoq.it-codigo,
                                             INPUT b-movto-estoq.cod-depos,
                                             OUTPUT c-unid-negoc).

    /*** Se a unidade de negocio do saldo for igual Ö encontrada, desconsidera o registro ***/
    IF  b-movto-estoq.cod-unid-negoc-sdo = c-unid-negoc THEN
        RETURN "OK":U.

    /*** Atualiza a unidade de negocio de saldo do movto de estoque ***/
    DO TRANS:

        IF  NOT AVAIL b2-movto-estoq
        OR  ROWID(b2-movto-estoq) <> ROWID(b-movto-estoq)  THEN
            FIND b2-movto-estoq
                WHERE ROWID(b2-movto-estoq) = ROWID(b-movto-estoq) EXCLUSIVE-LOCK NO-ERROR.

        ASSIGN b2-movto-estoq.cod-unid-negoc-sdo = c-unid-negoc.

        RELEASE b2-movto-estoq.
    END.

    RETURN "OK":U.

/*** Fim da Include ***/
