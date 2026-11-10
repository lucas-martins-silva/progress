/********************************************************************************************
**   Programa..: bc9033h.i                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - abril/2004    - Frank R Rodrigues - Cria‡Æo do programa     **
**                                                                                         **
**   Objetivo..: Include contendo os metodos utilizados no bcp/bc9033h.p                   **
**               Esses metodos foram criados para o projeto parati, e podem                **
**                ser utilizados em outros arquivos.                                       **
********************************************************************************************/


PROCEDURE pi-getTipoEndereco :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o tipo de endereco do wm-box, se eh por normal ou por picking
                1=normal, 4=picking
  Parameters:  O parametro de retorno aceita os valores NORMAL e PICKING
                Se n’o for nenhum dos dois, retorna ""
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cCodEstabel   LIKE wm-box.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER p-cCodLocal     LIKE wm-box.cod-local   NO-UNDO.
DEFINE INPUT  PARAMETER p-deIdBox       LIKE wm-box.id-box      NO-UNDO.
DEFINE OUTPUT PARAMETER p-cTipoEndereco AS CHARACTER NO-UNDO. /*Retorna NORMAL ou PICKING*/

    /*  */
    ASSIGN p-cTipoEndereco = "".

    /* Procura pelo endereco */
    FIND FIRST wm-box NO-LOCK
         WHERE wm-box.cod-estabel   = p-cCodEstabel
           AND wm-box.cod-local     = p-cCodLocal
           AND wm-box.id-box        = p-deIdBox 
        NO-ERROR.

    /* Procura pelo tipo de endereco */
    IF AVAIL wm-box THEN DO:
        /*  */
        FIND FIRST wm-tipo-box NO-LOCK
             WHERE wm-tipo-box.cdn-tipo-box = wm-box.cdn-tipo-box 
            NO-ERROR.

        IF AVAIL wm-tipo-box THEN DO:
            /*  */
            CASE wm-tipo-box.ind-status-box:
                WHEN 1 THEN ASSIGN p-cTipoEndereco = "NORMAL".
                WHEN 4 THEN ASSIGN p-cTipoEndereco = "PICKING".
                OTHERWISE ASSIGN p-cTipoEndereco = "".
            END CASE.
        END.
    END.
END PROCEDURE.


PROCEDURE pi-getValorParametro :
/*------------------------------------------------------------------------------
  Purpose:     Busca o parametro cadastrado na bc-param-ext
  Parameters:  Retorna o valor do parametro
                1 - Pede em tela
                2 - Por quantidade
                3 - Por EAN/DUN
  Notes:       Faz tres buscas at² achar o parametro.
                - Busca o parametro para item
                - Busca o parametro para a familia
                - Busca o parametro para a transacao
                - Se n’o achou, retorna 0
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-cItCodigo    AS CHARACTER  NO-UNDO. /*codigo do item*/
DEFINE INPUT  PARAMETER p-cTransacao   AS CHARACTER  NO-UNDO. /*transacao*/
DEFINE INPUT  PARAMETER p-cCodParamExt AS CHARACTER  NO-UNDO. /*codigo do parametro*/
DEFINE OUTPUT PARAMETER p-iParametro   AS INTEGER    NO-UNDO. /*1-pede, 2-qtd, 3-ean-dun*/

    /* Procura se existe o item cadastrado para esse parametro */
    FIND FIRST bc-param-ext NO-LOCK
         WHERE bc-param-ext.cod-entidade-param-ext   = "bc-ext-item" 
           AND bc-param-ext.cod-chave-param-ext      = p-cItCodigo
           AND bc-param-ext.cod-param-ext            = p-cCodParamExt
        NO-ERROR.

    /* Se n’o achar, busca pela familia */
    IF NOT AVAIL bc-param-ext THEN DO:

        /* Procura o cadastro de item para poder pegar a familia */
        FIND FIRST wm-item NO-LOCK
             WHERE wm-item.cod-item = p-cItCodigo NO-ERROR.

        /* Procura os parametros para a familia */
        FIND FIRST bc-param-ext NO-LOCK
             WHERE bc-param-ext.cod-entidade-param-ext   = "bc-ext-familia" 
               AND bc-param-ext.cod-chave-param-ext      = wm-item.cod-familia
               AND bc-param-ext.cod-param-ext            = p-cCodParamExt
            NO-ERROR.

        /* Se n’o achou, busca pela transacao */
        IF NOT AVAIL bc-param-ext THEN DO:
            FIND FIRST bc-param-ext NO-LOCK
                 WHERE bc-param-ext.cod-entidade-param-ext   = "bc-tipo-trans" 
                   AND bc-param-ext.cod-chave-param-ext      = p-cTransacao
                   AND bc-param-ext.cod-param-ext            = p-cCodParamExt
                NO-ERROR.

            /* Se n’o encontrou, adiciona o valor default */
            IF NOT AVAIL bc-param-ext THEN DO:
                ASSIGN p-iParametro = 0.
            END.
        END.
    END.

    /*  */
    IF AVAIL bc-param-ext THEN DO:
        ASSIGN p-iParametro = bc-param-ext.param-inteiro.
    END.
END PROCEDURE.


PROCEDURE piHabilitaHistoricoBcEtiqueta:
/*------------------------------------------------------------------------------
  Purpose:     Informa um historico da transacao wms na bc-etiqueta
  Parameters:  Informa a transacao e a etiqueta
  Notes:       Serve apenas para historico. Nao tem influencia em nenhuma rotina
                O BC-PARAM-EXT tem q estar setado com o parametro GERA_HISTORICO
                para a transacao corrente
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNumTrans   LIKE bc-trans.nr-trans NO-UNDO.
    DEFINE INPUT PARAMETER pIdEtiqueta LIKE wm-etiqueta.id-etiqueta NO-UNDO.

    DEFINE VARIABLE cSearch AS CHARACTER  NO-UNDO.
    ASSIGN cSearch = SEARCH("bcp/bcapi9000.p").

    IF cSearch <> ? THEN
        /* API para criacao do historico da etiqueta */
        RUN bcp/bcapi9000.p (INPUT pNumTrans,
                             INPUT pIdEtiqueta,
                             INPUT "").


END PROCEDURE.



