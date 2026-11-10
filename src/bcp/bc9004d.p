/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9004D 2.00.00.010} /*** "010010" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9004D MBC}
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
**     Programa...: bc9004d.p  
**
**     Finalidade.: Adapter da transacao de rquisicao do Datasul EMS 2.00 
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{cep/ceapi001k.i}    /* Defini‡Æo da temp-table para movto-estoq */
{bcp/bcapi004.i}    /* Defini‡Æo da temp-table tt-prog-bc       */
{cdp/cdcfgmat.i}    /* Defini‡Æo do preprocessador bf_mat_conta_estab */
{cdp/cdcfgman.i}    /* Defini‡Æo do preprocessador bf_man_linha_estab */

{cpp/cpapi017.i}    /* Defini‡Æo da temp-table de requisi‡Æo */
{cdp/cd9203.i}
{bcp/bc9102.i}      /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}      /* Definicao dos campos de comunicacao com o adapter            */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
define variable c-conteudo              as char                 no-undo.
Define Buffer B-Saldo                   For Saldo-Estoq.
DEFINE VARIABLE c-item-pai              AS CHAR                 NO-UNDO.
define variable h-ceapi001k             as handle               no-undo.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9004d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(Return-Value).
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

    Find First param-estoq No-Lock No-error.
    If  Not Avail param-estoq
    Then Do:
        {utp/ut-table.i mguni param-estoq 1}
        run utp/ut-msgs.p ( input "msg",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 56
                tt-erro.mensagem = Trim(Return-Value).
        Return 'NOK'.
    End.

    assign c-conteudo = _RetornaValChar('it-codigo').
    Find First item
         Where item.it-codigo = c-conteudo
         no-lock no-error.

    If  Not Available item
    Then Do:
        {utp/ut-table.i mgind item 1}
        run utp/ut-msgs.p ( input "msg",
                            input 56,
                            input Trim(Return-Value)).
        Create  tt-erro.
        Assign  tt-erro.mensagem = Trim(Return-Value)
                tt-erro.cd-erro  = 56.
        Return 'NOK'.
    End.
    
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

    If  _RetornaValInte('tipo-trans') <> 0 then.

    Find First tt-erro No-error.
    If  Available(tt-erro) Then
        Return 'NOK'.

    Find First tt-prog-bc No-Lock No-error.

    For Each tt-requis:
        Delete tt-requis.
    End.

    create tt-requis.

    assign 
            tt-requis.tipo-trans            = (If _RetornaValInte('tipo-trans') = 0
                                               or _RetornaValInte('tipo-trans') = 1
                                               or _RetornaValInte('tipo-trans') = 3                                                            
                                               then 1 /* REQ */
                                               else 2 /* DEV */ )
                                                  
            tt-requis.nr-ord-produ          = _RetornaValInte('nr-ord-produ')
            tt-requis.it-codigo             = item.it-codigo.

    FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = tt-requis.nr-ord-produ NO-LOCK NO-ERROR.                                                        

    assign             
            tt-requis.op-codigo             = _RetornaValInte('op-codigo')
            tt-requis.cod-roteiro           = _RetornaValChar('cod-roteiro')
            tt-requis.quantidade            = _RetornaValDeci('quantidade')
            tt-requis.data                  = _RetornaValData('data-transacao')
            tt-requis.dt-movto-orig         = ?    
            tt-requis.rw-movto-orig         = ?.

    assign  
            tt-requis.cod-depos             = _RetornaValChar('cod-depos') 
            tt-requis.cod-refer             = _RetornaValChar('cod-refer')
            tt-requis.cod-localiz           = _RetornaValChar('cod-localiz')
            tt-requis.lote-serie            = _RetornaValChar('lote')
            tt-requis.nro-docto             = _RetornaValChar('nro-docto')
            tt-requis.serie-docto           = _RetornaValChar('serie-docto')
            tt-requis.procura-saldos        = _RetornaValLogi('procura-saldos') 
            tt-requis.prog-seg              = "bc9004d"
            tt-requis.cod-versao-integracao = 1
            tt-requis.seq                   = 1.
            
    
    ASSIGN  c-item-pai = IF _RetornaValChar('item-pai') <> "":U THEN
                            _RetornaValChar('item-pai')
                         ELSE
                             IF AVAIL ord-prod THEN
                                  ord-prod.it-codigo
                             ELSE
                                  "":U.
                                  
    IF c-item-pai = "" OR NOT CAN-FIND(FIRST reservas
                                       WHERE reservas.nr-ord-produ = tt-requis.nr-ord-produ  
                                         AND reservas.item-pai     = c-item-pai
                                         AND reservas.it-codigo    = tt-requis.it-codigo  
                                         AND reservas.cod-refer    = tt-requis.cod-refer
                                         AND reservas.cod-roteiro  = tt-requis.cod-roteiro
                                         AND reservas.op-codigo    = tt-requis.op-codigo) THEN DO:
                                             
         FOR FIRST reservas FIELDS(item-pai)
             WHERE reservas.nr-ord-produ = tt-requis.nr-ord-produ
               AND reservas.it-codigo    = tt-requis.it-codigo  
               AND reservas.cod-refer    = tt-requis.cod-refer
               AND reservas.cod-roteiro  = tt-requis.cod-roteiro
               AND reservas.op-codigo    = tt-requis.op-codigo NO-LOCK:
               
             ASSIGN tt-requis.item-pai = reservas.item-pai.               
         END.                                              
    END.                                            
                                                      
       
    Find First tt-erro No-error.

    If  Available(tt-erro) 
    Then
        Return 'NOK'.


    if tt-requis.nr-ord-produ <> 0 then  
        run cpp/cpapi017.p  (input        table tt-requis,
                             input-output table tt-erro,
                             input        YES /*l-deleta-erros*/ ).

    else do:
            create tt-movto.
            assign tt-movto.cod-versao-integracao  = 1
                   tt-movto.cod-prog-orig     = "bc9004d"
                   tt-movto.cod-depos         = _RetornaValChar('cod-depos')
                   tt-movto.cod-emitente      = _RetornaValInte('cod-emitente')
                   tt-movto.cod-estabel       = _RetornaValChar('cod-estabel')
                   tt-movto.cod-refer         = _RetornaValChar('cod-refer')
                   tt-movto.ct-codigo         = _RetornaValChar('ct-codigo')
                   tt-movto.descricao-db      = _RetornaValChar('descricao-db')
                   tt-movto.dt-nf-saida       = _RetornaValData('dt-nf-saida').

            assign tt-movto.dt-trans          = _RetornaValData('data-transacao')
                   tt-movto.esp-docto         = if tt-requis.tipo-trans = 1
                                                   then 28
                                                   else 5
                   tt-movto.it-codigo         = item.it-codigo
                   tt-movto.cod-localiz       = _RetornaValChar('cod-localiz')
                   tt-movto.lote              = _RetornaValChar('lote')
                   tt-movto.nat-operacao      = _RetornaValChar('nat-operacao')
                   tt-movto.nro-docto         = _RetornaValChar('nro-docto')
                   tt-movto.num-sequen        = _RetornaValInte('num-sequen')
                   tt-movto.numero-ordem      = _RetornaValInte('numero-ordem')
                   tt-movto.tipo-trans        = if tt-requis.tipo-trans = 1
                                                   then 2
                                                   else 1.

            assign tt-movto.nr-ord-produ      = _RetornaValInte('nr-ord-produ')
                   tt-movto.peso-liquido      = _RetornaValDeci('peso-liquido')
                   tt-movto.quantidade        = _RetornaValDeci('quantidade')
                   tt-movto.referencia        = _RetornaValChar('referencia')
                   tt-movto.sc-codigo         = _RetornaValChar('sc-codigo')
                   tt-movto.serie-docto       = _RetornaValChar('serie-docto')
                   tt-movto.tipo-preco        = _RetornaValInte('tipo-preco')
                   tt-movto.tipo-valor        = _RetornaValInte('tipo-valor')
                   tt-movto.un                = item.un /* _RetornaValChar('un') */.

            assign tt-movto.valor-mat-m       = _RetornaValDeci('valor-mat-m')
                   tt-movto.valor-mat-o       = _RetornaValDeci('valor-mat-o')
                   tt-movto.valor-mat-p       = _RetornaValDeci('valor-mat-p')
                   tt-movto.valor-mob-m       = _RetornaValDeci('valor-mob-m')
                   tt-movto.valor-mob-o       = _RetornaValDeci('valor-mob-o')
                   tt-movto.valor-mob-p       = _RetornaValDeci('valor-mob-p')
                   tt-movto.valor-ggf-m       = _RetornaValDeci('valor-ggf-m').

            assign tt-movto.valor-ggf-o       = _RetornaValDeci('valor-ggf-o')
                   tt-movto.valor-ggf-p       = _RetornaValDeci('valor-ggf-p')
                   tt-movto.valor-nota        = _RetornaValDeci('valor-nota')
                   tt-movto.vl-nota-fasb      = _RetornaValDeci('vl-nota-fasb')
                   tt-movto.nr-ord-refer      = _RetornaValInte('nr-ord-refer')
                   tt-movto.nr-req-sum        = _RetornaValInte('nr-req-sum')
                   tt-movto.cod-roteiro       = _RetornaValChar('cod-roteiro')
                   tt-movto.nr-reporte        = _RetornaValInte('nr-reporte').

            assign tt-movto.item-pai          = _RetornaValChar('item-pai')
                   tt-movto.op-codigo         = _RetornaValInte('op-codigo')
                   tt-movto.ct-db             = _RetornaValChar('ct-db')
                   tt-movto.sc-db             = _RetornaValChar('sc-db')
                   tt-movto.dt-vali-lote      = _RetornaValData('dt-vali-lote')
                   tt-movto.op-seq            = _RetornaValInte('op-seq').

            assign tt-movto.nr-trans          = 1
                   tt-movto.cod-estabel-des   = _RetornaValChar('cod-estabel-des')
                   tt-movto.origem-valor      = _RetornaValChar('origem-valor')
                   tt-movto.num-ord-des       = _RetornaValInte('num-ord-des')
                   tt-movto.num-seq-des       = _RetornaValInte('num-seq-des')
                   tt-movto.num-ord-inv       = _RetornaValInte('num-ord-inv')
                   tt-movto.valor-ipi         = _RetornaValDeci('valor-ipi')
                   tt-movto.valor-iss         = _RetornaValDeci('valor-iss').

            assign tt-movto.valor-icm         = _RetornaValDeci('valor-icm')
                   tt-movto.vl-icm-fasb       = _RetornaValDeci('vl-icm-fasb')
                   tt-movto.vl-iss-fasb       = _RetornaValDeci('vl-iss-fasb')
                   tt-movto.vl-ipi-fasb       = _RetornaValDeci('vl-ipi-fasb')
                   tt-movto.atualiza-ul-ent   = _RetornaValLogi('atualiza-ult-ent')
                   tt-movto.i-sequen          = _RetornaValInte('i-sequen')
                   tt-movto.qt-alocada        = _RetornaValDeci('qt-alocada').

        /* Atualiza o estoque */
        run cep/ceapi001k.p persistent set h-ceapi001k.
        run pi-execute in h-ceapi001k (input-output table tt-movto,
                                       input-output table tt-erro,
                                       input yes).

        if valid-handle(h-ceapi001k) then do:
            delete procedure h-ceapi001k.
            assign h-ceapi001k = ?.
        end.
    end.

    Find First tt-erro No-lock No-error.

    If  Avail tt-erro Then
        Return "NOK".

End. /* Do: Main */

return "OK".
