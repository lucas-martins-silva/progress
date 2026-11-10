/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9021 2.00.00.012 } /*** "010012" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9021 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9021.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - janeiro/2003  Karla Klemke - Criaá∆o do programa            **
**                                                                                         **
**   Finalidade: Api de efetivacao de Devoluá∆o de Picking WMS                             **                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9021.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9018h.i}    /*fk - definicao das procedures utilizadas para controle ean/dun */
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans     As Integer   No-undo.
Define Input        PARAMETER TABLE FOR ttintegracao.
Define Input-Output Parameter Table For tt-erro.

/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                    No-undo.
Define                   Variable vLogOK                        As Logical                    No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)":U No-undo.
Define                   Variable wgBOSC096                     As Widget-handle              No-undo.      
Define                   Variable vNumCont                      As Integer         Init 0     No-undo.
Define                   Variable v-cod-estabel                 As Character                  No-undo.
Define                   Variable v-cod-local                   As Character                  No-undo.
Define                   Variable vDesSeriais                   As Character                  No-undo.
DEFINE                   VARIABLE i-cont-erro                   AS INTEGER                    NO-UNDO.
DEFINE                   VARIABLE r-wm-docto-itens              AS ROWID                      NO-UNDO.
DEFINE                   VARIABLE c-cod-embalagem               AS CHARACTER FORMAT 'X(10)':U NO-UNDO.
Define                   Variable vQtdItem                      AS DECIMAL FORMAT ">>>,>>>,>>9.9999" No-undo. 
Define                   Variable vQtdPeso     AS DECIMAL FORMAT ">,>>>,>>9.9999" No-undo. 
Define                   Variable vQtdPesoEmb   AS DECIMAL FORMAT ">,>>>,>>9.9999" No-undo. 
Define                   Variable vQtdVolume AS DECIMAL FORMAT ">,>>>,>>9.9999" No-undo. 


/*****************************************************************************/

/************************************************************/

BLOCK:
DO TRANSACTION on error undo block,  leave block
               on quit undo block,   leave block
               on stop undo block,   leave block
               on endkey undo block, leave block:

    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9021":U
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = c-seg-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    Find First tt-prog-bc   No-error.
    Find First tt-erro      No-error.

    If  Available tt-erro Then Do:
        Create  tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_Transaá∆o_Devoluá∆o_Picking_(DC)" *}
        Assign  tt-erro.i-sequen    = 1
                tt-erro.cd-erro     = 1
                tt-erro.mensagem    = RETURN-VALUE.
        Run deleteObjects.
        UNDO BLOCK , RETURN 'NOK':u.

    End. /* If  Available tt-erro */

    ASSIGN vusuario = trim(_RetornaValChar('usuario':U)).
    ASSIGN vdetalhe =  _RetornaValChar('detalhe':U).

    ASSIGN vLogOk = NO.
    {bcp/bc9017.i1  vusuario}
    IF vLogOk = NO THEN DO:
        Create  tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "n∆o_cadastrado_no_Datasul-EMS_(DC)" *}
        ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
        Assign  tt-erro.i-sequen    = i-cont-erro
                tt-erro.cd-erro     = 2
                tt-erro.mensagem    = c-lbl-liter-usuario + ' ' +  _RetornaValChar('usuario') + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
        UNDO BLOCK , RETURN 'NOK':u.
    END.

    if NOT can-find(first bc-trans-filho WHERE
           bc-trans-filho.nr-trans = pNumTrans) THEN DO:
        Create tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "N∆o_existem_seriais_lidos_para_serem_devolvidos" *}
        Assign tt-erro.i-sequen = i-cont-erro
               tt-erro.cd-erro  = 3
               tt-erro.mensagem = RETURN-VALUE + '.' + '(DC)':U.
        UNDO BLOCK , RETURN 'NOK':u.
    END.

    FOR EACH tt-devolve-picking:
        DELETE tt-devolve-picking.
    END.

    FOR EACH bc-trans-filho
        where bc-trans-filho.nr-trans = pNumTrans NO-LOCK :

        CREATE tt-devolve-picking.
        Assign tt-devolve-picking.cod-estabel  = TRIM   (entry(2, ENTRY(1,vdetalhe,';'),':':U))
               tt-devolve-picking.cod-local    = TRIM   (ENTRY(2, ENTRY(2,vdetalhe,';'),':':U))
               tt-devolve-picking.id-docto     =  DECIMAL(entry(2,entry(1, bc-trans-filho.conteudo-trans,';':U),':':U))
               tt-devolve-picking.num-seq-item =  INTEGER(entry(2,entry(2,bc-trans-filho.conteudo-trans,';':U),':':U))
               tt-devolve-picking.num-serial   =  DECIMAL(entry(2,entry(3, bc-trans-filho.conteudo-trans,';':U),':':U))
               tt-devolve-picking.cod-item     =          entry(2,entry(4, bc-trans-filho.conteudo-trans,';':U),':':U)
               tt-devolve-picking.cod-refer    =          entry(2,entry(5, bc-trans-filho.conteudo-trans,';':U),':':U) 
               tt-devolve-picking.cod-lote     =          entry(2,entry(6, bc-trans-filho.conteudo-trans,';':U),':':U) 
               tt-devolve-picking.qtd-item     =  DECIMAL(entry(2,entry(7, bc-trans-filho.conteudo-trans,';':U),':':U)) .

        If tt-devolve-picking.num-serial = 777777 Then assign tt-devolve-picking.num-serial = 0.
    END.

    FOR EACH tt-devolve-picking NO-LOCK:
        IF tt-devolve-picking.num-serial = 999999 THEN
           NEXT. /* serial indic termino da coleta */

        /* fk: Seta historico na bc-etiqueta, caso exista */
        RUN piHabilitaHistoricoBcEtiqueta (pNumTrans, tt-devolve-picking.num-serial ). /*bcp/bc9018h.i*/
        /* fk fim */
    END.                                            
    Return 'OK':U.
End. /* Do: */
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
