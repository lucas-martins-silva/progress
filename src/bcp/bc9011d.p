/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9011D 2.00.00.008 } /*** "010008" 09/10/2025 11:26:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9011D MBC}
&ENDIF


/**********************************************************************************
**     Programa...: bc9011d.p  
**
**     Finalidade.: Adapter da transacao de rquisicao do Datasul EMS 
**
**     Criado em..: Setembro 2000
**
**********************************************************************************/
{bcp/bc9102.i}          /* Definicao da temp-table de erros do coleta de dados   */
{bcp/bc9107.i}          /* Definicao dos campos de comunicacao com o adapter     */
{mip/miapi006.i}
{mip/miapi006.i1} /* Defini‡Æo das temp-tables internas     */

def temp-table tt-erros-mi no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
DEFINE VARIABLE i-numeor-ordem AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-it-codigo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-depos    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-localiz  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-refer    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-lote     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-qtd         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-retorno      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-erro         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-texto        AS CHARACTER   NO-UNDO.

DEFINE VARIABLE i-sequencia    AS INTEGER     NO-UNDO.
Define Variable vEmpresaPrincipal   As Integer              No-undo.
define variable c-conteudo as char   no-undo.
define variable i-conteudo as int    no-undo.
def var hDAPI-miapi006     as handle no-undo.
define buffer bftt-aloca for tt-aloca.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9011e").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(Return-Value).
        Return 'NOK'.
    End.

    c-conteudo = _RetornaValChar('it-codigo').
    Find Item No-lock 
    Where Item.it-codigo = c-conteudo No-error.

    if not valid-handle(hDAPI-miapi006) then do:
        run mip/miapi006.p persistent set hDAPI-miapi006    (input table  tt-requis,
                                                             input-output table tt-erros-mi,
                                                             input        yes).
    end.

    Create tt-requis.
    Assign tt-requis.tipo-trans            = 1
           tt-requis.nr-ord-produ          = int(_RetornaValInte('numero-ordem'))
           tt-requis.quantidade            = dec(_RetornaValDeci('quantidade'))
           tt-requis.data                  = Today
           tt-requis.item-ini              = _RetornaValChar('it-codigo')
           tt-requis.item-fim              = _RetornaValChar('it-codigo')
           tt-requis.deposito-ini          = _RetornaValChar('cod-depos')
           tt-requis.deposito-fim          = _RetornaValChar('cod-depos')
           tt-requis.op-codigo-ini         = _RetornaValInte('op-codigo')
           tt-requis.op-codigo-fim         = _RetornaValInte('op-codigo')
           tt-requis.cod-localiz-ini       = _RetornaValChar('localizacao')
           tt-requis.cod-localiz-fim       = _RetornaValChar('localizacao')
           tt-requis.procura-saldos        = NO
           tt-requis.carrega-reservas      = NO
           tt-requis.prog-seg              = 'bc9011d' 
           tt-requis.time-out              = 10
           tt-requis.tentativas            = 1 
           tt-requis.cod-versao-integracao = 1
           tt-requis.nro-docto             = _RetornaValChar('nro-docto') 
           tt-requis.serie-docto           = _RetornaValChar('serie-docto').

    ASSIGN i-numeor-ordem = tt-requis.nr-ord-produ
           c-it-codigo    = tt-requis.item-ini
           c-cod-depos    = tt-requis.deposito-ini
           c-cod-localiz  = tt-requis.cod-localiz-ini
           c-cod-refer    = _RetornaValChar('cod-refer')
           c-cod-lote     = _RetornaValChar('lote')
           de-qtd         = tt-requis.quantidade.

    run pi-recebe-tt-requis in hDAPI-miapi006 (input table tt-requis).
    run pi-valida-ordem in hDAPI-miapi006 (input yes,
                                     input tt-requis.nr-ord-produ,
                                     input "",
                                     output c-erro,
                                     output c-texto).
    RUN pi-carrega-tt-reservas in hDAPI-miapi006.
    run pi-retorna-tt-aloca in hDAPI-miapi006 (output table tt-aloca).
    run pi-retorna-tt-reservas in hDAPI-miapi006 (output table tt-reservas).


    FIND FIRST bftt-aloca
       WHERE bftt-aloca.nr-ord-produ = i-numeor-ordem
         AND bftt-aloca.it-codigo    = c-it-codigo
         AND bftt-aloca.cod-depos    = c-cod-depos
         AND bftt-aloca.cod-localiz  = c-cod-localiz EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL bftt-aloca THEN DO:
        FOR EACH tt-aloca
           WHERE tt-aloca.nr-ord-produ = i-numeor-ordem
             AND tt-aloca.it-codigo    = c-it-codigo EXCLUSIVE-LOCK:
            FOR EACH tt-reservas
               WHERE tt-reservas.nr-ord-produ = i-numeor-ordem
                 AND tt-reservas.it-codigo    = c-it-codigo EXCLUSIVE-LOCK:
                IF tt-reservas.cod-depos      = c-cod-depos   AND
                   tt-reservas.cod-localiz    = c-cod-localiz AND
                   tt-reservas.cod-refer      = c-cod-refer     AND
                   tt-reservas.lote-serie     = c-cod-lote  THEN
                    ASSIGN tt-reservas.quant-requis = 0
                           tt-reservas.selec        = YES
                           tt-reservas.cod-refer    = c-cod-refer  
                           tt-reservas.lote-serie   = c-cod-lote.   
                ELSE
                    ASSIGN tt-reservas.selec = NO.        
            END.
            IF tt-aloca.cod-depos      = c-cod-depos   AND
               tt-aloca.cod-localiz    = c-cod-localiz AND
               tt-aloca.cod-refer      = c-cod-refer   AND
               tt-aloca.lote-serie     = c-cod-lote THEN DO:
                ASSIGN tt-aloca.qt-a-req   = de-qtd
                       tt-aloca.selec      = YES
                       tt-aloca.cod-refer  = c-cod-refer
                       tt-aloca.lote-serie = c-cod-lote.
            END.
            ELSE DO:
                ASSIGN tt-aloca.selec = NO. 
            END.
        END.
    END.
    ELSE DO:
        FOR EACH tt-reservas
           WHERE tt-reservas.nr-ord-produ = i-numeor-ordem
             AND tt-reservas.it-codigo    = c-it-codigo EXCLUSIVE-LOCK:
            IF tt-reservas.cod-depos      = c-cod-depos   AND
               tt-reservas.cod-localiz    = c-cod-localiz THEN
                ASSIGN tt-reservas.quant-requis = de-qtd
                       tt-reservas.selec        = YES
                       tt-reservas.cod-refer    = c-cod-refer  
                       tt-reservas.lote-serie   = c-cod-lote.             
            ELSE
                ASSIGN tt-reservas.selec = NO.

        END.
    END.

    run pi-recebe-tt-aloca in hDAPI-miapi006 (input table tt-aloca).
    run pi-recebe-tt-reservas in hDAPI-miapi006 (input table tt-reservas).


    FOR EACH tt-reservas NO-LOCK:
        run pi-valida-reserva in hDAPI-miapi006 (tt-reservas.nr-ord-produ,
                                                 tt-reservas.sequencia,
                                                 1,
                                                 input  yes,
                                                 output c-erro,
                                                 output c-texto).

        IF RETURN-VALUE = "NOK" THEN DO:
            run utp/ut-msgs.p (input "msg",
                               input INT(c-erro),
                               input "").
            Create  tt-erros-mi.
            Assign  tt-erros-mi.i-sequen = i-sequencia + 1
                    tt-erros-mi.cd-erro  = INT(c-erro)
                    tt-erros-mi.mensagem = RETURN-VALUE
                    i-sequencia          = i-sequencia  + 1.
        END.
    END.

    FOR EACH tt-aloca NO-LOCK:
        run pi-valida-alocacao in hDAPI-miapi006 (tt-aloca.nr-ord-produ,
                                                  tt-aloca.sequencia,
                                                  input  yes,
                                                  output c-erro,
                                                  output c-texto).
        IF RETURN-VALUE = "NOK" THEN DO:
            run utp/ut-msgs.p (input "msg",
                               input INT(c-erro),
                               input "").

            Create  tt-erros-mi.
            Assign  tt-erros-mi.i-sequen = i-sequencia + 1
                    tt-erros-mi.cd-erro  = INT(c-erro)
                    tt-erros-mi.mensagem = RETURN-VALUE
                    i-sequencia          = i-sequencia  + 1.
        END.
    END.

    IF NOT CAN-FIND(FIRST tt-erros-mi) THEN
        run pi-processa-requis in hDAPI-miapi006 (input table  tt-requis,
                                                  input-output table tt-erros-mi,
                                                  input        yes).

    for each tt-erros-mi:

        Create  tt-erro.
        Assign  tt-erro.i-sequen = tt-erros-mi.i-sequen
                tt-erro.cd-erro  = 0
                tt-erro.mensagem = tt-erros-mi.mensagem.

    end.

    Run destroy In hDAPI-miapi006 No-error.

    find first tt-erro no-error.

    if avail tt-erro then Return "NOK".                

End. /* Do: Main */


