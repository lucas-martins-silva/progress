/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9006D 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9006d MBC}
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
**     Programa...: bc9006d.p  
**
**     Finalidade.: Adapter da reporte de repetitivo do EMS 2.
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{bcp/bcapi004.i} /* Definicao da temp-table tt-prog-bc */
{cdp/cdcfgmat.i} /* Definiá∆o do preprocessador bf_mat_conta_estab */
{cpp/cpapi009.i} /* Definiá∆o das temp-tables da API de reporte repetitivo */
{cpp/cpapi009.i6}
/*********************************************************************************/
Define Variable vNroDocto                   As Character            No-undo.
Define Variable c-conteudo                  As Character            No-undo.

define variable h_api_cta_ctbl              as handle               no-undo.
define variable c-cod-cta-refugo-unif       as character            no-undo.
define variable c-cod-ccusto-refugo-unif    as character            no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro      as integer format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda     as character format "x(40)"  label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro      as character format "x(60)"  label "Mensagem Erro"  column-label "Inconsistància".

/*********************************************************************************/
/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
{include/i-epc200.i bc9006d} /** Upc **/
Do:
    if not valid-handle(h_api_cta_ctbl) then
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
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

    Find First param-global No-Lock No-error.
    If  Not Avail param-global Then Do:
        {utp/ut-table.i mguni param-global 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    End.

    Find First param-cp No-Lock No-error.
    If  Not Avail param-cp Then Do:
        {utp/ut-table.i mgind param-cp 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = trim(Return-Value).
        Return 'NOK'.
    End.

    assign c-conteudo = _RetornaValChar('it-codigo').

    Find First item
         Where item.it-codigo = c-conteudo
         No-Lock No-error.

    If  Not Available item Then Do:
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    End.

    For each tt-prog-bc:
        Delete tt-prog-bc.
    End.

    /*inicio alteraá‰es projeto - 107*/
    ASSIGN c-conteudo = _RetornaValChar('cod-estabel').
    find first estabelec where
        estabelec.cod-estabel = c-conteudo no-lock no-error.
    If  Not Available estabelec Then Do:
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    End.
    /*Fim alteraá‰es projeto - 107*/

    Create  tt-prog-bc.
    Assign  tt-prog-bc.cod-versao-integracao    = 1
            tt-prog-bc.nr-trans                 = pNumTrans
            tt-prog-bc.opcao                    = 2.

    If  Avail param-global
    And param-global.modulo-cl
    Then Do:
        run bcp/bcapi004.p (input-output table tt-prog-bc,
                            input-output table tt-erro).
    End.

    Find First tt-prog-bc No-Lock No-error. /* posicionar registro novamente */

    If  item.tipo-con-est = 2
    Then Do:
        Create  tt-serie.
        Assign  tt-serie.nr-serie   = _RetornaValChar('lote-serie')
                tt-serie.sequencia  = 1
                tt-serie.refugo     = (tt-prog-bc.motivo-backflush > 1).
    End.

    Find First tt-erro No-error.
    If  Available(tt-erro) Then
        Return 'NOK'.

   

/*    Assign  vNroDocto = _RetornaValChar('nro-docto').
 * 
 *     If  (   vNroDocto = "0"
 *          or vNroDocto = ""
 *          or vNroDocto = ?)
 *     Then Do:
 *  
 *         Find Last rep-prod No-lock No-error.
 * 
 *         If  Avail rep-prod
 *         Then    Assign  vNroDocto = String(rep-prod.nr-rep + 1).
 *         Else    Assign  vNroDocto = "1".
 * 
 *     End.*/

    Create  tt-rep-prod.

    Assign  tt-rep-prod.nr-reporte              = 0 /* A l¢gica abaixo foi comentada para que o movimento de 
                                                       estoque n∆o seja duplicado, o n£mero do reporte deve ser
                                                       sempre 0 */
                                                   /* ( If  _RetornaValInte('nr-reporte') = 0
                                                    Then Integer(vNroDocto)
                                                    Else _RetornaValInte('nr-reporte')) */.

    Assign  tt-rep-prod.data                    = _RetornaValData('data')
            tt-rep-prod.usuario                 = _RetornaValChar('cod-usuario')
            tt-rep-prod.hora                    = _RetornaValChar('hora')
            tt-rep-prod.it-codigo               = item.it-codigo.

    Assign  tt-rep-prod.ct-refugo               = _RetornaValChar('ct-refugo')
            tt-rep-prod.sc-refugo               = _RetornaValChar('sc-refugo')
            tt-rep-prod.nro-docto               = _RetornaValChar('nro-docto') /* vNroDocto */
            tt-rep-prod.serie-docto             = _RetornaValChar('serie-docto')
            tt-rep-prod.cod-depos               = _RetornaValChar('cod-depos')
            tt-rep-prod.lote-serie              = _RetornaValChar('lote-serie')
            tt-rep-prod.cod-refer               = _RetornaValChar('cod-refer')
            tt-rep-prod.dt-vali-lote            = _RetornaValData('dt-vali-lote')
            tt-rep-prod.cod-localiz             = _RetornaValChar('cod-localiz')
            tt-rep-prod.cod-estabel             = _RetornaValChar('cod-estabel')
            tt-rep-prod.cod-cta-unif            = _RetornaValChar('cod-cta-aplic')
            tt-rep-prod.cod-ccusto-unif         = _RetornaValChar('cod-ccusto-aplic')
            tt-rep-prod.cod-depos-sai           = _RetornaValChar('cod-depos-sai')
            tt-rep-prod.cod-local-sai           = _RetornaValChar('cod-local-sai')
            tt-rep-prod.cod-versao-integracao   = 003.
     assign  
            tt-rep-prod.loc-sai-unica           = _RetornaValLogi('loc-sai-unica')
            tt-rep-prod.char-1                  = _RetornaValChar('Cod-Livre-1')
            tt-rep-prod.char-2                  = _RetornaValChar('Cod-Livre-2')
            tt-rep-prod.dec-1                   = _RetornaValDeci('Dec-Livre-1')
            tt-rep-prod.dec-2                   = _RetornaValDeci('Dec-Livre-2')
            tt-rep-prod.int-1                   = _RetornaValInte('Num-Livre-1')
            tt-rep-prod.int-2                   = _RetornaValInte('Num-Livre-2')
            tt-rep-prod.log-1                   = _RetornaValLogi('Log-Livre-1')
            tt-rep-prod.log-2                   = _RetornaValLogi('Log-Livre-2')
            tt-rep-prod.data-1                  = _RetornaValData('Dat-Livre-1')
            tt-rep-prod.data-2                  = _RetornaValData('Dat-Livre-2')
            tt-rep-prod.l-emite-rel             = _RetornaValLogi('Log-Livre-3')
            tt-rep-prod.prog-seg                = _RetornaValChar('prog-seg')
            tt-rep-prod.time-out                = _RetornaValInte('time-out').
            
    assign         
            tt-rep-prod.tentativas              = _RetornaValInte('tentativas')
            tt-rep-prod.qt-reporte              = _RetornaValDeci('qt-reporte')
            tt-rep-prod.qt-refugo               = _RetornaValDeci('qt-refugo')
            tt-rep-prod.qt-estorno              = _RetornaValDeci('qt-estorno')
            tt-rep-prod.qt-apr-cond             = _RetornaValDeci('qt-apr-cond')
            tt-rep-prod.qt-est-aprov            = _RetornaValDeci('qt-est-aprov')
            tt-rep-prod.qt-est-refugo           = _RetornaValDeci('qt-est-refugo').

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".

    Case tt-prog-bc.motivo-backflush:
        when 1 Then
            Assign  tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').
        when 2 Then Do:
            
            ASSIGN c-cod-cta-refugo-unif =  If  _RetornaValChar('ct-refugo') = ''
                                            Then tt-prog-bc.cod-cta-refugo-unif
                                            Else _RetornaValChar('ct-refugo')
                   c-cod-ccusto-refugo-unif =   If  _RetornaValChar('sc-refugo') = ''
                                                Then tt-prog-bc.cod-ccusto-refugo-unif
                                                Else _RetornaValChar('sc-refugo').

            /*Valida Conta refugo*/
            run pi_valida_conta_contabil in h_api_cta_ctbl (input  estabelec.ep-codigo,     /* EMPRESA EMS2 */
                                                            input  tt-rep-prod.cod-estabel, /* ESTABELECIMENTO EMS2 */
                                                            input  "",                      /* UNIDADE NEG‡CIO */
                                                            input  "",                      /* PLANO CONTAS */ 
                                                            input  c-cod-cta-refugo-unif,   /* CONTA */
                                                            input  "",                      /* PLANO CCUSTO */ 
                                                            input  c-cod-ccusto-refugo-unif,/* CCUSTO */
                                                            input  today,                   /* DATA TRANSACAO */
                                                            output table tt_log_erro).      /* ERROS */
            if return-value = "NOK" then do:
                for first tt_log_erro:
                    create tt-erro.
                    assign tt-erro.mensagem = tt_log_erro.ttv_des_msg_erro
                           tt-erro.cd-erro  = tt_log_erro.ttv_num_cod_erro.
                end.
                if valid-handle(h_api_cta_ctbl) then do:
                    delete object h_api_cta_ctbl.
                    assign h_api_cta_ctbl = ?.
                end.
                Return 'NOK'.
            End.
            if valid-handle(h_api_cta_ctbl) then do:
                delete object h_api_cta_ctbl.
                assign h_api_cta_ctbl = ?.
            end.

            Assign  tt-rep-prod.qt-reporte      = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo       = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond     = _RetornaValDeci('qt-apr-cond')
                    tt-rep-prod.ct-refugo       = c-cod-cta-refugo-unif
                    tt-rep-prod.sc-refugo       = c-cod-ccusto-refugo-unif.

            Create  tt-ref-ordem.
            Assign  tt-ref-ordem.tipo-rejeicao = 1
                    tt-ref-ordem.codigo-rejei  = tt-prog-bc.codigo-rejei
                    tt-ref-ordem.qt-refugo     = _RetornaValDeci('qt-refugo')
                    tt-ref-ordem.observacao    = "".
        End.
        when 3 Then Do:
            Assign  tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').

            Create  tt-ref-ordem.
            Assign  tt-ref-ordem.tipo-rejeicao = 1
                    tt-ref-ordem.codigo-rejei  = tt-prog-bc.codigo-rejei
                    tt-ref-ordem.qt-refugo     = _RetornaValDeci('qt-refugo')
                    tt-ref-ordem.observacao    = "".
        End.
    End.
    if valid-handle(h_api_cta_ctbl) then do:
        delete object h_api_cta_ctbl.
        assign h_api_cta_ctbl = ?.
    end.
    run cpp/cpapi009.p (input-output table tt-rep-prod,
                        input table tt-serie,
                        input table tt-ref-ordem,
                        input-output table tt-erro,
                        output table tt-relatorio,
                        input yes).
    
    if return-value = "NOK":U then do:
        run utp/ut-msgs.p (input "msg",
                           input 27611,
                           input "").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 27611
                tt-erro.mensagem = Trim(Return-Value).
        Return "NOK":U.
    end.
    ELSE DO:
        for  each tt-epc
             where tt-epc.cod-event = "Apos-cdapi009-OK":
             delete tt-epc.
        end.
        FIND FIRST tt-rep-prod NO-LOCK NO-ERROR.
        create  tt-epc.
        assign  tt-epc.cod-event     = "Apos-cdapi009-OK"
                tt-epc.cod-parameter = "Nr-Reporte"
                tt-epc.val-parameter = STRING(tt-rep-prod.nr-reporte).

        {include/i-epc201.i "Apos-cdapi009-OK"}.
        
        for  each tt-epc
             where tt-epc.cod-event = "Apos-cdapi009-OK":
             delete tt-epc.
        end.

    END.

End. /* Do: Main */
/*********************************************************************************/
