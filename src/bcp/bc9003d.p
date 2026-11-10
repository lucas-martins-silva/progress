/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003D 2.00.00.017} /*** "010017" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9003d MBC}
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
**     Programa...: bc9003d.p  
**
**     Finalidade.: Adapter da transacao de Reporte Por Ordem
**                                          Reporte Por Operaá∆o
**                                          Reporte Por Ponto de Controle
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02                 */
{cdp/cdcfgmat.i} /* Include com preprocessador para release 2.02                 */
{cpp/cpapi001.i} /* Definiá∆o das temp-tables da API de reporte BATCH            */
{bcp/bcapi004.i} /* Definiá∆o da temp-table tt-prog-bc                           */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
define variable c-conteudo              as char                 no-undo.
define variable i-conteudo              as integer              no-undo.
define variable h-cpapi001              as handle               no-undo.

define variable h_api_cta_ctbl          as handle               no-undo.
define variable c-cod-cta-refugo        as character            no-undo.
define variable c-cod-ccusto-refugo     as character            no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro      as integer format ">>>>,>>9" label "N£mero"         column-label "N£mero"
    field ttv_des_msg_ajuda     as character format "x(40)"  label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro      as character format "x(60)"  label "Mensagem Erro"  column-label "Inconsistància".
/*********************************************************************************/
{include/i-epc200.i "cpapi007"} /* Definicao de elementos referentes a UPC       */
{cpp/cpapi001.i1}

/*********************************************************************************/

/*********************************************************************************/

Do:   
    if not valid-handle(h_api_cta_ctbl) then
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9003d").
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

    assign i-conteudo = _RetornaValInte('nr-ord-produ').

    Find First ord-prod
         Where ord-prod.nr-ord-produ = i-conteudo
         No-Lock No-error.

    If  Not Avail ord-prod Then Do:
        {utp/ut-table.i mgind ord-prod 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    End.
    /*inicio alteraá‰es projeto - 107*/
    FIND FIRST estabelec WHERE
        estabelec.cod-estabel = ord-prod.cod-estabel NO-LOCK NO-ERROR.
    IF NOT AVAIL estabelec THEN DO:
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p ( input "MSG",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    END.
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

    Find First tt-erro No-error.
    If  Available(tt-erro) Then
        Return 'NOK'.

    Find First tt-prog-bc No-Lock No-error.

    Create  tt-rep-prod.

    Assign  tt-rep-prod.tipo                    = _RetornaValInte('tipo')
            tt-rep-prod.cod-versao-integracao   = 1
            tt-rep-prod.nr-ord-produ            = Ord-Prod.nr-ord-produ
            tt-rep-prod.it-codigo               = Item.It-codigo.

    Assign  tt-rep-prod.cod-depos-sai           = _RetornaValChar('cod-depos-sai')
            tt-rep-prod.cod-local-sai           = _RetornaValChar('cod-local-sai')
            tt-rep-prod.data                    = _RetornaValData('data')
            tt-rep-prod.un                      = ( If  _RetornaValChar('un') = ''
                                                    Then Item.un
                                                    Else _RetornaValChar('un'))
            /*Inicio alteraá‰es projeto - 107*/
            tt-rep-prod.ct-codigo               = ( If  _RetornaValChar('cod-cta-codigo') = ''
                                                    Then Ord-Prod.ct-codigo
                                                    Else _RetornaValChar('cod-cta-codigo'))
            tt-rep-prod.sc-codigo               = ( If  _RetornaValChar('cod-ccusto-codigo') = ''
                                                    Then Ord-Prod.sc-codigo
                                                    Else _RetornaValChar('cod-ccusto-codigo'))
            
            tt-rep-prod.cod-cta-unif            = _RetornaValChar('cod-cta-aplic')
            tt-rep-prod.cod-ccusto-unif         = _RetornaValChar('cod-ccusto-aplic')
            /*Fim alteraá‰es projeto - 107*/
            tt-rep-prod.nro-docto               = ( IF _RetornaValChar('nro-docto') = ""
                                                    Then String(Ord-Prod.nr-ord-produ)
                                                    Else _RetornaValChar('nro-docto'))
            tt-rep-prod.serie-docto             = _RetornaValChar('serie-docto')
            tt-rep-prod.cod-depos               = _RetornaValChar('cod-depos')
            tt-rep-prod.cod-localiz             = _RetornaValChar('cod-localiz')
            tt-rep-prod.lote-serie              = _RetornaValChar('lote-serie')
            tt-rep-prod.cod-refer               = _RetornaValChar('cod-refer')
            tt-rep-prod.dt-vali-lote            = _RetornaValData('dt-vali-lote').

    assign          
            tt-rep-prod.op-codigo               = _RetornaValInte('op-codigo')
            tt-rep-prod.cod-roteiro             = _RetornaValChar('cod-roteiro')
            tt-rep-prod.it-oper                 = ( If   _RetornaValChar('it-oper') = ""
                                                    Then Item.It-codigo
                                                    Else _RetornaValChar('it-oper'))
            tt-rep-prod.pto-controle            = _RetornaValInte('pto-controle')
            tt-rep-prod.baixa-reservas          = _RetornaValInte('baixa-reservas')
            tt-rep-prod.requis-automatica       = _RetornaValLogi('requis-automatica')
            tt-rep-prod.finaliza-oper           = _RetornaValLogi('finaliza-oper').

    assign           
            tt-rep-prod.sequencia               = _RetornaValInte('sequencia')
            tt-rep-prod.time-out                = _RetornaValInte('time-out')
            tt-rep-prod.tentativas              = _RetornaValInte('tentativas')
            tt-rep-prod.carrega-reservas        = _RetornaValLogi('carrega-reservas')
            tt-rep-prod.prog-seg                = _RetornaValChar('prog-seg')  
            tt-rep-prod.requis-automatica       = _RetornaValLogi('requis-automatica')
            tt-rep-prod.procura-saldos          = _RetornaValLogi('procura-saldos')   
            tt-rep-prod.reserva                 = _RetornaValLogi('reserva').

    assign  tt-rep-prod.nro-ord-seq             = _RetornaValInte('nro-ord-seq').    

    assign  tt-rep-prod.linha                   = _RetornaValInte('linha')
            &IF DEFINED (bf_man_sfc_lc) &THEN  
            tt-rep-prod.dep-refugo              = _RetornaValChar('dep-refugo')
            tt-rep-prod.loc-refugo              = _RetornaValChar('loc-refugo')
            &ENDIF
            tt-rep-prod.finaliza-ordem          = ( If   _RetornaValLogi('Finaliza-Ordem')
                                                    Then _RetornaValLogi('Finaliza-Ordem')
                                                    Else    If  tt-prog-bc.muda-status       = no    /* n∆o muda estado */
                                                            or  tt-prog-bc.motivo-backflush <> 1     /* reporte diferene de normal */
                                                            Then no      /* n∆o fecha a ordem */
                                                            else    If ( (  ord-prod.qt-produzida
                                                                           + _RetornaValDeci('qt-reporte')) >= ord-prod.qt-ordem)
                                                                    Then yes
                                                                    else no).
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

            Assign  tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').

            if  tt-rep-prod.qt-refugo > 0 then do:

                /*inicio alteraá‰es projeto - 107*/

                assign c-cod-cta-refugo = If  _RetornaValChar('cod-cta-refugo') = ''
                                               Then tt-prog-bc.cod-cta-refugo-unif
                                               Else _RetornaValChar('cod-cta-refugo')
                       c-cod-ccusto-refugo   = If  _RetornaValChar('cod-ccusto-refugo') = ''
                                               Then tt-prog-bc.cod-ccusto-refugo-unif
                                               Else _RetornaValChar('cod-ccusto-refugo').

                /*Valida conta contabil*/            
                run pi_valida_conta_contabil in h_api_cta_ctbl (input  estabelec.ep-codigo,     /* EMPRESA EMS2 */
                                                                input  ord-prod.cod-estabel,    /* ESTABELECIMENTO EMS2 */
                                                                input  "",                      /* UNIDADE NEG‡CIO */
                                                                input  "",                      /* PLANO CONTAS */ 
                                                                input  c-cod-cta-refugo,        /* CONTA */
                                                                input  "",                      /* PLANO CCUSTO */ 
                                                                input  c-cod-ccusto-refugo,     /* CCUSTO */
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
                        /*Inicio alteraá‰es projeto - 107*/
                        tt-rep-prod.ct-refugo       = c-cod-cta-refugo
                        tt-rep-prod.sc-refugo       = c-cod-ccusto-refugo.
                        /*Fim alteraá‰es projeto - 107*/

                Create  tt-refugo.
                Assign  tt-refugo.nr-ord-produ  = Ord-Prod.nr-ord-produ
                        tt-refugo.codigo-rejei  = tt-prog-bc.codigo-rejei.
                Assign  tt-refugo.qt-refugo     = _RetornaValDeci('qt-refugo')
                        tt-refugo.observacao    = "".
            End.            
        End.
        when 3 Then Do:

            Assign  tt-rep-prod.qt-reporte  = _RetornaValDeci('qt-reporte')
                    tt-rep-prod.qt-refugo   = _RetornaValDeci('qt-refugo')
                    tt-rep-prod.qt-apr-cond = _RetornaValDeci('qt-apr-cond').

            if  tt-rep-prod.qt-apr-cond > 0 then do:

                Create  tt-refugo.
                Assign  tt-refugo.nr-ord-produ = Ord-Prod.nr-ord-produ
                        tt-refugo.codigo-rejei = tt-prog-bc.codigo-rejei.
                Assign  tt-refugo.qt-refugo    = _RetornaValDeci('qt-refugo')
                        tt-refugo.observacao   = "".
            End.            
        End.
    End.

    /* Chamada EPC para Itatiaia - Fo 216.482 */ 
    For  Each tt-epc
        Where tt-epc.cod-event = "Before-load" :
        Delete tt-epc.
    End.

    For  Each reservas  Fields (nr-ord-produ quant-orig)
        Where reservas.nr-ord-produ = ord-prod.nr-ord-produ
          And reservas.quant-orig  <> 0 No-Lock:

        Create  tt-epc.
        Assign  tt-epc.cod-event     = "Before-load"
                tt-epc.cod-parameter = "reservas-rowid"
                tt-epc.val-parameter = string(rowid(reservas)).
    End.

    {include/i-epc201.i "Before-load"}

    run cpp/cpapi001.p persistent set h-cpapi001  ( input-output table tt-rep-prod,
                                                    input        table tt-refugo,
                                                    input        table tt-res-neg,
                                                    input        table tt-apont-mob,
                                                    input-output table tt-erro,
                                                    input yes).

    /************************************************************************************************************************************/
    /******** Opá∆o criada para a Riocell (FO:654120), onde poder† desta forma baixar saldo do componente a menor que a reserva  ********/

    Find first tt-rep-prod NO-LOCK no-error.

    For  Each tt-epc
        Where tt-epc.cod-event = "Before-Report"
           OR tt-epc.cod-event = "After-Report" :
        Delete tt-epc.
    End.

    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Handle-Cpapi001"
            tt-epc.val-parameter = string(h-cpapi001).  /* Na UPC usar Widget-Handle(h-cpapi001) */
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Num-Ordem-Prod"
            tt-epc.val-parameter = string(tt-rep-prod.nr-ord-produ).
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Tipo-Ordem"
            tt-epc.val-parameter = string(tt-rep-prod.tipo).
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Item-Ordem"
            tt-epc.val-parameter = string(tt-rep-prod.it-codigo).
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Quantidade-Ordem"
            tt-epc.val-parameter = string(tt-rep-prod.qt-reporte).
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Reserva"
            tt-epc.val-parameter = string(tt-rep-prod.reserva).
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Handle-Bc9003d"
            tt-epc.val-parameter = STRING(THIS-PROCEDURE).  /* Na UPC usar Widget-Handle(h-cpapi001) */
    Create  tt-epc.
    Assign  tt-epc.cod-event     = "Before-Report"
            tt-epc.cod-parameter = "Nr-Trans"
            tt-epc.val-parameter = string(pNumTrans).

    {include/i-epc201.i "Before-Report"}

    /*** Como a CPAPI001 esta sendo executa persistent somente ser† necess†rio executar a procedure que dar† inicio ao reporte
         Esta procedure esta dentro do programa CPAPI001.p ***/

    /*** Caso seja feita alguma alteraá∆o nos valores das TTs abaixo, as procedures abaixo ir∆o atualizar ***/
    Run pi-retorna-tt-rep-prod  IN H-CPAPI001 (output table tt-rep-prod).
    Run pi-retorna-tt-refugo    IN H-CPAPI001 (output table tt-refugo).

    run pi-processa-reportes in h-cpapi001 (input-output table tt-rep-prod,
                                            input        table tt-refugo,
                                            input        table tt-res-neg,
                                            input-output table tt-erro,
                                            input        yes,   /* Delete Erros */
                                            input        yes).

    if return-value = "NOK":U then do:
        run utp/ut-msgs.p (input "msg",
                           input 27611,
                           input "").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 27611
                tt-erro.mensagem = Trim(Return-Value).
    end.

    For  Each tt-epc
        Where tt-epc.cod-event = "Before-Report" :
        Assign  tt-epc.cod-event = "After-Report".
    End.

    {include/i-epc201.i "After-Report"}

    IF VALID-HANDLE(h-cpapi001)
    THEN DO:
        RUN pi-finalizar IN h-cpapi001.
        ASSIGN h-cpapi001 = ?.
    END.
    For  Each tt-epc
        Where tt-epc.cod-event = "Before-Report" :
        Delete tt-epc.
    End.

    /************************************************************************************************************************************/

    /* Chamada EPC para Itatiaia - Fo 216.482 */
    For  Each tt-epc
        Where tt-epc.cod-event = "After-load" :
        Delete tt-epc.
    End.

    For  Each tt-epc
        Where tt-epc.cod-event = "Before-load" :
        Delete tt-epc.
    End.

    Find First tt-rep-prod No-Lock No-error.

    If  tt-rep-prod.finaliza-oper
    Then Do:
        For  Each reservas fields (nr-ord-produ quant-orig) No-Lock
            Where reservas.nr-ord-produ = ord-prod.nr-ord-produ
              And reservas.quant-orig  <> 0:

            Create  tt-epc.
            Assign  tt-epc.cod-event     = "After-load"
                    tt-epc.cod-parameter = "reservas-rowid"
                    tt-epc.val-parameter = string(rowid(reservas)). 
        End.
        {include/i-epc201.i "After-load"}
    End.


End. /* Do: Main */


/** possibilitar que epc retorne a tt-res-neg para o bc9003d **/
PROCEDURE pi-retorna-tt-rep-prod: 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-rep-prod.
END.
PROCEDURE pi-recebe-tt-rep-prod: 
    DEFINE INPUT PARAMETER TABLE FOR tt-rep-prod.
END.
PROCEDURE pi-retorna-tt-refugo: 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-refugo.
END.
PROCEDURE pi-recebe-tt-refugo: 
    DEFINE INPUT PARAMETER TABLE FOR tt-refugo.
END.
PROCEDURE pi-retorna-tt-res-neg: 
    DEFINE OUTPUT PARAMETER TABLE FOR tt-res-neg.
END.
PROCEDURE pi-recebe-tt-res-neg: 
    DEFINE INPUT PARAMETER TABLE FOR tt-res-neg.
END.
/** possibilitar que epc retorne a tt-res-neg **/
