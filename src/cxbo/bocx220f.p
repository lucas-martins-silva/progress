/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX220F 2.00.00.083 } /*** "010083" 06/10/2026 00:42:38 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx220f MUT}
&ENDIF

/*******************************************************************************
**
**  BOCX220F.P - Embarque
**
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY embarque-imp
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME embarque-imp

{cdp/cdcfgmat.i} /* Include pr‚-processadores */
{include/i-epc200.i BOCX220F} /* definicao referente a UPC */

{include/boini.i}
{cdp/cd4300.i3}                  /* include tratamento atributo livre */
{cxbo/bocx220.i RowObject}
{cxbo/bocx220.i tt-embarque-imp}
{imp/im0091.i}
{imp/im9024.i1}
{btb/btb009za.i}
{cdp/cd0666.i}

def var l-ja-conectado      as logical      no-undo.
def var l-ems50             AS logical      no-undo.
DEF VAR h-btb009za          AS HANDLE       NO-UNDO.
DEF VAR h-bocx310           AS HANDLE       NO-UNDO.
DEF VAR l-erro              AS LOGICAL      NO-UNDO.
DEF VAR l-erro-fatura       AS LOGICAL      INITIAL NO NO-UNDO.
DEF VAR c-lb-itiner         AS CHAR         NO-UNDO.
DEF VAR c-lb-pto-controle   AS CHAR         NO-UNDO.
DEFINE VARIABLE l-nt2024002 AS LOGICAL      NO-UNDO.
def var h-im0091            as handle  no-undo.
def var h-bocx295           as handle  no-undo.
def var h-boin356aa         as handle  no-undo.
DEF VAR l-own-im0091        AS LOGICAL NO-UNDO.
DEF VAR l-own-bocx295       AS LOGICAL NO-UNDO.
DEF VAR l-own-boin356aa     AS LOGICAL NO-UNDO.
DEF VAR l-own-bocx310       AS LOGICAL NO-UNDO.
DEF VAR l-possui-di-duimp   AS LOGICAL NO-UNDO.

&if defined(bf-mat-comex) &then
&else
    {utp/ut-glob.i} /* Vari veis globais de ambiente */
    {imp/im0080.i1} /* Contabiliza‡Æo Material em Trƒnsito */
&endif

/*
** Temp-table procedures de Neg¢cio
*/
{cxbo/bocx220f.i1 tt-embarque-novo}
{cxbo/bocx295.i tt-invoice-emb-imp-n}
{cxbo/bocx310.i tt-desp-embarque-n}

/*
** temp-table com ordens/quantidades a nacionalizar
*/
def temp-table tt-ordens-nac no-undo like ordens-embarque
    FIELD c-it-codigo        LIKE ITEM.it-codigo
    field de-quantidade-nac  like ordens-embarque.quantidade
    field i-parcela-nova     as   integer
    field de-quant-nova      like ordens-embarque.quantidade
    field de-qt-fn-nova      like ordens-embarque.quantidade
    field r-rowid            as   rowid
	INDEX idx-chv  cod-estabel embarque numero-ordem parcela
    INDEX idx-emb  cod-estabel embarque.

{cdp/cdcfgmat.i} /* defini‡Æo pr‚-processador */

DEFINE VARIABLE h-boin090a      AS HANDLE      NO-UNDO.
DEFINE BUFFER b-ordens-embarque       FOR ordens-embarque.
DEFINE BUFFER b-tt-ordens-nac         FOR tt-ordens-nac.
DEFINE BUFFER bf-ordens-embarque-trib FOR ordens-embarque-trib.

DEFINE QUERY {&QUERY-NAME} FOR embarque-imp,
    ordens-embarque fields(cod-estabel embarque) scrolling rcode-information.

/*
** Vari veis para openQueries
*/
def var c-cod-estabel like estabelec.cod-estabel no-undo.
def var c-embarque    like embarque-imp.embarque no-undo.

DEF VAR l-primeiro    AS LOGICAL INITIAL YES NO-UNDO.

def var c-return-value as char    no-undo.
def var l-nac-total    as logical no-undo.
def var l-nacionaliza  as logical no-undo.
DEF VAR l-per-nac-tot  AS LOGICAL INITIAL NO NO-UNDO.
DEF VAR de-val-tx-siscomex AS DEC NO-UNDO.
DEF VAR de-tot-qtde        AS DEC NO-UNDO.
DEF VAR de-tot-qtde-nova   AS DEC NO-UNDO.
DEF VAR c-nr-adicao-vld    AS CHAR FORMAT 'x(200)' NO-UNDO.

DEF VAR g-possui-nota-emb    AS LOGICAL NO-UNDO.
DEF VAR g-permite-quebra-emb AS LOGICAL NO-UNDO.
DEF VAR g-seq-nac            AS INTEGER NO-UNDO.
DEF VAR g-cdn-pto-desembar   AS INTEGER NO-UNDO.

DEFINE TEMP-TABLE tt-docum-est-rateio NO-UNDO LIKE docum-est
       field r-rowid as rowid
       field nome-abrev as char format "x(12)".

/*variavel epc c-esp-tit-tranist*/
DEF VAR c-esp-tit-transit LIKE param-imp.esp-tit-transit NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-nt2024002":U AND funcao.ativo).

procedure setConstraint1:
end procedure.

procedure setConstraint2:
    def input parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input parameter p-embarque    like embarque-imp.embarque no-undo.

    assign c-cod-estabel = p-cod-estabel
           c-embarque    = p-embarque.
end procedure.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.

    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each embarque-imp no-lock,
                first ordens-embarque
                    where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                      and ordens-embarque.embarque    = embarque-imp.embarque no-lock.
        when 2 then
			open query {&QUERY-NAME} for each embarque-imp no-lock
				where embarque-imp.cod-estabel  > c-cod-estabel
				   or (embarque-imp.cod-estabel = c-cod-estabel
					   and embarque-imp.embarque >= c-embarque),
				first ordens-embarque
					where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
					  and ordens-embarque.embarque    = embarque-imp.embarque no-lock.
    end case.

    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.

procedure findRowid:
    def input parameter r-chave as rowid no-undo.
    find embarque-imp
        where rowid(embarque-imp) = r-chave no-lock no-error.
    if avail embarque-imp then RUN setCurrent.
end procedure.

procedure findFirst:
    release embarque-imp.
    release ordens-embarque.

    find first embarque-imp no-lock no-error.

    do while not can-find(first ordens-embarque
                          where ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                                ordens-embarque.embarque = embarque-imp.embarque):
        find next embarque-imp no-lock use-index codigo.
    end.
    run setCurrent.
end.

procedure findNext:
    def output parameter c-return as char.
    def var c-cod-estabel   like embarque-imp.cod-estabel no-undo.
    def var c-embarque      like embarque-imp.embarque no-undo.

    if avail embarque-imp then do:
        assign c-cod-estabel    = embarque-imp.cod-estabel
               c-embarque       = embarque-imp.embarque.
    end.

    find next embarque-imp no-lock no-error.

    do while not can-find(first ordens-embarque
                          where ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                                ordens-embarque.embarque = embarque-imp.embarque):
        find next embarque-imp no-lock.
    end.

    if not avail embarque-imp then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7999,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.

end.

procedure findPrev:
    def output parameter c-return as char.
    def var c-cod-estabel like embarque-imp.cod-estabel no-undo.
    def var c-embarque    like embarque-imp.embarque    no-undo.

    if avail embarque-imp then do:
        assign c-cod-estabel = embarque-imp.cod-estabel
               c-embarque    = embarque-imp.embarque.
    end.

    find prev embarque-imp no-lock no-error.

    do while not can-find(first ordens-embarque
                          where ordens-embarque.cod-estabel = embarque-imp.cod-estabel and
                                ordens-embarque.embarque = embarque-imp.embarque):
        find prev embarque-imp no-lock.
    end.
    if not avail embarque-imp then do:
        run utp/ut-msgs.p (input "msg":U,
                           input 7998,
                           input "").
        assign c-return = return-value.
    end.
    else run setCurrent.

end.

procedure findLast:
    release embarque-imp.
    release ordens-embarque.

    find last embarque-imp no-lock no-error.

    do while not can-find(first ordens-embarque
                          where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
                          and   ordens-embarque.embarque = embarque-imp.embarque):
        find prev embarque-imp no-lock use-index codigo.
    end.
    run setCurrent.
end.

procedure getRowid:
    def output parameter r-chave as rowid no-undo.

    if avail embarque-imp then do:
        assign r-chave = rowid(embarque-imp).
    end.
    else do:
        assign r-chave = ?.
    end.
end.

{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
/* {include/bonav.i}  */
/* {include/bofind.i} */
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
/* {include/boexecre.i} */
/* {include/boexeupt.i} */
/* {include/boexedel.i} */
/* {include/bovalupt.i} */
/* {include/bovaldel.i} */

procedure findCodigo:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    def input parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input parameter p-embarque    like embarque-imp.embarque no-undo.
    def output parameter c-return as char no-undo.

    find embarque-imp
        where embarque-imp.cod-estabel = p-cod-estabel
          and embarque-imp.embarque    = p-embarque no-lock no-error.
    if not avail embarque-imp then do:
        {utp/ut-table.i mgcex embarque-imp 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign c-return = trim(return-value).
    end.
    else do:
        for first ordens-embarque fields()
            where ordens-embarque.cod-estabel = embarque-imp.cod-estabel
              and ordens-embarque.embarque    = embarque-imp.embarque no-lock:
        end.
        if not avail ordens-embarque then do:
            {utp/ut-table.i mgcex embarque-imp 1}
            run utp/ut-msgs.p (input "msg":U,
                               input 2,
                               input return-value).
            assign c-return = trim(return-value).
        end.
        else do:
            run setCurrent.
        end.
    end.

end procedure.

/*
**
** Procedures de Neg¢cio
**
*/

PROCEDURE piCarregaCacheEmbarque:
    DEF INPUT PARAM p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-embarque    LIKE embarque-imp.embarque NO-UNDO.

    ASSIGN g-possui-nota-emb    = NO
           g-permite-quebra-emb = YES
           g-seq-nac            = 0
           g-cdn-pto-desembar   = 0.

    FIND embarque-imp
         WHERE embarque-imp.cod-estabel = p-cod-estabel
           AND embarque-imp.embarque    = p-embarque
         NO-LOCK NO-ERROR.

    IF AVAIL embarque-imp THEN
        ASSIGN g-cdn-pto-desembar = embarque-imp.cdn-pto-desembar.

    IF i-pais-impto-usuario <> 1 THEN DO:
        RUN pi-ver-embarque-possui-nota (INPUT p-cod-estabel,
                                         INPUT p-embarque,
                                         INPUT 0,
                                         INPUT 0,
                                         OUTPUT g-possui-nota-emb,
                                         OUTPUT g-permite-quebra-emb).

        /* sequencia base para comparações (era recalculada várias vezes) */
        IF g-cdn-pto-desembar <> 0 THEN
            FOR FIRST historico-embarque FIELDS(sequencia)
                WHERE historico-embarque.cod-estabel   = p-cod-estabel
                  AND historico-embarque.embarque      = p-embarque
                  AND historico-embarque.cod-pto-contr = g-cdn-pto-desembar
                NO-LOCK:
                ASSIGN g-seq-nac = historico-embarque.sequencia.
            END.
    END.
END PROCEDURE.

PROCEDURE verificaembarquecontabilizado:
    /*
    ** Verifica se o Embarque a ser quebrado j  est  contabilizado.
    */

    DEF INPUT  PARAMETER TABLE FOR tt-embarque-novo.
    DEF OUTPUT PARAMETER l-contabilizado AS LOGICAL NO-UNDO.

    FIND FIRST tt-embarque-novo NO-LOCK NO-ERROR.

    FIND embarque-imp WHERE
         embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel AND
         embarque-imp.embarque    = tt-embarque-novo.c-embarque    NO-LOCK NO-ERROR.

    IF AVAIL embarque-imp THEN
        IF embarque-imp.contabilizado THEN
            ASSIGN l-contabilizado = YES.
        ELSE
            ASSIGN l-contabilizado = NO.
    ELSE
        ASSIGN l-contabilizado = NO.
END.

procedure validaParametrosDesembarqueParcial:
    /*
    ** Valida parametros para o desembarque parcial/eadi
    */
    def input  parameter table for tt-embarque-novo.
    def input  parameter table for tt-ordens-nac.
    def output parameter table for tt-bo-erro.

    /*--- Chamada UPC ---*/
    FOR EACH tt-epc  WHERE tt-epc.cod-event = "PermiteNacionalizacaoTotal" :
       DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "PermiteNacionalizacaoTotal":U
           tt-epc.cod-parameter = "l-per-nac-tot":U
           tt-epc.val-parameter =  "".

    {include/i-epc201.i "PermiteNacionalizacaoTotal"}

    FIND FIRST tt-epc WHERE
               tt-epc.cod-event     = "PermiteNacionalizacaoTotal":U AND
               tt-epc.cod-parameter = "l-per-nac-tot":U         NO-LOCK.

    IF AVAIL tt-epc AND tt-epc.val-parameter = "YES" THEN
        ASSIGN l-per-nac-tot = YES.

    /*--- Fim chamada UPC ---*/

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    find first tt-embarque-novo no-error.
    find first tt-ordens-nac    no-error.

    if not avail tt-embarque-novo then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i prepara‡Æo_p/_desembarque * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 26492,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 26492
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.

    if not avail tt-ordens-nac then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i ordens_…_nacionalizar * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 26492,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 26492
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.

    if not can-find(embarque-imp
                        where embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
                          and embarque-imp.embarque    = tt-embarque-novo.c-embarque) then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex embarque-imp 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.

        return "NOK":U.
    end.

    if tt-embarque-novo.c-embarque-novo = "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Novo_n£mero_do_embarque * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.
    else do:
        if can-find(embarque-imp
                        where embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
                          and embarque-imp.embarque    = tt-embarque-novo.c-embarque-novo) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Novo_n£mero_do_embarque * L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input 8,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
            return "NOK":U.
        end.
    end.

    if tt-embarque-novo.da-nova-entrega = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Nova_data_de_entrega * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.
    else
        if tt-embarque-novo.da-nova-entrega < today then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Nova_data_de_entrega * L}
            assign c-return-value = trim(return-value).
            {utp/ut-liter.i hoje * L}
            create tt-bo-erro.
            assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
            run utp/ut-msgs.p (input "msg":U,
                               input 25966,
                               input tt-bo-erro.parametros).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 25966
                   tt-bo-erro.mensagem     = return-value.
            return "NOK":U.
        end.

    for first historico-embarque fields(cod-itiner cod-estabel embarque)
        where historico-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
          and historico-embarque.embarque    = tt-embarque-novo.c-embarque no-lock:

        for first embarque-imp fields(cdn-pto-embarq cdn-pto-desembar cdn-pto-chegad) no-lock
            where embarque-imp.cod-estabel = historico-embarque.cod-estabel
              and embarque-imp.embarque = historico-embarque.embarque: end.

        {utp/ut-table.i mgcex itinerario 1}
            ASSIGN c-lb-itiner = RETURN-VALUE + ": " + string(historico-embarque.cod-itiner).
        IF embarque-imp.cdn-pto-embarq = 0 THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex embarque-imp cdn-pto-embarq 1}
                ASSIGN c-lb-pto-controle = RETURN-VALUE.
            run utp/ut-msgs.p (input "msg",
                               input 16381,
                               input c-lb-pto-controle + "~~" +
                                      c-lb-itiner).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 16381
                   tt-bo-erro.mensagem = return-value
                   tt-bo-erro.parametros = c-lb-pto-controle + "~~" + c-lb-itiner.
       END.
       IF embarque-imp.cdn-pto-desembar = 0 THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex embarque-imp cdn-pto-desembar 1}
                 ASSIGN c-lb-pto-controle = RETURN-VALUE.
            run utp/ut-msgs.p (input "msg",
                               input 16381,
                               input c-lb-pto-controle + "~~" +
                                      c-lb-itiner).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 16381
                   tt-bo-erro.mensagem = return-value
                   tt-bo-erro.parametros = c-lb-pto-controle + "~~" + c-lb-itiner.
       END.
       IF embarque-imp.cdn-pto-chegad = 0 THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-field.i mgcex embarque-imp cdn-pto-chegad 1}
                 ASSIGN c-lb-pto-controle = RETURN-VALUE.
            run utp/ut-msgs.p (input "msg",
                               input 16381,
                               input c-lb-pto-controle + "~~" +
                                      c-lb-itiner).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 16381
                   tt-bo-erro.mensagem = return-value
                   tt-bo-erro.parametros = c-lb-pto-controle + "~~" + c-lb-itiner.
       END.
    end.


    IF tt-embarque-novo.c-fatura = "" THEN DO:
        FIND FIRST invoice-emb-imp WHERE
                   invoice-emb-imp.cod-estabel = tt-embarque-novo.c-cod-estabel AND
                   invoice-emb-imp.embarque    = tt-embarque-novo.c-embarque NO-LOCK NO-ERROR.
        IF AVAIL invoice-emb-imp THEN DO:
            assign i-seq-erro = i-seq-erro + 1.
            /*{utp/ut-liter.i Faturas_Embarque * L}*/
            create tt-bo-erro.
            /*assign tt-bo-erro.parametros = trim(return-value).*/
            run utp/ut-msgs.p (input "msg":U,
                               input 29459,
                               input return-value).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 29459
                   tt-bo-erro.mensagem     = return-value.
            return "NOK":U.
        END.
    END.
    assign l-nac-total = yes
           l-nacionaliza = no.

    for each tt-ordens-nac:
        if tt-ordens-nac.de-quantidade-nac <> 0 then
            assign l-nacionaliza = yes.
        if tt-ordens-nac.de-quantidade-nac > tt-ordens-nac.quantidade then do:
            if not l-per-nac-tot then do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Quantidade_…_nacionalizar * L}
                assign c-return-value = trim(return-value).
                {utp/ut-liter.i quantidade_dispon¡vel. * L}
                create tt-bo-erro.
                assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
                run utp/ut-msgs.p (input "msg":U,
                                   input 25495,
                                   input tt-bo-erro.parametros).
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 25495
                       tt-bo-erro.mensagem     = return-value.
                return "NOK":U.
            end.
        end.
        else if tt-ordens-nac.de-quantidade-nac <> tt-ordens-nac.quantidade and l-nac-total then
                assign l-nac-total = no.
    end.

    if l-nacionaliza = no and not l-per-nac-tot then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Quantidade_…_nacionalizar * L}
        assign c-return-value = trim(return-value).
        create tt-bo-erro.
        assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 4700,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 4700
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.

    if l-nac-total and not l-per-nac-tot then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Embarque * L}
        assign c-return-value = trim(return-value).
        {utp/ut-liter.i nacionalizado_totalmente. * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 7972,
                           input tt-bo-erro.parametros).
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 7972
               tt-bo-erro.mensagem     = return-value.
        return "NOK":U.
    end.
    RETURN "OK":U.
end procedure.

PROCEDURE piInitPersistentsDesembarque:
    /* BOCX295 (cálculos de invoice) */
    IF NOT VALID-HANDLE(h-bocx295) THEN DO:
        RUN cxbo/bocx295.p PERSISTENT SET h-bocx295.
        ASSIGN l-own-bocx295 = YES.
    END.

    /* BOIN356AA (criação de nova parcela) */
    IF NOT VALID-HANDLE(h-boin356aa) THEN DO:
        RUN inbo/boin356aa.p PERSISTENT SET h-boin356aa.
        ASSIGN l-own-boin356aa = YES.
    END.

    /* IM0091 (rateio acompanhamento) */
    IF NOT VALID-HANDLE(h-im0091) THEN DO:
        RUN imp/im0091.p PERSISTENT SET h-im0091.
        ASSIGN l-own-im0091 = YES.
    END.

    /* BOCX310 (atualização despesa embarque) */
    IF NOT VALID-HANDLE(h-bocx310) THEN DO:
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.
        ASSIGN l-own-bocx310 = YES.
    END.
END PROCEDURE.

PROCEDURE piClosePersistentDesembarque:

    IF l-own-bocx295 AND VALID-HANDLE(h-bocx295) THEN DO:
        DELETE PROCEDURE h-bocx295 NO-ERROR.
    END.
    ASSIGN h-bocx295     = ?
           l-own-bocx295 = NO.

    IF l-own-boin356aa AND VALID-HANDLE(h-boin356aa) THEN DO:
        DELETE PROCEDURE h-boin356aa NO-ERROR.
    END.
    ASSIGN h-boin356aa     = ?
           l-own-boin356aa = NO.

    IF l-own-im0091 AND VALID-HANDLE(h-im0091) THEN DO:
        DELETE PROCEDURE h-im0091 NO-ERROR.
    END.
    ASSIGN h-im0091     = ?
           l-own-im0091 = NO.

    IF l-own-bocx310 AND VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310 NO-ERROR.
    END.
    ASSIGN h-bocx310     = ?
           l-own-bocx310 = NO.

END PROCEDURE.

PROCEDURE preparaDesembarqueParcial:
    /*
    ** Executa o desembarque parcial
    */
    DEF INPUT  PARAMETER TABLE FOR tt-embarque-novo.
    DEF INPUT  PARAMETER TABLE FOR tt-ordens-nac.
    DEF OUTPUT PARAMETER pr-embarque-imp AS ROWID NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.

    DEF VAR c-retorno-proc AS CHARACTER NO-UNDO.

    RUN piInitPersistentsDesembarque.

    RUN preparaDesembarqueParcialCore (
        INPUT  TABLE tt-embarque-novo,
        INPUT  TABLE tt-ordens-nac,
        OUTPUT pr-embarque-imp,
        OUTPUT TABLE tt-bo-erro
    ) NO-ERROR.

    ASSIGN c-retorno-proc = RETURN-VALUE.

    RUN piClosePersistentDesembarque.

    IF c-retorno-proc = "" THEN
        ASSIGN c-retorno-proc = IF ERROR-STATUS:ERROR
                                OR CAN-FIND(FIRST tt-bo-erro)
                                THEN "NOK":U
                                ELSE "OK":U.

    RETURN c-retorno-proc.
END PROCEDURE.


procedure preparaDesembarqueParcialCore:
    /*
    ** Executa o desembarque parcial
    */
    def input  parameter table for tt-embarque-novo.
    def input  parameter table for tt-ordens-nac.
    def output parameter pr-embarque-imp as rowid no-undo.
    def output parameter table for tt-bo-erro.
	def var h-bocx220      as handle no-undo.


    &If '{&BF_MAT_VERSAO_EMS}' >= '2.062' &then
        DEF BUFFER b-eq-disponib-embarq FOR eq-disponib-embarq.
    &endif.

    EMPTY TEMP-TABLE tt-embarque-imp.
    EMPTY TEMP-TABLE tt-desp-embarque-n.
    EMPTY TEMP-TABLE tt-invoice-emb-imp-n.

	RUN piInitPersistentsDesembarque.

    bloco_1:
    do transaction on error undo, leave:
        run validaParametrosDesembarqueParcial (input table tt-embarque-novo,
                                                input table tt-ordens-nac,
                                                output table tt-bo-erro).

        if can-find(first tt-bo-erro) THEN
            RETURN "NOK":U.

	    /* Evita validações repetidas */
		FIND FIRST tt-embarque-novo NO-ERROR.
        RUN piCarregaCacheEmbarque (INPUT tt-embarque-novo.c-cod-estabel,
                                    INPUT tt-embarque-novo.c-embarque).

        /*frank - 02/02/2004-*/
        ASSIGN l-primeiro = YES.

        FOR EACH tt-ordens-nac:
            RUN validadesvinordensembarque (input tt-embarque-novo.c-cod-estabel,
                                            input tt-embarque-novo.c-embarque,
                                            input tt-ordens-nac.numero-ordem,
                                            input tt-ordens-nac.parcela,
                                            input tt-ordens-nac.quantidade - tt-ordens-nac.de-quantidade-nac,
                                            input tt-embarque-novo.da-nova-entrega,
                                            output table tt-bo-erro).

            if can-find(first tt-bo-erro) THEN
                RETURN "NOK":U.
        END.

        IF i-pais-impto-usuario <> 1 THEN DO:

            FOR EACH tt-ordens-nac:

                IF trim(SUBSTRING(tt-ordens-nac.char-1,1,20)) <> '' THEN
                DO:
                    FOR FIRST ordem-compra no-lock
                        WHERE ordem-compra.numero-ordem = tt-ordens-nac.numero-ordem,
                        FIRST pedido-drb NO-LOCK
                        WHERE pedido-drb.cod-estabel = tt-ordens-nac.cod-estabel
                        AND pedido-drb.nr-ato-concessorio = trim(SUBSTRING(tt-ordens-nac.char-1,1,20)),
                        FIRST pedido-drb-item NO-LOCK
                        WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                        AND pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                        AND pedido-drb-item.it-codigo     = ordem-compra.it-codigo:

                        if pedido-drb-item.qtd-sdo-item < tt-ordens-nac.quantidade - tt-ordens-nac.de-quantidade-nac then do:
                            assign i-seq-erro = i-seq-erro + 1.
                            create tt-bo-erro.
                            {utp/ut-liter.i Quantidade_informada_para_o_item___ * L}
                                assign c-return-value = trim(return-value) + " " + pedido-drb-item.it-codigo.
                            {utp/ut-liter.i a_quantidade_do_saldo_no_Drawback * L}
                                assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
                            run utp/ut-msgs.p (input "msg",
                                               input 25495,
                                               input tt-bo-erro.parametros).

                            assign tt-bo-erro.i-sequen     = i-seq-erro
                                tt-bo-erro.cd-erro      = 25495
                                tt-bo-erro.mensagem     = return-value.
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END.

        /*
        ** Desvincula ordens/quantidades que nÆo serÆo nacionalizadas do embarque original
        */

            for each tt-ordens-nac:
                run desvinculaOrdensEmbarque (input tt-embarque-novo.c-cod-estabel,
                                              input tt-embarque-novo.c-embarque,
                                              input tt-ordens-nac.numero-ordem,
                                              input tt-ordens-nac.parcela,
                                              input tt-ordens-nac.quantidade - tt-ordens-nac.de-quantidade-nac,
                                              input tt-embarque-novo.da-nova-entrega,
                                              output table tt-bo-erro).
                if can-find(first tt-bo-erro) THEN
					RETURN "NOK":U.

            end.

            /*
            **  Atualiza Valor da Taxa siscomex das Ordens e Despesa do Embarque
            */

            RUN piAtualizaTaxaSiscomex (INPUT NO,
                                        INPUT tt-embarque-novo.c-embarque).

        /*
        ** Cria novo embarque
        */

        find embarque-imp
            where embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
              and embarque-imp.embarque    = tt-embarque-novo.c-embarque no-lock no-error.

        create tt-embarque-imp.
        assign tt-embarque-imp.cod-estabel   = tt-embarque-novo.c-cod-estabel
               tt-embarque-imp.embarque      = tt-embarque-novo.c-embarque-novo
               tt-embarque-imp.contabilizado = no.
        buffer-copy embarque-imp except embarque-imp.cod-estabel
                                        embarque-imp.embarque
                                        embarque-imp.contabilizado
                                        to tt-embarque-imp.

        &If '{&BF_MAT_VERSAO_EMS}' >= '2.062' &THEN

                FIND FIRST eq-disponib-embarq
                   WHERE eq-disponib-embarq.cod-estab-embarq = tt-embarque-novo.c-cod-estabel
                     AND eq-disponib-embarq.embarque         = tt-embarque-novo.c-embarque NO-LOCK NO-ERROR.
                IF AVAIL eq-disponib-embarq THEN DO:
                    CREATE b-eq-disponib-embarq.
                    BUFFER-COPY eq-disponib-embarq EXCEPT cod-estab-embarq embarque TO b-eq-disponib-embarq.
                    ASSIGN b-eq-disponib-embarq.cod-estab-embarq = tt-embarque-novo.c-cod-estabel
                           b-eq-disponib-embarq.embarque         = tt-embarque-novo.c-embarque-novo.
                END.
        &endif
        {imp/im0045.i50}
        {cdp/cd4300.i4 "yes" embarque-imp.char-1}
        {imp/im0045.i51 "yes"}
        assign c-embarque-orig-i50 = tt-embarque-novo.c-embarque.
        {imp/im0045.i51 "no"}
        {cdp/cd4300.i4 "no" tt-embarque-imp.char-1}


        IF i-pais-impto-usuario <> 1 THEN
             ASSIGN tt-embarque-imp.log-embarq-transf-draw = tt-embarque-novo.log-embarq-transf-draw.

        /*Grava o embarque principal no novo embarque(Embarque da Nota MÆe) */
        &if '{&bf_mat_versao_ems}' < '2.09' &then
           ASSIGN OVERLAY(tt-embarque-imp.char-1,61,20) = tt-embarque-novo.c-embarque-inicial.
        &ELSE
           ASSIGN tt-embarque-imp.cod-embarq-inicial-quebra = tt-embarque-novo.c-embarque-inicial.
        &ENDIF
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

        run validateCreate in h-bocx220 (input table tt-embarque-imp,
                                         output table tt-bo-erro,
                                         output pr-embarque-imp).
        delete procedure h-bocx220.
        if can-find(first tt-bo-erro) then
            UNDO, RETURN "NOK":U.

        /*
        ** Copia relacionamentos do embarque original para o novo embarque
        */
        run copiaRelacionamentosEmbarque.

        if can-find(first tt-bo-erro) then
            UNDO, RETURN "NOK":U.
        /*
        ** Elimina Relacionamentos do Embarque Original
        */
        run eliminaRelacEmbarque (input tt-embarque-novo.c-cod-estabel,
                                  input tt-embarque-novo.c-embarque).
        if can-find(first tt-bo-erro) then
            UNDO, RETURN "NOK":U.

        /*
        ** Atualiza Integra‡Æo quando ocorreu Contabiliza‡Æo do Material em Trƒnsito
        */
        run atualizaMaterialTransito.
        if can-find(first tt-bo-erro WHERE tt-bo-erro.errorsubtype = "error":U) then
            UNDO, RETURN "NOK":U.

    END.

    /*************** chamada upc *******************/

    FOR EACH tt-epc  WHERE tt-epc.cod-event = "AfterDesembarque" :
       DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterDesembarque":U
           tt-epc.cod-parameter = "tt-embarque-novo":U
           tt-epc.val-parameter = string(BUFFER tt-embarque-novo:HANDLE).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AfterDesembarque":U
           tt-epc.cod-parameter = "tt-bo-erro":U
           tt-epc.val-parameter = string(BUFFER tt-bo-erro:HANDLE).

    {include/i-epc201.i "AfterDesembarque"}

    if can-find(first tt-bo-erro WHERE tt-bo-erro.errorsubtype = "error":U) then
       UNDO, RETURN "NOK":U.

    /**************fim da chamada UPC*************/

    RETURN "OK":U.
end procedure.


PROCEDURE copiaRelacionamentosEmbarque:
/*------------------------------------------------------------------------------
  Purpose: Copia relacionamentos do embarque antigo para o novo embarque criado.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
    DEF BUFFER b-historico-embarque   FOR historico-embarque.
    DEF BUFFER b-decl-hist-embarq-imp FOR decl-hist-embarq-imp.

    DEF VAR i-sequencia-che  AS INTEGER NO-UNDO.
    DEF VAR i-seq-nacionaliz AS INTEGER NO-UNDO.
    DEF VAR i-dias-dif       AS INTEGER NO-UNDO.
    DEF VAR l-pto-efetivo    AS LOGICAL NO-UNDO.

    DEF VAR de-resid-orig-bruto  AS DECIMAL FORMAT '>>>>,>>9.9999999999':U NO-UNDO.
    DEF VAR de-resid-orig-liqui  AS DECIMAL FORMAT '>>>>,>>9.9999999999':U NO-UNDO.
    DEF VAR de-resid-atua-bruto  AS DECIMAL FORMAT '>>>>,>>9.9999999999':U NO-UNDO.
    DEF VAR de-resid-atua-liqui  AS DECIMAL FORMAT '>>>>,>>9.9999999999':U NO-UNDO.

    find first tt-embarque-novo no-error.

    FOR EACH ordens-embarque EXCLUSIVE-LOCK
       WHERE ordens-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
         AND ordens-embarque.embarque    = tt-embarque-novo.c-embarque:

        ASSIGN ordens-embarque.log-ja-gravad = NO
               ordens-embarque.cod-natur-of  = ""
               de-resid-atua-bruto           = de-resid-atua-bruto + ordens-embarque.peso-bruto
               de-resid-atua-liqui           = de-resid-atua-liqui + ordens-embarque.peso-liquido.
    END.

    /* Reforma Tribut ria */
    IF  l-nt2024002
    AND NOT l-possui-di-duimp THEN DO:
        FOR EACH bf-ordens-embarque-trib EXCLUSIVE-LOCK
            WHERE bf-ordens-embarque-trib.cod-estabel  = tt-embarque-novo.c-cod-estabel
            AND   bf-ordens-embarque-trib.embarque     = tt-embarque-novo.c-embarque:
            DELETE bf-ordens-embarque-trib.
        END.
    END.

    /* Ordens de embarque */
    FOR EACH tt-ordens-nac WHERE tt-ordens-nac.cod-estabel = tt-embarque-novo.c-cod-estabel
                           AND   tt-ordens-nac.embarque    = tt-embarque-novo.c-embarque
                           BREAK BY tt-ordens-nac.cod-estabel
                                 BY tt-ordens-nac.embarque:

        ASSIGN de-resid-orig-bruto = de-resid-orig-bruto + tt-ordens-nac.peso-bruto
               de-resid-orig-liqui = de-resid-orig-liqui + tt-ordens-nac.peso-liquido.

        IF tt-ordens-nac.quantidade    <= tt-ordens-nac.de-quantidade-nac
        OR tt-ordens-nac.de-quant-nova <= 0 THEN
            NEXT.

        CREATE ordens-embarque.
        ASSIGN ordens-embarque.embarque   = tt-embarque-novo.c-embarque-novo
               ordens-embarque.quantidade = tt-ordens-nac.de-quant-nova
               ordens-embarque.qt-do-forn = tt-ordens-nac.de-qt-fn-nova
               ordens-embarque.parcela    = tt-ordens-nac.i-parcela-nova.

        BUFFER-COPY tt-ordens-nac EXCEPT embarque
                                         quantidade
                                         qt-do-forn
                                         parcela
                                         de-quantidade-nac
                                         i-parcela-nova
                                         r-rowid
                                         log-ja-gravad
                                         cod-natur-of
            TO ordens-embarque.

        /* Reforma Tribut ria */
        IF  l-nt2024002
        AND l-possui-di-duimp THEN DO:

            FOR EACH bf-ordens-embarque-trib WHERE bf-ordens-embarque-trib.cod-estabel  = tt-ordens-nac.cod-estabel
                                             AND   bf-ordens-embarque-trib.embarque     = tt-ordens-nac.embarque
                                             AND   bf-ordens-embarque-trib.numero-ordem = tt-ordens-nac.numero-ordem
                                             AND   bf-ordens-embarque-trib.parcela      = tt-ordens-nac.parcela
                                             NO-LOCK:
                CREATE ordens-embarque-trib.
                BUFFER-COPY bf-ordens-embarque-trib EXCEPT embarque parcela
                    TO ordens-embarque-trib
                    ASSIGN ordens-embarque-trib.embarque = tt-embarque-novo.c-embarque-novo
                           ordens-embarque-trib.parcela  = tt-ordens-nac.i-parcela-nova.
            END.
        END.

        IF tt-ordens-nac.peso-liquido <> 0 THEN
            ASSIGN ordens-embarque.peso-liquido = (tt-ordens-nac.peso-liquido * (tt-ordens-nac.de-quant-nova * 100 / tt-ordens-nac.quantidade)) / 100.
        IF tt-ordens-nac.peso-bruto <> 0 THEN
            ASSIGN ordens-embarque.peso-bruto   = (tt-ordens-nac.peso-bruto   * (tt-ordens-nac.de-quant-nova * 100 / tt-ordens-nac.quantidade)) / 100.

        /* Include para tratar re-planejamento das parcelas no MRP  */
        {cxbo/bocx220f.i2}

        ASSIGN de-resid-atua-bruto = de-resid-atua-bruto + ordens-embarque.peso-bruto
               de-resid-atua-liqui = de-resid-atua-liqui + ordens-embarque.peso-liquido.


        IF  LAST-OF(tt-ordens-nac.embarque) THEN DO:
            /* Se houver res¡duo entre o Embarque Original e o Novo Embarque, lan‡ar a diferen‡a na £ltima ordem de embarque do novo embarque*/

            IF de-resid-orig-bruto <> de-resid-atua-bruto THEN DO:
                 ASSIGN ordens-embarque.peso-bruto = ordens-embarque.peso-bruto + (de-resid-orig-bruto - de-resid-atua-bruto).
            END.
            IF de-resid-orig-liqui <> de-resid-atua-liqui THEN DO:
                 ASSIGN ordens-embarque.peso-liquido = ordens-embarque.peso-liquido + (de-resid-orig-liqui - de-resid-atua-liqui).
            END.
        END.
    END.

    /*
    ** Hist¢rico do embarque
    */
    FOR FIRST historico-embarque FIELDS(cod-itiner cod-estabel embarque)
        WHERE historico-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
          AND historico-embarque.embarque    = tt-embarque-novo.c-embarque NO-LOCK:
    END.
    FOR FIRST itinerario FIELDS(pto-chegada pto-desembarque)
        WHERE itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK:
    END.

    FOR FIRST embarque-imp FIELDS(cdn-pto-chegad cdn-pto-desembar) NO-LOCK
        WHERE embarque-imp.cod-estabel = historico-embarque.cod-estabel
          AND embarque-imp.embarque = historico-embarque.embarque: END.

    FOR FIRST historico-embarque FIELDS(dt-ult-previsao)
        WHERE historico-embarque.cod-estabel   = tt-embarque-novo.c-cod-estabel
          AND historico-embarque.embarque      = tt-embarque-novo.c-embarque
          AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-chegad NO-LOCK:
    END.

    ASSIGN i-dias-dif = tt-embarque-novo.da-nova-entrega - historico-embarque.dt-ult-previsao.

    IF i-pais-impto-usuario <> 1 THEN DO:
        FOR FIRST historico-embarque FIELDS(sequencia)
            WHERE historico-embarque.cod-estabel   = tt-embarque-novo.c-cod-estabel
              AND historico-embarque.embarque      = tt-embarque-novo.c-embarque
              AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK:
        END.

        ASSIGN i-seq-nacionaliz = historico-embarque.sequencia.
    END.

    FOR EACH historico-embarque
       WHERE historico-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
         AND historico-embarque.embarque    = tt-embarque-novo.c-embarque NO-LOCK:

        CREATE b-historico-embarque.
        ASSIGN b-historico-embarque.embarque = tt-embarque-novo.c-embarque-novo.

        IF historico-embarque.dt-efetiva <> ? THEN
            ASSIGN b-historico-embarque.dt-ult-previsao = historico-embarque.dt-ult-previsao.
        ELSE
            ASSIGN b-historico-embarque.dt-ult-previsao = historico-embarque.dt-ult-previsao + i-dias-dif.

        IF i-pais-impto-usuario <> 1 AND historico-embarque.sequencia > i-seq-nacionaliz THEN DO:

            BUFFER-COPY historico-embarque EXCEPT historico-embarque.embarque
                                                  historico-embarque.dt-ult-previsao
                                                  historico-embarque.dt-efetiva
                TO b-historico-embarque.

        END.
        ELSE DO:

            BUFFER-COPY historico-embarque EXCEPT historico-embarque.embarque
                                                  historico-embarque.dt-ult-previsao
                TO b-historico-embarque.
        END.
    END.

    /* Despesas do Embarque */
    FOR EACH tt-desp-embarque-n
        WHERE tt-desp-embarque-n.cod-estabel = tt-embarque-novo.c-cod-estabel
          AND tt-desp-embarque-n.embarque    = tt-embarque-novo.c-embarque:

        CREATE desp-embarque.
        ASSIGN desp-embarque.embarque = tt-embarque-novo.c-embarque-novo.

        BUFFER-COPY tt-desp-embarque-n EXCEPT embarque r-rowid TO desp-embarque.
    END.

    RUN piAtualizaTaxaSiscomex (INPUT YES, INPUT tt-embarque-novo.c-embarque-novo).

    {ccp/cc9019.i50}
    /*
    ** Faturas do Embarque
    */
    IF CAN-FIND(FIRST tt-invoice-emb-imp-n) THEN DO:

        /* Acha ponto de controle base */
        FOR FIRST ordens-embarque FIELDS(numero-ordem)
            WHERE ordens-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
              AND ordens-embarque.embarque    = tt-embarque-novo.c-embarque-novo NO-LOCK:

            FOR FIRST cotacao-item FIELDS(char-1)
                WHERE cotacao-item.numero-ordem = ordens-embarque.numero-ordem
                  AND cotacao-item.cot-aprovada NO-LOCK:

                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
            END.
        END.

        FOR FIRST historico-embarque FIELDS(dt-efetiva)
            WHERE historico-embarque.cod-estabel   = tt-embarque-novo.c-cod-estabel
              AND historico-embarque.embarque      = tt-embarque-novo.c-embarque
              AND historico-embarque.cod-pto-contr = i-cod-pto-contr-i50 NO-LOCK:
        END.

        IF AVAIL historico-embarque AND historico-embarque.dt-efetiva <> ? THEN
            ASSIGN l-pto-efetivo = YES.
        ELSE
            ASSIGN l-pto-efetivo = NO.

        FOR EACH tt-invoice-emb-imp-n
           WHERE tt-invoice-emb-imp-n.cod-estabel = tt-embarque-novo.c-cod-estabel
             AND tt-invoice-emb-imp-n.embarque    = tt-embarque-novo.c-embarque:

            FOR FIRST invoice-emb-imp
                WHERE invoice-emb-imp.cod-estabel = tt-invoice-emb-imp-n.cod-estabel
                  AND invoice-emb-imp.embarque    = tt-embarque-novo.c-embarque-novo
                  AND invoice-emb-imp.nr-invoice  = tt-embarque-novo.c-fatura
                  AND invoice-emb-imp.parcela     = tt-invoice-emb-imp-n.parcela EXCLUSIVE-LOCK:
            END.
            IF NOT AVAIL invoice-emb-imp THEN DO:
                CREATE invoice-emb-imp.
                ASSIGN invoice-emb-imp.embarque   = tt-embarque-novo.c-embarque-novo
                       invoice-emb-imp.nr-invoice = tt-embarque-novo.c-fatura.
            END.

            /* Rec lculo data de vencimento caso ponto de controle base nÆo esteja efetivado */
            IF l-pto-efetivo THEN
                ASSIGN invoice-emb-imp.dt-vencim = tt-invoice-emb-imp-n.dt-vencim.
            ELSE
                ASSIGN invoice-emb-imp.dt-vencim = tt-invoice-emb-imp-n.dt-vencim + i-dias-dif.

            BUFFER-COPY tt-invoice-emb-imp-n EXCEPT embarque nr-invoice dt-vencim r-rowid TO invoice-emb-imp NO-ERROR.

            /* Verifica se existe um erro progress na criacao da tabela */
            IF ERROR-STATUS:ERROR THEN DO:
               ASSIGN l-erro-fatura = YES.
               LEAVE.
            END.
        END.
    END.

    IF l-erro-fatura THEN DO:

        RUN criaTTBoErro (INPUT 29475, INPUT "").
        RETURN "NOK":U.
    END.

    /* Declara‡Æo/Comunica‡Æo do Emitente */
    FOR EACH decl-hist-embarq-imp
       WHERE decl-hist-embarq-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
         AND decl-hist-embarq-imp.embarque    = tt-embarque-novo.c-embarque NO-LOCK:

        CREATE b-decl-hist-embarq-imp.
        ASSIGN b-decl-hist-embarq-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
               b-decl-hist-embarq-imp.embarque    = tt-embarque-novo.c-embarque-novo.

        BUFFER-COPY decl-hist-embarq-imp EXCEPT decl-hist-embarq-imp.cod-estabel decl-hist-embarq-imp.embarque TO b-decl-hist-embarq-imp.
    END.

    /* Ponto UPC */
    EMPTY TEMP-TABLE tt-epc.

    {include/i-epc200.i2 &CodEvent='"AfterCopyRelationships"'
                         &CodParameter='"embarque-imp.cod-estabel"'
                         &ValueParameter="tt-embarque-novo.c-cod-estabel"}

    {include/i-epc200.i2 &CodEvent='"AfterCopyRelationships"'
                         &CodParameter='"embarque-imp.embarque"'
                         &ValueParameter="tt-embarque-novo.c-embarque"}

    {include/i-epc200.i2 &CodEvent='"AfterCopyRelationships"'
                         &CodParameter='"embarque-imp.embarque-novo"'
                         &ValueParameter="tt-embarque-novo.c-embarque-novo"}

    {include/i-epc201.i "AfterCopyRelationships"}


    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validadesvinordensembarque:

    def input parameter p-cod-estabel  like estabelec.cod-estabel     no-undo.
    def input parameter p-embarque     like embarque-imp.embarque     no-undo.
    def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
    def input parameter p-parcela      as   integer                   no-undo.
    def input parameter p-quantidade   like prazo-compra.quantidade   no-undo.
    /*
    ** Data considerada para a parcela a ser criada com o saldo nÆo embarcado
    */
    def input parameter p-data-base    as   date                      no-undo.
    def output parameter table for tt-bo-erro.

        def var de-quant-saldo   like prazo-compra.quantidade    no-undo.
        def var de-quant-orig    like prazo-compra.quantidade    no-undo.
        def var de-qt-fn-orig    like prazo-compra.quantidade    no-undo.


        if p-quantidade = 0 then
            RETURN "OK":U.

        /*
        ** Verifica‡Æo Situa‡Æo da Ordem de Compra
        */

        IF i-pais-impto-usuario = 1 THEN DO:
            find ordem-compra
                where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.
            if avail ordem-compra then do:

                FIND FIRST prazo-compra WHERE
                    prazo-compra.numero-ordem = ordem-compra.numero-ordem AND
                    prazo-compra.parcela      = p-parcela NO-LOCK NO-ERROR.

                IF AVAIL prazo-compra THEN DO:
                    &if defined(bf-mat-comex) &then
                    if prazo-compra.situacao = "R":U or
                        prazo-compra.situacao = "E":U then do:
                    &else
                    if prazo-compra.situacao = 4 or
                        prazo-compra.situacao = 6 then do:
                    &endif

                        {utp/ut-liter.i Situa‡Æo_da_ordem: * L}
                        assign c-return = trim(return-value) + " " + string(p-numero-ordem).
                        assign i-seq-erro = i-seq-erro + 1.
                        create tt-bo-erro.
                        {utp/ut-liter.i desvincula‡Æo_do_embarque_ * L}.
                        assign tt-bo-erro.parametros = c-return + "~~" + trim(return-value) + " " + p-embarque.
                        run utp/ut-msgs.p (input "msg",
                                           input 7355,
                                           input tt-bo-erro.parametros).
                        assign tt-bo-erro.i-sequen     = i-seq-erro
                               tt-bo-erro.cd-erro      = 7355
                               tt-bo-erro.mensagem     = return-value.
                        return "NOK":U.
                    END.
                END.
            END.
        END.


        for first ordens-embarque fields (quantidade nr-proc-imp qt-do-forn)
            where ordens-embarque.cod-estabel  = p-cod-estabel
              and ordens-embarque.embarque     = p-embarque
              and ordens-embarque.numero-ordem = p-numero-ordem
              and ordens-embarque.parcela      = p-parcela no-lock:
        end.

        assign de-quant-orig  = ordens-embarque.quantidade
               de-qt-fn-orig  = ordens-embarque.qt-do-forn
               de-quant-saldo = ordens-embarque.quantidade - p-quantidade.

        /*
        ** Valida quantidade informada
        */
        if p-quantidade > ordens-embarque.quantidade then do:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            {utp/ut-liter.i Quantidade_informada * L}
            assign c-return-value = trim(return-value).
            {utp/ut-liter.i quantidade_da_ordem_de_embarque * L}
            assign tt-bo-erro.parametros = c-return-value + "~~" + trim(return-value).
            run utp/ut-msgs.p (input "msg",
                               input 25495,
                               input tt-bo-erro.parametros).
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 25495
                   tt-bo-erro.mensagem     = return-value.
            RETURN "NOK":U.
        end.

        RETURN "OK":U.
END PROCEDURE.


procedure desvinculaOrdensEmbarque:
    /*
    ** Desvincula determinada quantidade de uma ordem do embarque
    */
    def input parameter p-cod-estabel  like estabelec.cod-estabel     no-undo.
    def input parameter p-embarque     like embarque-imp.embarque     no-undo.
    def input parameter p-numero-ordem like ordem-compra.numero-ordem no-undo.
    def input parameter p-parcela      as   integer                   no-undo.
    def input parameter p-quantidade   like prazo-compra.quantidade   no-undo.
    /*
    ** Data considerada para a parcela a ser criada com o saldo nÆo embarcado
    */
    def input parameter p-data-base    as   date                      no-undo.
    def output parameter table for tt-bo-erro.


    def var de-valor-parcela like cotacao-item.preco-unit    no-undo.
    def var de-fator-invoice as   decimal                    no-undo.
    def var de-total-invoice like cotacao-item.preco-unit    no-undo.
    def var i-mo-codigo      like moeda.mo-codigo            no-undo.
    def var i-nova-parcela   like prazo-compra.parcela       no-undo.
    def var de-quant-saldo   like prazo-compra.quantidade    no-undo.
    def var de-quant-orig    like prazo-compra.quantidade    no-undo.
    def var de-qt-fn-orig    like prazo-compra.quantidade    no-undo.
    def var de-val-desp-novo like desp-embarque.val-desp     no-undo.
    def var de-val-aux-inv   like desp-embarque.val-desp     no-undo.
    def var de-val-ord-inv   like cotacao-item.preco-unit    no-undo.
    def var de-val-tot-inv   like invoice-emb-imp.vl-invoice no-undo.
    def var c-return-value   as   char                       no-undo.
    def var c-return         as   char                       no-undo.
    def var de-qt-do-forn    like ordens-embarque.qt-do-forn no-undo.
    def var de-p-quantidade-forn like ordens-embarque.qt-do-forn no-undo.
    def var l-cria           as   logical                    no-undo.
    def var de-preco-unit    like cotacao-item.preco-unit    no-undo.
    DEF VAR de-val-desp-mo-aux LIKE desp-embarque.val-desp   NO-UNDO.
    DEF VAR l-possui-nota    AS LOGICAL                      NO-UNDO.
    DEF VAR l-permite-quebra AS LOGICAL                      NO-UNDO.
    DEF BUFFER b-ordem-compra FOR ordem-compra.
    DEF BUFFER b-prazo-compra FOR prazo-compra.

    def var i-sequencia-nac as integer no-undo.

    if p-quantidade = 0 then
        RETURN "OK":U.

    find ordem-compra
        where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.

    for first ordens-embarque fields (quantidade nr-proc-imp qt-do-forn char-1)
        where ordens-embarque.cod-estabel  = p-cod-estabel
          and ordens-embarque.embarque     = p-embarque
          and ordens-embarque.numero-ordem = p-numero-ordem
          and ordens-embarque.parcela      = p-parcela no-lock:
    end.

    if ordens-embarque.quantidade = p-quantidade then
        assign l-cria = no.
    else
        assign l-cria = yes.

    assign de-quant-orig  = ordens-embarque.quantidade
           de-qt-fn-orig  = ordens-embarque.qt-do-forn
           de-quant-saldo = ordens-embarque.quantidade - p-quantidade.

    for first item-fornec fields(fator-conver num-casa-dec)
        where item-fornec.it-codigo    = ordem-compra.it-codigo
          and item-fornec.cod-emitente = ordem-compra.cod-emitente no-lock:
    end.
    if avail item-fornec then do:
        assign de-p-quantidade-forn = p-quantidade
                                      * (item-fornec.fator-conver /
                                         if item-fornec.num-casa-dec = 0 then 1
                                         else exp(10,item-fornec.num-casa-dec)).
        assign de-val-ord-inv       = ((ordem-compra.pre-unit-for * 100) /
                                       (100 + ordem-compra.aliquota-ipi)) * de-p-quantidade-forn.
    end.
    else
        assign de-val-ord-inv       = ordem-compra.pre-unit-for * p-quantidade.


    IF NOT VALID-HANDLE(h-im0091)
    OR NOT VALID-HANDLE(h-bocx295)
    OR NOT VALID-HANDLE(h-boin356aa) THEN
        RUN piInitPersistentsDesembarque.

    IF (g-cdn-pto-desembar = 0 AND i-pais-impto-usuario <> 1) THEN
        RUN piCarregaCacheEmbarque (INPUT p-cod-estabel, INPUT p-embarque).

    IF i-pais-impto-usuario <> 1 THEN
        ASSIGN l-possui-nota    = g-possui-nota-emb
               l-permite-quebra = g-permite-quebra-emb.


    IF i-pais-impto-usuario <> 1 /* Brasil */
		AND g-possui-nota-emb AND AVAIL ordens-embarque
		AND (SUBSTRING(ordens-embarque.char-1,1,20) <> "" /* DIT */)
		THEN DO:
			FOR EACH desp-embarque
			   where desp-embarque.cod-estabel = p-cod-estabel
				 and desp-embarque.embarque    = p-embarque NO-LOCK:

            find FIRST tt-desp-embarque-n
                 where tt-desp-embarque-n.cod-estabel = p-cod-estabel
                   and tt-desp-embarque-n.embarque    = p-embarque
                   and tt-desp-embarque-n.cod-desp    = desp-embarque.cod-desp no-error.
            if not avail tt-desp-embarque-n THEN
                create tt-desp-embarque-n.

            buffer-copy desp-embarque except val-desp
                     to tt-desp-embarque-n.
        END.
    END.
    ELSE DO:
        IF l-primeiro THEN DO:
            /*
            ** Gera temp-tables para rateio das despesas de importa‡Æo
            */
            RUN setaValorinicial      IN h-im0091 (INPUT TODAY, INPUT p-cod-estabel).
			RUN rateioAcompanhamento  IN h-im0091 (INPUT p-cod-estabel, INPUT p-embarque,
												  OUTPUT TABLE tt-desp-rateio).
			RUN getTTdesp-totais      IN h-im0091 (OUTPUT TABLE tt-desp-totais).
			RUN getTTordens-totais    IN h-im0091 (OUTPUT TABLE tt-ordens-totais).
			RUN getTTbo-erro          IN h-im0091 (OUTPUT TABLE tt-bo-erro).
			ASSIGN l-primeiro = NO.
            if can-find(first tt-bo-erro) then
                RETURN "NOK":U.
        END.
        /*
        ** Retira valor proporcional das despesas de importa‡Æo
        */

        for first historico-embarque fields(cod-itiner cod-estabel embarque)
            where historico-embarque.cod-estabel = p-cod-estabel
              and historico-embarque.embarque    = p-embarque no-lock:
        end.
        for first itinerario fields(pto-chegada pto-desembarque)
            where itinerario.cod-itiner = historico-embarque.cod-itiner no-lock:
        end.

        for first embarque-imp fields(cdn-pto-desembar) no-lock
            where embarque-imp.cod-estabel = historico-embarque.cod-estabel
              and embarque-imp.embarque = historico-embarque.embarque: end.

        for each tt-desp-rateio
            where tt-desp-rateio.numero-ordem = p-numero-ordem
              and tt-desp-rateio.parcela      = p-parcela:

            FIND tt-ordens-totais
                WHERE tt-ordens-totais.numero-ordem = p-numero-ordem
                  AND tt-ordens-totais.parcela      = p-parcela NO-ERROR.
            find desp-embarque
                where desp-embarque.cod-estabel = p-cod-estabel
                  and desp-embarque.embarque    = p-embarque
                  and desp-embarque.cod-desp    = tt-desp-rateio.cod-desp exclusive-lock no-error.
            if avail desp-embarque then do:

                for first desp-imp fields(tipo)
                    where desp-imp.cod-desp = tt-desp-rateio.cod-desp no-lock:
                end.

                for first historico-embarque fields(sequencia)
                    where historico-embarque.cod-estabel   = p-cod-estabel
                      and historico-embarque.embarque      = p-embarque
                      and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar no-lock:
                    assign i-sequencia-nac = historico-embarque.sequencia.
                end.

                for first historico-embarque fields(sequencia)
                    where historico-embarque.cod-estabel   = tt-embarque-novo.c-cod-estabel
                      and historico-embarque.embarque      = tt-embarque-novo.c-embarque
                      and historico-embarque.cod-pto-contr = desp-embarque.cod-pto-contr no-lock:
                end.

                if historico-embarque.sequencia >= g-seq-nac THEN
                    IF desp-imp.tipo = 1 THEN
                        ASSIGN de-val-desp-mo-aux = tt-desp-rateio.val-desp-mo.
                    ELSE
                        ASSIGN de-val-desp-mo-aux     = (tt-desp-rateio.val-desp-mo
                                                      * p-quantidade)
                                                      / tt-ordens-totais.quantidade
                               desp-embarque.val-desp = desp-embarque.val-desp
                                                      - de-val-desp-mo-aux. /*(tt-desp-rateio.val-desp-unit-mo * p-quantidade)*/
                ELSE
                    ASSIGN de-val-desp-mo-aux     = (tt-desp-rateio.val-desp-mo
                                                  * p-quantidade)
                                                  / tt-ordens-totais.quantidade
                           desp-embarque.val-desp = desp-embarque.val-desp
                                                  - de-val-desp-mo-aux. /*(tt-desp-rateio.val-desp-unit-mo * p-quantidade)*/

                if desp-embarque.cod-emitente-desp = ordem-compra.cod-emitente then
                    assign de-val-ord-inv = de-val-ord-inv + (de-val-desp-mo-aux). /*tt-desp-rateio.val-desp-unit-mo * p-quantidade*/

                find tt-desp-embarque-n
                    where tt-desp-embarque-n.cod-estabel = p-cod-estabel
                      and tt-desp-embarque-n.embarque    = p-embarque
                      and tt-desp-embarque-n.cod-desp    = desp-embarque.cod-desp no-error.
                if not avail tt-desp-embarque-n THEN
                    create tt-desp-embarque-n.

                assign tt-desp-embarque-n.val-desp = tt-desp-embarque-n.val-desp
                                                   + de-val-desp-mo-aux /*tt-desp-rateio.val-desp-unit-mo * p-quantidade*/.

                buffer-copy desp-embarque except val-desp
                to tt-desp-embarque-n.
            end.
        end.
    END.

    /*
    ** Atualiza valor das faturas
    */
    for first invoice-emb-imp fields (mo-codigo)
        where invoice-emb-imp.cod-estabel = p-cod-estabel
          and invoice-emb-imp.embarque    = p-embarque no-lock:
    end.
    if avail invoice-emb-imp then do:
        if invoice-emb-imp.mo-codigo <> ordem-compra.mo-codigo then do:
            run cdp/cd0812.p (input ordem-compra.mo-codigo,
                              input invoice-emb-imp.mo-codigo,
                              input de-val-ord-inv,
                              input today,
                              output de-val-ord-inv).
        end.

        RUN calculaValorInvoice IN h-bocx295 (INPUT p-cod-estabel,
                                      INPUT p-embarque,
                                      OUTPUT de-total-invoice,
                                      OUTPUT i-mo-codigo,
                                      OUTPUT TABLE tt-bo-erro).

        if can-find(first tt-bo-erro) then
            RETURN "NOK":U.

        assign de-fator-invoice = de-val-ord-inv / de-total-invoice.

        for each invoice-emb-imp fields(vl-invoice mo-codigo nr-invoice parcela)
            where invoice-emb-imp.cod-estabel = p-cod-estabel
              and invoice-emb-imp.embarque    = p-embarque exclusive-lock:
            assign de-valor-parcela = de-fator-invoice * invoice-emb-imp.vl-invoice.
            if invoice-emb-imp.mo-codigo <> i-mo-codigo then
                run cdp/cd0812.p (input i-mo-codigo,
                                  input invoice-emb-imp.mo-codigo,
                                  input de-valor-parcela,
                                  input today,
                                  output de-valor-parcela).
            assign invoice-emb-imp.vl-invoice = invoice-emb-imp.vl-invoice - de-valor-parcela.

            find tt-invoice-emb-imp-n
                where tt-invoice-emb-imp-n.cod-estabel = p-cod-estabel
                  and tt-invoice-emb-imp-n.embarque    = p-embarque
                  and tt-invoice-emb-imp-n.nr-invoice  = invoice-emb-imp.nr-invoice
                  and tt-invoice-emb-imp-n.parcela     = invoice-emb-imp.parcela no-error.
            if not avail tt-invoice-emb-imp-n then
                create tt-invoice-emb-imp-n.
            assign tt-invoice-emb-imp-n.vl-invoice = tt-invoice-emb-imp-n.vl-invoice + de-valor-parcela.
            buffer-copy invoice-emb-imp except vl-invoice
                to tt-invoice-emb-imp-n.
        end.
    end.

    /*
    ** Atualiza quantidade da ordem de embarque
    */
    for first item-fornec fields(fator-conver num-casa-dec)
        where item-fornec.it-codigo    = ordem-compra.it-codigo
          and item-fornec.cod-emitente = ordem-compra.cod-emitente no-lock:
    end.

    for first ordens-embarque
        fields (quantidade nr-proc-imp qt-do-forn
                &if '{&bf_mat_versao_ems}' < '2.05' &then
                 char-2
                &else
                 peso-liquido peso-bruto
                &endif)
        where ordens-embarque.cod-estabel  = p-cod-estabel
          and ordens-embarque.embarque     = p-embarque
          and ordens-embarque.numero-ordem = p-numero-ordem
          and ordens-embarque.parcela      = p-parcela exclusive-lock:

        &if '{&bf_mat_versao_ems}' < '2.05' &then
         ASSIGN OVERLAY(ordens-embarque.char-2,09,17) = STRING( ( DEC(SUBSTR(ordens-embarque.char-2,09,17)) *
                                                       (de-quant-saldo * 100 / ordens-embarque.quantidade) ) / 100 , "999,999,999.99999")
                OVERLAY(ordens-embarque.char-2,26,17) = STRING( ( DEC(SUBSTR(ordens-embarque.char-2,26,17)) *
                                                       (de-quant-saldo * 100 / ordens-embarque.quantidade) ) / 100 , "999,999,999.99999").
        &else
         ASSIGN ordens-embarque.peso-liquido = (tt-ordens-nac.peso-liquido * (de-quant-saldo * 100 / ordens-embarque.quantidade)) / 100
                ordens-embarque.peso-bruto   = (tt-ordens-nac.peso-bruto   * (de-quant-saldo * 100 / ordens-embarque.quantidade)) / 100.
        &endif

        assign ordens-embarque.quantidade = de-quant-saldo.

        if avail item-fornec then
            assign ordens-embarque.qt-do-forn = ordens-embarque.quantidade
                                              * (item-fornec.fator-conver /
                                                 if item-fornec.num-casa-dec = 0 then 1
                                                 else exp(10,item-fornec.num-casa-dec)).
        else
            assign ordens-embarque.qt-do-forn = ordens-embarque.quantidade.
        assign de-qt-do-forn = ordens-embarque.qt-do-forn.
    end.

    if avail ordens-embarque and ordens-embarque.quantidade = 0 then do:
        /* Reforma Tribut ria */
        IF l-nt2024002 THEN DO:
            FOR EACH ordens-embarque-trib WHERE ordens-embarque-trib.cod-estabel  = ordens-embarque.cod-estabel
                                          AND   ordens-embarque-trib.embarque     = ordens-embarque.embarque
                                          AND   ordens-embarque-trib.numero-ordem = ordens-embarque.numero-ordem
                                          AND   ordens-embarque-trib.parcela      = ordens-embarque.parcela
                                          EXCLUSIVE-LOCK:
                DELETE ordens-embarque-trib.
            END.
        END.

        delete ordens-embarque.
    end.

    /*
    ** Cria nova parcela de compra com a quantidade que nÆo foi embarcada
    */
    if l-cria then do:
        /* h-boin356aa já está aberto antes do loop */
		RUN cria-nova-parcela IN h-boin356aa (INPUT p-cod-estabel,
											  INPUT p-numero-ordem,
											  INPUT p-parcela,
											  INPUT p-embarque,
											  INPUT de-quant-saldo,
											  INPUT p-quantidade,
											  INPUT p-data-base,
											  INPUT "parcela":U).
        for last prazo-compra fields(parcela)
            where prazo-compra.numero-ordem = p-numero-ordem no-lock:
        end.
    end.
    else do:
        for first prazo-compra fields(parcela)
            where prazo-compra.numero-ordem = p-numero-ordem
              and prazo-compra.parcela      = p-parcela no-lock:
        end.
    end.

    /**** Chamada EPC enviando a ordem embarcada e a nÊo embarcada ***********/

    IF INDEX(PROVERSION,"webspeed") = 0 THEN DO:
         if (search("cxbo/bocx220epc.p") <> ? OR search("cxbo/bocx220epc.r") <> ?)  then do:
                find  tt-ordens-nac
                where tt-ordens-nac.cod-estabel  = p-cod-estabel
                  and tt-ordens-nac.embarque     = p-embarque
                  and tt-ordens-nac.numero-ordem = p-numero-ordem
                  and tt-ordens-nac.parcela      = p-parcela no-lock no-error.

                if avail prazo-compra and tt-ordens-nac.de-quantidade-nac > 0 then do:
                   find current prazo-compra no-lock no-error.
                   run cxbo/bocx220epc.p (INPUT l-cria,
                                          INPUT prazo-compra.numero-ordem,
                                          INPUT prazo-compra.parcela,
                                          INPUT p-numero-ordem,
                                          INPUT p-parcela).
                end.
        end.
    END.
    /************************************************************************/

    find tt-ordens-nac
        where tt-ordens-nac.cod-estabel  = p-cod-estabel
          and tt-ordens-nac.embarque     = p-embarque
          and tt-ordens-nac.numero-ordem = p-numero-ordem
          and tt-ordens-nac.parcela      = p-parcela no-lock no-error.
    assign tt-ordens-nac.i-parcela-nova = prazo-compra.parcela
           tt-ordens-nac.de-quant-nova  = p-quantidade
           tt-ordens-nac.de-qt-fn-nova  = de-qt-fn-orig - de-qt-do-forn.

    IF i-pais-impto-usuario <> 1 THEN DO:
        FIND FIRST b-ordem-compra EXCLUSIVE-LOCK
            where b-ordem-compra.numero-ordem = p-numero-ordem  no-error.

        IF AVAIL b-ordem-compra THEN
            ASSIGN b-ordem-compra.situacao  = 2.


        if l-cria then
        DO:
            for last b-prazo-compra fields(situacao)
                where b-prazo-compra.numero-ordem = p-numero-ordem EXCLUSIVE-LOCK:
            END.
        END.
        else
        DO:
            for first b-prazo-compra fields(situacao)
                where b-prazo-compra.numero-ordem = p-numero-ordem
                and b-prazo-compra.parcela      = p-parcela EXCLUSIVE-LOCK:
            END.
        END.

        IF AVAIL b-prazo-compra THEN
            ASSIGN b-prazo-compra.situacao = 2.

    END.

    RETURN "OK":U.
end procedure.


procedure eliminaRelacEmbarque:
    /*
    ** Verifica se ainda existe ordem para o embarque
    */
    def input parameter p-cod-estabel like estabelec.cod-estabel no-undo.
    def input parameter p-embarque    like embarque-imp.embarque no-undo.

    /*
    ** Quando nÆo existe mais ordens vinculadas ao embarque elimina todos os relacionamentos
    */
    if not can-find(first ordens-embarque
                        where ordens-embarque.cod-estabel = p-cod-estabel
                          and ordens-embarque.embarque    = p-embarque) then do:
        {imp/im0045.i50}
        assign c-meio-transporte = fill(" ",20).

        find embarque-imp
           where embarque-imp.cod-estabel = p-cod-estabel
             and embarque-imp.embarque    = p-embarque exclusive-lock no-error.
        if avail embarque-imp then do:
            {imp/im0045.i51 no}
            {cdp/cd4300.i4  no embarque-imp.char-1}
        end.

        for each decl-hist-embarq-imp
            where decl-hist-embarq-imp.cod-estabel = p-cod-estabel
              and decl-hist-embarq-imp.embarque    = p-embarque exclusive-lock:
            delete decl-hist-embarq-imp.
        end.

        for each historico-embarque
            where historico-embarque.cod-estabel = p-cod-estabel
              and historico-embarque.embarque    = p-embarque exclusive-lock:
            delete historico-embarque.
        end.

        for each desp-embarque
            where desp-embarque.cod-estabel = p-cod-estabel
              and desp-embarque.embarque    = p-embarque exclusive-lock:
            delete desp-embarque.
        end.

        for each invoice-emb-imp
            where invoice-emb-imp.cod-estabel = p-cod-estabel
              and invoice-emb-imp.embarque    = p-embarque exclusive-lock:
            delete invoice-emb-imp.
        end.

    end.

    RETURN "OK":U.
end procedure.


procedure atualizaMaterialTransito:
    /*
    ** Atualiza t¡tulo gerado no contas a pagar quando embarque j  foi contabilizado
    */

    &if defined(bf-mat-comex) &then
    &else

    def var de-embarque-orig like ordem-compra.preco-fornec no-undo.
    def var de-novo-embarque like ordem-compra.preco-fornec no-undo.
    def var de-fator         as   decimal                   no-undo.
    def var da-data-efetiva  as   date                      no-undo.
    def var l-ems50          as   logical                   no-undo.

    DEF VAR h-boad260        AS   HANDLE                    NO-UNDO.
    DEF VAR c-return         AS   CHAR                      NO-UNDO.
    DEF VAR de-valor-saldo   AS   DECIMAL                   NO-UNDO.

  &IF DEFINED(bf-mat-comex) &THEN
  &ELSE

    FIND FIRST param-global     NO-LOCK NO-ERROR.
    find first tt-embarque-novo no-error.

    find embarque-imp
        where embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
          and embarque-imp.embarque    = tt-embarque-novo.c-embarque no-lock no-error.

    if not embarque-imp.contabilizado then
        RETURN "OK":U.

    /*
    ** Acerta Valor do t¡tulo gerado para o Embarque Original
    */
    if can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
       and funcao.ativo = yes
       and funcao.log-1 = yes) then
        assign l-ems50 = yes.

    /*
    ** Verifica se o t¡tulo do material em trƒnsito j  foi baixado
    */
    FIND param-imp
        WHERE param-imp.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.
    FIND FIRST ordens-embarque
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK NO-ERROR.
    FIND ordem-compra
        WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
    ASSIGN c-esp-tit-transit = param-imp.esp-tit-transit.

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"cod-estabel"'
                         &ValueParameter="embarque-imp.cod-estabel"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"embarque"'
                         &ValueParameter="embarque-imp.embarque"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"cod-fornec"'
                         &ValueParameter="string(ordem-compra.cod-emitente)"}

    {include/i-epc200.i2 &CodEvent='"AlteraEspecieTitulo"'
                         &CodParameter='"esp-tit-transit"'
                         &ValueParameter="c-esp-tit-transit"}
    /*Include i-epc201.i: Chamada do programa de EPC */
    {include/i-epc201.i "AlteraEspecieTitulo"}

    if c-nom-prog-dpc-mg97  <> "" or
       c-nom-prog-appc-mg97 <> "" or
       c-nom-prog-upc-mg97  <> "" then do:

        find first tt-epc where
                   tt-epc.cod-event = "AlteraEspecieTitulo" and
                   tt-epc.cod-parameter = "esp-tit-transit"
                   no-error.
        if avail tt-epc then
           assign c-esp-tit-transit = tt-epc.val-parameter.

        for each tt-epc:
            delete tt-epc.
        end.
    end.

    IF NOT l-ems50 THEN DO:
        RUN adbo/boad260.p PERSISTENT SET h-boad260.
        RUN findCodigo IN h-boad260 (INPUT i-ep-codigo-usuario,
                                     INPUT ordem-compra.cod-emitente,
                                     INPUT embarque-imp.cod-estabel,
                                     INPUT c-esp-tit-transit,
                                     INPUT "",
                                     INPUT embarque-imp.embarque,
                                     INPUT "1",
                                     OUTPUT c-return).
        IF c-return = "" THEN
            RUN getDecField IN h-boad260 (INPUT "valor-saldo":U, OUTPUT de-valor-saldo).
        DELETE PROCEDURE h-boad260.
        ASSIGN h-boad260 = ?.
        IF de-valor-saldo = 0 THEN DO:
            FIND embarque-imp
                WHERE embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
                  AND embarque-imp.embarque    = tt-embarque-novo.c-embarque-novo EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN DO:
                ASSIGN embarque-imp.contabilizado = YES.
                RETURN "OK":U.
            END.
        END.
    END.
    ELSE DO:
        RUN pi-conecta-ems50 (INPUT YES).
        create tt_tit_ap_vl_compdo.
        assign tt_tit_ap_vl_compdo.tta_cod_estab           = embarque-imp.cod-estabel
               tt_tit_ap_vl_compdo.tta_cdn_fornecedor      = ordem-compra.cod-emitente
               tt_tit_ap_vl_compdo.tta_cod_espec_docto     = c-esp-tit-transit
               tt_tit_ap_vl_compdo.tta_cod_ser_docto       = ""
               tt_tit_ap_vl_compdo.tta_cod_tit_ap          = embarque-imp.embarque
               tt_tit_ap_vl_compdo.tta_cod_parcela         = "1"
               tt_tit_ap_vl_compdo.tta_val_comprtdo_tit_ap = 0
               tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap      = 0.
        run prgfin/apb/apb908za.py (input 1,
                                    input-output table tt_tit_ap_vl_compdo).
        find first tt_tit_ap_vl_compdo no-lock no-error.
        if  avail tt_tit_ap_vl_compdo and
            tt_tit_ap_vl_compdo.ttv_log_existe_tit = yes AND
            tt_tit_ap_vl_compdo.tta_val_sdo_tit_ap = 0 THEN DO:
            FIND embarque-imp
                WHERE embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
                  AND embarque-imp.embarque    = tt-embarque-novo.c-embarque-novo EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN
                ASSIGN embarque-imp.contabilizado = YES.
            RETURN "OK":U.
        END.
        RUN pi-conecta-ems50 (INPUT NO).
    END.

    /*
    ** Calcula valor total do material do embarque original
    */
    for each ordens-embarque fields (numero-ordem qt-do-forn)
        where ordens-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
          and ordens-embarque.embarque    = tt-embarque-novo.c-embarque no-lock:
        for first ordem-compra fields (pre-unit-for mo-codigo cod-emitente aliquota-ipi)
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem
              and ordem-compra.situacao     = 2 no-lock:
            assign de-embarque-orig = de-embarque-orig
                                    + (ordens-embarque.qt-do-forn * ( (ordem-compra.pre-unit-for * 100) / (100 + ordem-compra.aliquota-ipi) ) ).
        end.
    end.

    /*
    ** Calcula valor total do material do novo embarque
    */
    for each ordens-embarque fields (numero-ordem qt-do-forn)
        where ordens-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
          and ordens-embarque.embarque    = tt-embarque-novo.c-embarque-novo no-lock:
        for first ordem-compra fields (pre-unit-for mo-codigo cod-emitente aliquota-ipi)
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem
              and ordem-compra.situacao     = 2 no-lock:
            assign de-novo-embarque = de-novo-embarque
                                   + (ordens-embarque.qt-do-forn * ( (ordem-compra.pre-unit-for * 100) / (100 + ordem-compra.aliquota-ipi) ) ).
        end.
    end.

    /*
    ** Calcula fator de propor‡Æo em rela‡Æo ao embarque antigo
    */
    assign de-fator = de-embarque-orig / (de-embarque-orig + de-novo-embarque).

    /*
    ** Ajusta valor do titulo
    */
    if not l-ems50 then
        run imp/im9011a.p (input tt-embarque-novo.c-cod-estabel,
                           input tt-embarque-novo.c-embarque,
                           input de-fator,
                           output table tt-bo-erro).
    else
        run imp/im9024a.p (input tt-embarque-novo.c-cod-estabel,
                           input tt-embarque-novo.c-embarque,
                           input de-fator,
                           output table tt-bo-erro).

    if can-find(first tt-bo-erro WHERE tt-bo-erro.errorSubtype = "Error":U) then
        return "NOK":U.

    /*
    ** Procura data da efetiva‡Æo do Ponto de incoterm
    */
    for first embarque-imp fields(cod-incoterm)
        where embarque-imp.cod-estabel = tt-embarque-novo.c-cod-estabel
          and embarque-imp.embarque    = tt-embarque-novo.c-embarque no-lock:
    end.
    for each historico-embarque fields (cod-itiner cod-pto-contr dt-efetiva)
        where historico-embarque.cod-estabel = tt-embarque-novo.c-cod-estabel
          and historico-embarque.embarque    = tt-embarque-novo.c-embarque no-lock:
        for first incoterm-itiner fields (cod-pto-contr)
            where incoterm-itiner.cod-itiner    = historico-embarque.cod-itiner
              and incoterm-itiner.cod-pto-contr = historico-embarque.cod-pto-contr
              and incoterm-itiner.cod-incoterm  = embarque-imp.cod-incoterm no-lock:
            assign da-data-efetiva = historico-embarque.dt-efetiva.
        end.
    end.

    /*
    ** Cria‡Æo do T¡tulo para o Novo Embarque
    */
    RUN imp/im0080.p (input  v_cod_grp_usuar_lst,
                      input  v_cod_usuar_corren,
                      input  da-data-efetiva,
                      input  da-data-efetiva,
                      input  i-ep-codigo-usuario,
                      input  tt-embarque-novo.c-cod-estabel,
                      input  tt-embarque-novo.c-embarque-novo,
                      input  TODAY, /*data para contabiliza‡ä materia em transito, para embarque com periodos ja fechados.*/
                      input  YES, /* Considera Desembarque Parcial? */
                      input-output table tt-retorno-erro,
                      output table tt-embarque-contab).

    FOR EACH tt-retorno-erro:
        assign i-seq-erro = i-seq-erro + 1.

        create tt-bo-erro.
        run utp/ut-msgs.p (input "msg":U,
                           input tt-retorno-erro.cod-erro,
                           input "").
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = tt-retorno-erro.cod-erro
               tt-bo-erro.mensagem     = tt-retorno-erro.mensagem.

        return "NOK":U.
    END.

    &endif

  &ENDIF

    RETURN "OK":U.
end procedure.

PROCEDURE load-tt-embarque-contab:
    &IF DEFINED(bf-mat-comex) &THEN
    &else
        DEF OUTPUT PARAMETER TABLE FOR tt-embarque-contab.
    &ENDIF

END PROCEDURE.

PROCEDURE verificanotamaeatual:

    DEF INPUT PARAMETER p-cod-estabel  LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF INPUT PARAMETER p-embarque     LIKE embarque-imp.embarque    NO-UNDO.
    DEF OUTPUT PARAMETER p-not-atualizado  AS LOGICAL INITIAL NO NO-UNDO.

    ASSIGN p-not-atualizado = NO.

    FOR FIRST ordens-embarque FIELDS (numero-ordem) WHERE
              ordens-embarque.cod-estabel = p-cod-estabel AND
              ordens-embarque.embarque    = p-embarque    NO-LOCK:
    END.
    IF NOT AVAIL ordens-embarque THEN LEAVE.

    FOR FIRST ordem-compra FIELDS(cod-emitente) WHERE
              ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
    END.

    IF NOT AVAIL ordem-compra THEN LEAVE.


    for each docum-est fields (char-1 docum-est.ap-atual &if '{&bf_mat_versao_ems}' >= '2.06' &then docum-est.idi-nf-simples-remes &else char-2 &endif) where
             docum-est.cod-emitente = ordem-compra.cod-emitente no-lock:

             if docum-est.char-1 = "" then next.

             if trim(substring(docum-est.char-1,1,20)) = p-embarque then do:

                 &if '{&bf_mat_versao_ems}' >= '2.06' &then
                 IF docum-est.idi-nf-simples-remes = 1 THEN DO:
                 &else
                 IF trim(substring(docum-est.char-2,101,1)) = "1" THEN DO:
                 &endif
                    IF NOT docum-est.ap-atual THEN
                        ASSIGN p-not-atualizado = YES.

                 END.
             end.
    end.


END PROCEDURE.



PROCEDURE setEmpresa:
    /*
    ** Seta empresa caso execu‡Æo seja WEB
    */
&IF "{&mguni_version}" >= "2.071" &THEN
    DEF INPUT PARAMETER p-ep-codigo LIKE empresa.ep-codigo NO-UNDO.
&ELSE
    DEF INPUT PARAMETER p-ep-codigo AS INTEGER NO-UNDO.
&ENDIF

  &IF DEFINED(bf-mat-comex) &THEN
  &ELSE

    ASSIGN i-ep-codigo-usuario = p-ep-codigo.

  &ENDIF

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-ver-embarque-possui-nota:
    /***************************************************************
     Verifica se o embarque possui nota, se possuir e a nota nÆo
     for de simples remessa nÆo deve permitir Desembarque Parcial
    ****************************************************************/
    DEFINE INPUT  PARAM pc-cod-estabel       AS CHARACTER                        NO-UNDO.
    DEFINE INPUT  PARAM pc-embarque          LIKE embarque-imp.embarque          NO-UNDO.
    DEFINE INPUT  PARAM pi-num-di-embarque   AS INTEGER                          NO-UNDO.
    DEFINE INPUT  PARAM pd-cdd-siscomex-dts  LIKE decla-import.cdd-siscomex-dts  NO-UNDO.
    DEFINE OUTPUT PARAM pl-possui-nota       AS LOGICAL                          NO-UNDO.
    DEFINE OUTPUT PARAM pl-permite-quebra    AS LOGICAL                          NO-UNDO.

    ASSIGN pl-permite-quebra = YES
           pl-possui-nota    = NO
           l-possui-di-duimp = NO.

    FIND FIRST ordens-embarque WHERE
               ordens-embarque.cod-estabel = pc-cod-estabel AND
               ordens-embarque.embarque    = pc-embarque    NO-LOCK NO-ERROR.
    IF NOT AVAIL ordens-embarque THEN LEAVE.

    FIND FIRST ordem-compra WHERE
               ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
    IF NOT AVAIL ordem-compra THEN LEAVE.

    IF pi-num-di-embarque <> 0 THEN DO:
        ASSIGN l-possui-di-duimp = YES.

        FOR FIRST decla-import FIELDS(cod-di-siscomex num-di-ems)
                               WHERE decla-import.num-di-ems       = pi-num-di-embarque
                               AND   decla-import.cdd-siscomex-dts = pd-cdd-siscomex-dts
                               NO-LOCK:
        END.

        IF AVAIL decla-import THEN DO:
            IF CAN-FIND(FIRST docum-est
                        WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                          AND docum-est.cod-estabel                  = ordem-compra.cod-estabel
                          AND docum-est.declaracao-import            = decla-import.cod-di-siscomex
                          AND TRIM(substring(docum-est.char-1,1,20)) = pc-embarque
                          AND docum-est.idi-nf-simples-remes > 2) THEN
                ASSIGN pl-permite-quebra = NO.
        END.
        ELSE
            ASSIGN pl-permite-quebra = NO.

        IF CAN-FIND(FIRST docum-est
                WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                  AND docum-est.cod-estabel                  = ordem-compra.cod-estabel
                  AND TRIM(substring(docum-est.char-1,1,20)) = pc-embarque) THEN
        ASSIGN pl-possui-nota = YES.
    END.
    ELSE DO:
        IF i-pais-impto-usuario = 1 /* Brasil */ OR TRIM(SUBSTRING(ordens-embarque.char-1,1,20)) = "" THEN DO:
            IF CAN-FIND(FIRST docum-est
                        WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                          AND docum-est.cod-estabel                  = ordem-compra.cod-estabel
                          AND TRIM(substring(docum-est.char-1,1,20)) = pc-embarque) THEN DO:
                ASSIGN pl-possui-nota = YES.

                IF CAN-FIND(FIRST docum-est
                            WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                              AND docum-est.cod-estabel                  = ordem-compra.cod-estabel
                              AND TRIM(substring(docum-est.char-1,1,20)) = pc-embarque
                              AND docum-est.idi-nf-simples-remes > 2) THEN
                    ASSIGN pl-permite-quebra = NO.
            END.
        END.
        ELSE DO:
            IF CAN-FIND(FIRST docum-est
                        WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                          AND docum-est.cod-estabel                  = ordem-compra.cod-estabel
                          AND TRIM(substring(docum-est.char-1,1,20)) = pc-embarque) THEN DO:
                ASSIGN pl-possui-nota = YES.

                IF NOT CAN-FIND(FIRST docum-est
                                WHERE docum-est.cod-emitente                 = ordem-compra.cod-emitente
                                AND   docum-est.cod-estabel                  = ordem-compra.cod-estabel
                                AND   TRIM(substring(docum-est.char-1,1,20)) = pc-embarque
                                AND   docum-est.ce-atual) THEN
                    ASSIGN pl-permite-quebra = NO.
            END.
        END.

        IF  i-pais-impto-usuario <> 1 THEN DO:
            IF  CAN-FIND(FIRST docum-est
                         WHERE docum-est.cod-emitente              = ordem-compra.cod-emitente
                           AND docum-est.cod-estabel               = ordem-compra.cod-estabel
                           AND TRIM(SUBSTR(docum-est.char-1,1,20)) = pc-embarque
                           AND docum-est.idi-nf-simples-remes      = 2) THEN
                ASSIGN pl-permite-quebra = NO.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
/*
** Procedure pi-conecta-ems50
*/
&IF DEFINED(bf-mat-comex) &THEN
&ELSE

{rep/re1005.i14}

&ENDIF

PROCEDURE piAtualizaTaxaSiscomex:
    DEF INPUT PARAM l-novo         AS LOGICAL NO-UNDO.
    DEF INPUT PARAM c-embarque   LIKE ordens-embarque.embarque NO-UNDO.

    ASSIGN c-nr-adicao-vld = "".
    FOR EACH tt-ordens-nac:
        &if '{&bf_mat_versao_ems}' >= '2.04' &then
         &if '{&bf_mat_versao_ems}' >= '2.07' &then
          IF  CAN-DO(c-nr-adicao-vld, STRING(tt-ordens-nac.num-adic,"9999")) THEN
              NEXT.

          ASSIGN c-nr-adicao-vld = c-nr-adicao-vld + STRING(tt-ordens-nac.num-adic,"9999") + ','.
         &else
          IF  CAN-DO(c-nr-adicao-vld, STRING(SUBSTR(tt-ordens-nac.char-1, 60, 4),"9999")) THEN
              NEXT.

          ASSIGN c-nr-adicao-vld = c-nr-adicao-vld + STRING(SUBSTR(tt-ordens-nac.char-1, 60, 4),"9999") + ','.
         &endif
        &endif

        FIND FIRST param-imp NO-LOCK
             WHERE param-imp.cod-estabel = tt-ordens-nac.cod-estabel NO-ERROR.

        ASSIGN de-tot-qtde = 0
               de-tot-qtde-nova = 0
               de-val-tx-siscomex = 0.

        &if '{&bf_mat_versao_ems}' >= '2.04' &then
         &if '{&bf_mat_versao_ems}' >= '2.07' &then
          IF  param-imp.log-tax-siscomex
          AND tt-ordens-nac.val-tax-siscomex > 0 THEN DO:
              FOR EACH b-tt-ordens-nac
                 WHERE b-tt-ordens-nac.cod-estabel = tt-ordens-nac.cod-estabel
                   AND b-tt-ordens-nac.embarque    = tt-ordens-nac.embarque
                   AND b-tt-ordens-nac.num-adic    = tt-ordens-nac.num-adic:
                  ASSIGN de-tot-qtde      = de-tot-qtde      + b-tt-ordens-nac.quantidade
                         de-tot-qtde-nova = de-tot-qtde-nova + b-tt-ordens-nac.de-quant-nova.
              END.
              IF  de-tot-qtde = de-tot-qtde-nova THEN
                  NEXT.

              IF  l-novo THEN
                  ASSIGN de-val-tx-siscomex = ((de-tot-qtde-nova * 100 / de-tot-qtde) * tt-ordens-nac.val-tax-siscomex) / 100.
              ELSE
                  ASSIGN de-val-tx-siscomex = tt-ordens-nac.val-tax-siscomex -
                                            ((de-tot-qtde-nova * 100 / de-tot-qtde) * tt-ordens-nac.val-tax-siscomex) / 100.

              /* Atualiza todas as ordens do embarque que tenham a mesma adi‡Æo */
              FOR EACH ordens-embarque EXCLUSIVE-LOCK
                 WHERE ordens-embarque.cod-estabel = tt-ordens-nac.cod-estabel
                   AND ordens-embarque.embarque    = c-embarque
                   AND ordens-embarque.num-adic    = tt-ordens-nac.num-adic:
                   ASSIGN ordens-embarque.val-tax-siscomex = de-val-tx-siscomex.
              END.
          END.
         &else
          IF  INT(SUBSTR(param-imp.char-1, 105, 1)) = 1
          AND INT(SUBSTR(tt-ordens-nac.char-1, 64, 16)) > 0 THEN DO:
              FOR EACH b-tt-ordens-nac
                 WHERE b-tt-ordens-nac.cod-estabel = tt-ordens-nac.cod-estabel
                   AND b-tt-ordens-nac.embarque    = tt-ordens-nac.embarque
                   AND SUBSTR(b-tt-ordens-nac.char-1, 60, 4) = SUBSTR(tt-ordens-nac.char-1, 60, 4):
                  ASSIGN de-tot-qtde      = de-tot-qtde      + b-tt-ordens-nac.quantidade
                         de-tot-qtde-nova = de-tot-qtde-nova + b-tt-ordens-nac.de-quant-nova.
              END.

              IF  de-tot-qtde = de-tot-qtde-nova THEN
                  NEXT.

              ASSIGN de-val-tx-siscomex = DEC(SUBSTR(tt-ordens-nac.char-1, 64, 16)) / 100000.
              IF l-novo THEN
                  ASSIGN de-val-tx-siscomex = ((de-tot-qtde-nova * 100 / de-tot-qtde) * de-val-tx-siscomex) / 100.
              ELSE
                  ASSIGN de-val-tx-siscomex = de-val-tx-siscomex -
                                            ((de-tot-qtde-nova * 100 / de-tot-qtde) * de-val-tx-siscomex) / 100.

              /* Atualiza todas as ordens do embarque que tenham a mesma adi‡Æo */
              FOR EACH ordens-embarque EXCLUSIVE-LOCK
                 WHERE ordens-embarque.cod-estabel = tt-ordens-nac.cod-estabel
                   AND ordens-embarque.embarque    = c-embarque
                   AND SUBSTR(ordens-embarque.char-1, 60, 4) = SUBSTR(tt-ordens-nac.char-1, 60, 4):
                  ASSIGN OVERLAY(ordens-embarque.char-1, 64, 16) = string(de-val-tx-siscomex * 100000).
              END.
          END.
         &endif
        &endif
    END.

    /* Sumariza as taxas para atualizar as despesas de embarque */
    FOR FIRST tt-ordens-nac:
		FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = tt-ordens-nac.cod-estabel
         NO-ERROR.
        ASSIGN de-val-tx-siscomex = 0.
        &if '{&bf_mat_versao_ems}' >= '2.04' &then
         &if '{&bf_mat_versao_ems}' >= '2.07' &then
          IF  param-imp.log-tax-siscomex THEN DO:
              FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel = tt-ordens-nac.cod-estabel
                   AND ordens-embarque.embarque    = c-embarque
                  BREAK BY ordens-embarque.num-adic:
                  IF  FIRST-OF(ordens-embarque.num-adic) THEN
                      ASSIGN de-val-tx-siscomex = de-val-tx-siscomex + ordens-embarque.val-tax-siscomex.
              END.
          END.
         &else
          IF  INT(SUBSTR(param-imp.char-1, 105, 1)) = 1 THEN DO:
              ASSIGN c-nr-adicao-vld = "".

              FOR EACH ordens-embarque NO-LOCK
                 WHERE ordens-embarque.cod-estabel = tt-ordens-nac.cod-estabel
                   AND ordens-embarque.embarque    = c-embarque:

                  IF  CAN-DO(c-nr-adicao-vld, STRING(SUBSTR(ordens-embarque.char-1, 60, 4),"9999")) THEN
                      NEXT.

                  ASSIGN de-val-tx-siscomex = de-val-tx-siscomex + DEC(SUBSTR(ordens-embarque.char-1, 64, 16)) / 100000
                         c-nr-adicao-vld = c-nr-adicao-vld + STRING(SUBSTR(ordens-embarque.char-1, 60, 4),"9999") + ','.
              END.
          END.
         &endif
        &endif

        IF NOT VALID-HANDLE(h-bocx310) THEN DO:
			RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.
			ASSIGN l-own-bocx310 = YES.
		END.

		RUN atzDespesaEmbarque IN h-bocx310 (INPUT tt-ordens-nac.cod-estabel,
											 INPUT c-embarque,
											 INPUT de-val-tx-siscomex,
											 OUTPUT TABLE tt-bo-erro).
        IF  CAN-FIND(FIRST tt-bo-erro) THEN
        UNDO, RETURN "NOK":U.
    END.
END.

PROCEDURE criaTTBoErro:
/*------------------------------------------------------------------------------
  Purpose: Criacao da temp-table de erros retornada na execucao das procedures
  Parameters: INPUT - pi-cod-error (integer) - codigo do erro
              INPUT - pc-parameters (character) - parametros da mensagem de erro
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cod-error  AS INTEGER    NO-UNDO.
    DEFINE INPUT PARAMETER pc-parameters AS CHARACTER  NO-UNDO.

    ASSIGN i-seq-erro = i-seq-erro + 1.

    RUN utp/ut-msgs.p (INPUT "msg":U, INPUT pi-cod-error, INPUT pc-parameters).

    CREATE tt-bo-erro.
    ASSIGN tt-bo-erro.i-sequen   = i-seq-erro
           tt-bo-erro.cd-erro    = pi-cod-error
           tt-bo-erro.mensagem   = RETURN-VALUE
           tt-bo-erro.parametros = pc-parameters
           tt-bo-erro.errortype  = "EMS":U.

    RUN utp/ut-msgs.p (INPUT "help":U, INPUT pi-cod-error, INPUT pc-parameters).

    ASSIGN tt-bo-erro.errorhelp = RETURN-VALUE.

    RUN utp/ut-msgs.p (INPUT "CodType":U, INPUT pi-cod-error, INPUT pc-parameters).

    CASE RETURN-VALUE:
        WHEN '1':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "ERROR":U.
        WHEN '2':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "WARNING":U.
        WHEN '3':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "QUESTION":U.
        WHEN '4':U THEN
            ASSIGN tt-bo-erro.errorsubtype = "INFORMATION":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* BOCX220F.P  */

