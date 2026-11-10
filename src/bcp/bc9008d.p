/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008D 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9008d MBC}
&ENDIF


/***********************************************************************************
** Copyright DATASUL S.A. (2000)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
**********************************************************************************/
/**********************************************************************************
**     Programa...: bc9008d.p  
**
**     Finalidade.: Adapter do aviso de embarque do EMS2
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{include/i_dbvers.i}
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/

&IF  '{&mgcld_version}' >= '2.02'
&THEN
    {bcp/bcapi013.i}

    {ftp/ftapi400.i}   /* Definicao da temp-table de aviso de embarque faturamento     */
    /*********************************************************************************/
    Define Temp-Table tt-bc-integracao NO-UNDO Like bc-integracao.
    /*********************************************************************************/

    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9006d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value).
        Return 'NOK'.
    End.

    Find First bc-prog-trans no-lock 
         where bc-prog-trans.cod_prog_dtsul = 'bc9008' No-error.

    If  Not AvailAble bc-prog-trans Then Do:

        Create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Progama_bc9008_n∆o_esta_relacionado_com_nemhuma_transaá∆o" *}
        Assign tt-erro.cd-erro  = 0138
               tt-erro.mensagem = RETURN-VALUE. 
        return.
    End.

    Create  tt-bc-integracao.

    Assign  tt-bc-integracao.decimal-2         = _RetornaValDeci('num-aviso-embarque').
    ASSIGN  tt-bc-integracao.inteiro-indice-2  = _RetornaValInte('nr-resumo').
    ASSIGN  tt-bc-integracao.caracter-indice-1 = _RetornaValChar('cod-item').
    ASSIGN  tt-bc-integracao.caracter-indice-2 = _RetornaValChar('cod-refer').
    ASSIGN  tt-bc-integracao.caracter-indice-3 = _RetornaValChar('chave-unica').
    ASSIGN  tt-bc-integracao.data-indice-1     = _RetornaValData('data-transacao').
    ASSIGN  tt-bc-integracao.caracter-1        = _RetornaValChar('cod-unico').
    ASSIGN  tt-bc-integracao.caracter-2        = _RetornaValChar('cod-usuario').
    ASSIGN  tt-bc-integracao.caracter-3        = _RetornaValChar('cod-depos').
    ASSIGN  tt-bc-integracao.caracter-4        = _RetornaValChar('cod-local').
    ASSIGN  tt-bc-integracao.caracter-5        = _RetornaValChar('cod-lote').
    ASSIGN  tt-bc-integracao.data-1            = _RetornaValData('dat-valid-lote').            
    ASSIGN  tt-bc-integracao.decimal-1         = _RetornaValDeci('qtd-embarcada').


    If  tt-bc-integracao.decimal-2 = 0 Then Do:
        Create tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-numero-do-aviso-de-embarque-de AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Numero_do_aviso_de_embarque_deve_ser_informado" *}
        ASSIGN c-lbl-liter-numero-do-aviso-de-embarque-de = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-api-de-efetivacao-do-coleta-de AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "API_de_Efetivacao_do_Coleta_de_Dados_bcapi013" *}
        ASSIGN c-lbl-liter-api-de-efetivacao-do-coleta-de = TRIM(RETURN-VALUE).
        Assign tt-erro.cd-erro  = 0132
               tt-erro.mensagem = c-lbl-liter-numero-do-aviso-de-embarque-de + '! ' +
                                  c-lbl-liter-api-de-efetivacao-do-coleta-de + '.'.
        Return 'NOK'.
    End.

    If  tt-bc-integracao.inteiro-indice-2 = 0        Then Do:
        Create tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-numero-do-resumo-do-embarque-d AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Numero_do_resumo_do_embarque_deve_ser_informado" *}
        ASSIGN c-lbl-liter-numero-do-resumo-do-embarque-d = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-api-de-efetivacao-do-coleta-de-2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "API_de_Efetivacao_do_Coleta_de_Dados_bcapi013" *}
        ASSIGN c-lbl-liter-api-de-efetivacao-do-coleta-de-2 = TRIM(RETURN-VALUE).
        Assign tt-erro.cd-erro  = 0133
               tt-erro.mensagem = c-lbl-liter-numero-do-resumo-do-embarque-d + '! ' +
                                  c-lbl-liter-api-de-efetivacao-do-coleta-de-2 + '.'.
        Return 'NOK'.
    End.


    If  tt-bc-integracao.caracter-indice-1 = '' Then Do:
        Create tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-do-item-deve-ser-inform AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Codigo_do_Item_deve_ser_informado" *}
        ASSIGN c-lbl-liter-codigo-do-item-deve-ser-inform = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-api-de-efetivacao-do-coleta-de-3 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "API_de_Efetivacao_do_Coleta_de_Dados_bcapi013" *}
        ASSIGN c-lbl-liter-api-de-efetivacao-do-coleta-de-3 = TRIM(RETURN-VALUE).
        Assign tt-erro.cd-erro  = 0134
               tt-erro.mensagem = c-lbl-liter-codigo-do-item-deve-ser-inform + '! ' +
                                  c-lbl-liter-api-de-efetivacao-do-coleta-de-3 + '.'.
        Return 'NOK'.

    End.

    for each tt-integracao-400:
        delete tt-integracao-400.
    end.

    create tt-integracao-400.

    assign 
           tt-integracao-400.cdd-embarq            = tt-bc-integracao.decimal-2
           tt-integracao-400.nr-resumo-ini         = tt-bc-integracao.inteiro-indice-2
           tt-integracao-400.nr-resumo-fim         = tt-bc-integracao.inteiro-indice-2
           tt-integracao-400.ler-it-dep-fat        = no
           tt-integracao-400.cod-versao-integracao = 1.

    run ftp/ftapi400.p (input  table tt-integracao-400,
                        output table tt-it-pre-fat,
                        output table tt-it-dep-fat,
                        input-output table tt-erro).

    Find First tt-it-pre-fat no-lock 
         Where tt-it-pre-fat.it-codigo = tt-bc-integracao.caracter-indice-1 
         and   tt-it-pre-fat.cod-refer = tt-bc-integracao.caracter-indice-2
         no-error.

    If  Not Available tt-it-pre-fat Then Do:
        Create tt-erro.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-do-item-nao-e-para-o-em AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Codigo_do_Item_n∆o_Ç_para_o_embarque" *}
        ASSIGN c-lbl-liter-codigo-do-item-nao-e-para-o-em = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-api-de-efetivacao-do-coleta-de-4 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "API_de_Efetivacao_do_Coleta_de_Dados_bcapi013" *}
        ASSIGN c-lbl-liter-api-de-efetivacao-do-coleta-de-4 = TRIM(RETURN-VALUE).
        Assign tt-erro.cd-erro  = 0136
               tt-erro.mensagem = c-lbl-liter-codigo-do-item-nao-e-para-o-em + ' '    + 
                                   String(tt-bc-integracao.decimal-2) + '. ' +
                                  c-lbl-liter-api-de-efetivacao-do-coleta-de-4 + '.'.
        Return 'NOK'.
    End.

    /* FIM DA NA CHAVE-UNICA */

    if  tt-bc-integracao.caracter-indice-3 <> "" then do:

        Find FIRST bc-integracao
        Where bc-integracao.caracter-indice-3 = tt-bc-integracao.caracter-indice-3
        and   bc-integracao.cd-trans          = bc-prog-trans.cd-trans
        NO-LOCK No-Error.

        If  Available bc-integracao Then Do:
            Create tt-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-ja-embarcado-neste-embarq AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_j†_embarcado_neste_embarque" *}
            ASSIGN c-lbl-liter-item-ja-embarcado-neste-embarq = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-api-de-efetivacao-do-coleta-de-5 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "API_de_Efetivacao_do_Coleta_de_Dados_bcapi013" *}
            ASSIGN c-lbl-liter-api-de-efetivacao-do-coleta-de-5 = TRIM(RETURN-VALUE).
            Assign tt-erro.cd-erro  = 0137
                   tt-erro.mensagem = c-lbl-liter-item-ja-embarcado-neste-embarq    + 
                                       String(tt-bc-integracao.decimal-2) + '. ' +
                                      c-lbl-liter-api-de-efetivacao-do-coleta-de-5 + '.'.
            Return 'NOK'.
        End.

    end.

    Find FIRST  bc-integracao
         Where  bc-integracao.decimal-2         = tt-bc-integracao.decimal-2
         and    bc-integracao.inteiro-indice-2  = tt-bc-integracao.inteiro-indice-2
         And    bc-integracao.caracter-indice-1 = tt-bc-integracao.caracter-indice-1
         And    bc-integracao.caracter-indice-2 = tt-bc-integracao.caracter-indice-2 
         And    bc-integracao.caracter-indice-3 = tt-bc-integracao.caracter-indice-3
         and    bc-integracao.cd-trans          = bc-prog-trans.cd-trans
         EXCLUSIVE-LOCK NO-ERROR.

    If  Not Avail bc-integracao Then Do:

        create tt-integracao-13.

        assign tt-integracao-13.cod-versao-integracao = 1
               tt-integracao-13.opcao-inteiro-1       = 1
               tt-integracao-13.cd-trans              = bc-prog-trans.cd-trans.

        Run 'bcp/bcapi013.p'     (Input        table tt-integracao-13,
                                  Input-output table tt-bc-integracao,
                                  Input-Output Table tt-erro).

    End.
    else do:

        If  bc-integracao.logico-1 = yes 
        Then Do: /* Embarque fechado */
            Create tt-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-o-embarque AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "O_Embarque" *}
            ASSIGN c-lbl-liter-o-embarque = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ja-foi-encerrado-pelo-operador AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ja_foi_Encerrado_pelo_Operador_do_Sistema._bcapi013" *}
            ASSIGN c-lbl-liter-ja-foi-encerrado-pelo-operador = TRIM(RETURN-VALUE).
            Assign tt-erro.cd-erro  = 0130
                   tt-erro.mensagem = c-lbl-liter-o-embarque + ' ' + String(tt-bc-integracao.decimal-2) + ' ' +
                                      c-lbl-liter-ja-foi-encerrado-pelo-operador.
            Return 'NOK'.
        End.

        assign bc-integracao.decimal-1 = bc-integracao.decimal-1 + _RetornaValDeci('qtd-embarcada').

    end.
&ELSE
    RUN utp/ut-msgs.p ( input "MSG",
                        input 25505,
                        input "").

    Create  tt-erro.
    Assign  tt-erro.cd-erro  = 25505
            tt-erro.mensagem = TRIM(RETURN-VALUE).
    Return 'NOK'.
&ENDIF

