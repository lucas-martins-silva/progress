/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0301RP 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0301rp MBH}
&ENDIF

/*******************************************************************************
**
**  Programa: BH0301.P - Transferencia para Banco Historico - IND - PRODU€ÇO
**
*******************************************************************************/

{utp/ut-glob.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.

{bhp/bh9800.i1}
{bhp/bh0301.i} /*  ttErrosConexao */

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field da-per-corte     as date format "99/99/9999".

def new shared temp-table tt-estat-modul
    field i-sequencia as integer format 99
    field c-tabela    as char format "x(25)"
    field c-modulo    as char format "x(45)"
    field i-modulo    as integer
    index i-sequencia is unique i-sequencia ascending.

def new shared temp-table tt-erro-his
    field nr-ord-produ LIKE movind.ord-prod.nr-ord-produ.

/*def temp-table tt-estat
 *     field i-emp    like empresa.ep-codigo
 *     field c-mod    as char format "x(02)"
 *     field da-per   as date format "99/99/9999"
 *     field i-reg    as int format ">>>,>>9". */   

def new shared var i-registro  as integer.
def new shared var da-corte as date format "99/99/9999" init "01/01/1900".
def new shared var h-acomp    as handle no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def new shared var i-empresa  LIKE empresa.ep-codigo no-undo.
&ELSE
def new shared var i-empresa  as integer no-undo.
&ENDIF

/*def var c-modulo    as char format "x(16)".*/
def var c-opcao     as character no-undo.

def var c-parcela   like mov-ap.parcela no-undo.
def var c-cod-esp   like mov-ap.cod-esp no-undo.

def var l-trans   as logical initial no no-undo.
def var l-ok      as logical initial no no-undo.
def var l-ignora  as logical initial no no-undo.
def var l-entrou  as logical no-undo.
DEF VAR l-valida  AS LOGICAL INITIAL YES NO-UNDO.
DEF VAR c-valida  AS CHARACTER FORMAT "x(100)" NO-UNDO.

def var i-cont         as INTEGER NO-UNDO.
def var i-nr-docto     like mov-ap.nr-docto no-undo.
def var i-per-corrente as integer no-undo.
def var i-ano-corrente as integer no-undo.
def var c-param        as char no-undo format "x(12)".
def var c-per          as char no-undo format "x(22)".
def var c-imp          as char no-undo format "x(12)".
def var c-usu          as char no-undo format "x(12)".
def var c-dest         as char no-undo format "x(12)".
def var c-dest2        as char no-undo format "x(12)".
def var c-erro         as char no-undo.
def var i-nr-tab       as INTEGER NO-UNDO.
def var i-total        as INTEGER NO-UNDO.
DEF VAR c-total        AS CHARACTER  NO-UNDO.
DEF VAR c-modulo       AS CHARACTER  NO-UNDO.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

form c-modulo space(02)
     tt-estat-modul.c-tabela
     tt-estat-modul.c-modulo
     space(02)
     tt-estat-modul.i-modulo
     with no-box width 132 64 down frame f-modul stream-io.

form c-total AT 54
     i-total AT 83 NO-LABEL
     with frame f-tot width 132 stream-io side-labels.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-tot:HANDLE).


{utp/ut-liter.i M¢dulo * r}
assign c-modulo:label in frame f-modul = trim(return-value).

{utp/ut-liter.i Tabela * r}
assign tt-estat-modul.c-tabela:label in frame f-modul = trim(return-value).

{utp/ut-liter.i Descri‡Æo * r}
assign tt-estat-modul.c-modulo:label in frame f-modul = trim(return-value).

{utp/ut-liter.i Registros * r}
assign tt-estat-modul.i-modulo:label in frame f-modul = trim(return-value).

{utp/ut-liter.i Total_de_Registros * r}
assign c-total:label in frame f-tot = trim(return-value).

/*form space(40)
 *      tt-estat.i-emp
 *      space(04)
 *      c-modulo
 *      space(04)
 *      tt-estat.da-per
 *      space(04)
 *      tt-estat.i-reg
 *      with no-box width 132 64 down frame f-estat stream-io.
 * 
 * {utp/ut-liter.i Empresa * r}
 * assign tt-estat.i-emp:label in frame f-estat = trim(return-value).
 * 
 * {utp/ut-liter.i Per¡odo * r}
 * assign tt-estat.da-per:label in frame f-estat = trim(return-value).
 * 
 * {utp/ut-liter.i Registro * r}
 * assign tt-estat.i-reg:label in frame f-estat = trim(return-value).
 * 
 * {utp/ut-liter.i M¢dulo * r}
 * assign c-modulo:label in frame f-estat = trim(return-value).*/

{include/i-rpvar.i}

assign c-programa = "BH0301"
       c-modulo   = "CP".

{utp/ut-liter.i Estat¡sticas_Export._p/_Banco_Hist¢rico_Produ‡Æo * c}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Bancos_Hist¢ricos * c}
assign c-sistema = trim(return-value).

run utp/ut-trfrrp.p (input frame f-modul:handle).
{include/i-rpcab.i}

assign da-corte = tt-param.da-per-corte.

if  da-corte > da-iniper-x then do:
    run utp/ut-msgs.p(input "msg",
                      input 6956,
                      input return-value).
    ASSIGN l-valida = NO
           c-valida = "*** Erro Nr: 6956 - " + RETURN-VALUE.
    /*return error.*/
end.

/* Verifica estrutura do banco */

find first param-global
    no-lock no-error.
if  not avail param-global
or  not param-global.modulo-bh then do:
    {utp/ut-liter.i "Estrutura_nÆo_permite_hist¢rico" * R}
    run utp/ut-msgs.p(input "msg",
                      input 8035,
                      input return-value).
    ASSIGN l-valida = NO.

    IF c-valida <> "" THEN
        ASSIGN c-valida = c-valida + ",".

    ASSIGN c-valida = c-valida + "*** Erro Nr: 8035 - " + RETURN-VALUE.
    /*return error.*/
end.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Bancos_Hist¢ricos *}
run pi-inicializar in h-acomp (input Return-value).
run pi-seta-tipo in h-acomp (input 1).

assign c-empresa = param-global.grupo
       i-empresa = param-global.empresa-prin.

{utp/ut-liter.i  Conectando_Hist¢rico_-_Produ‡Æo *}
run pi-acompanhar in h-acomp (input Return-value).
/*run bhp/bh9800.p (input 2,
 *                   input "hisind",
 *                   output l-trans,
 *                   output l-ok).
 * if l-trans and not l-ok then do:
 *    run pi-finalizar in h-acomp.
 *    return error.
 * end.*/
    
IF l-valida THEN DO:

    /*Conecta Bancos históricos*/
    RUN btb/btb962za.p (INPUT i-empresa,
                        INPUT i-empresa,
                        INPUT 3, /* Transferir */
                        INPUT 1, /* Conectar */
                        INPUT "", /* Não utilizado */
                        OUTPUT TABLE ttErrosConexao).
    
    if  return-value = "NOK" then do:
        run pi-finalizar in h-acomp.
        undo, retry.
    end.
    
    for each tt-estat-modul exclusive-lock:
        delete tt-estat-modul.
    end.
    
    /*for each tt-estat exclusive-lock:
     *     delete tt-estat.
     * end.*/
    
    /*----------- Controle de Producao--------------*/
    {utp/ut-liter.i Exportando_PRODU€ÇO *}
    run pi-acompanhar in h-acomp (input Return-value).
    assign i-registro = 0.
    do  trans:
        find first bh-periodos
             where bh-periodos.ep-codigo = i-empresa
             and   bh-periodos.modulos = "CP"
             Exclusive-lock no-error.
        if  not avail bh-periodos then do:
            create bh-periodos.
            assign bh-periodos.ep-codigo = i-empresa
                   bh-periodos.modulos   = "CP"
                   bh-periodos.area      = "I".
        end.
        assign bh-periodos.periodo = tt-param.da-per-corte.
    end.
    /*create tt-estat.
     * assign tt-estat.i-emp  = i-empresa
     *        tt-estat.c-mod  = "CP"
     *        tt-estat.da-per = da-per-corte.*/
    
    
    assign i-nr-tab = 13. /* N£mero de tabelas que fazem parte dos bancos hist¢ricos*/
    
    do  i-cont = 1 to i-nr-tab:
        create tt-estat-modul.
        assign tt-estat-modul.i-sequencia = i-cont.
    end.
    
    for each tt-estat-modul:
        case tt-estat-modul.i-sequencia:
             when 1 then do:
                 {utp/ut-table.i movind cab-req-sum 1}
                 assign tt-estat-modul.c-tabela  = "cab-req-sum"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
             when 2 then do:
                 {utp/ut-table.i movind req-sum 1}
                 assign tt-estat-modul.c-tabela  = "req-sum"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
             when 3 then do:
                 {utp/ut-table.i movind reservas 1}
                 assign tt-estat-modul.c-tabela  = "reservas"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
             when 4 then do:
                 {utp/ut-table.i movind ref-ordem 1}
                 assign tt-estat-modul.c-tabela  = "ref-ordem"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
             when 5 then do:
                 {utp/ut-table.i movind oper-ord 1}
                 assign tt-estat-modul.c-tabela  = "oper-ord"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
             when 6 then do:
                 {utp/ut-table.i movind movto-mat 1}
                 assign tt-estat-modul.c-tabela  = "movto-mat"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.  
             when 7 then do:
                 {utp/ut-table.i movind movto-ggf 1}
                 assign tt-estat-modul.c-tabela  = "movto-ggf"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.  
             when 8 then do:
                 {utp/ut-table.i movind movto-dir 1}
                 assign tt-estat-modul.c-tabela  = "movto-dir"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.  
             when 9 then do:
                 {utp/ut-table.i movind ext-ord 1}
                 assign tt-estat-modul.c-tabela  = "ext-ord"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.  
             when 10 then do:
                 {utp/ut-table.i movind ext-ord-per 1}
                 assign tt-estat-modul.c-tabela  = "ext-ord-per"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.   
             when 11 then do:
                 {utp/ut-table.i movind ord-prod 1}
                 assign tt-estat-modul.c-tabela  = "ord-prod"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.  
             when 12 then do:
                 {utp/ut-table.i movind pert-ordem 1}
                 assign tt-estat-modul.c-tabela  = "pert-ordem"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.   
             when 13 then do:
                 {utp/ut-table.i movind rep-oper 1}
                 assign tt-estat-modul.c-tabela  = "rep-oper"
                        tt-estat-modul.c-modulo  = trim(return-value).
             end.
         end.
    end.
    
    run bhp/bh0301a.p. /* exporta producao */
    
    /*assign tt-estat.i-reg = i-registro.*/
    
    if  l-trans then do:
        {utp/ut-liter.i Desconectando_Banco_Hist¢rico_-_Produ‡Æo *}
        run pi-acompanhar in h-acomp (input Return-value).

        /*Desconecta Bancos históricos*/
        RUN btb/btb962za.p (INPUT i-empresa,
                            INPUT i-empresa,
                            INPUT 3, /* Transferir */
                            INPUT 2, /* Desconectar */
                            INPUT "", /* Não utilizado */
                            OUTPUT TABLE ttErrosConexao).

    end.

END.

{utp/ut-liter.i Imprimindo_Estat¡sticas *}
run pi-acompanhar in h-acomp (input Return-value).

{utp/ut-liter.i "PAR¶METROS" * L}
assign c-param = return-value.
{utp/ut-liter.i "Per¡odo_de_corte:" * L}
assign c-per = return-value.
{utp/ut-liter.i "IMPRESSÇO" * L}
assign c-imp = return-value.
{utp/ut-liter.i "Usu rio:" * L}
assign c-usu = return-value.
{utp/ut-liter.i "Destino:" * L}
assign c-dest = return-value.
assign c-dest2 = {varinc/var00002.i 04 tt-param.destino}.

Run utp/ut-liter.p (input c-dest2,"*","").
Assign c-dest2 = Return-value.

{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

FOR EACH tt-erro-his:
    {utp/ut-liter.i Banco_Hist¢rico *}
    run utp/ut-msgs.p(input "msg",
                      input 30406,
                      input RETURN-VALUE + "~~" + STRING(tt-erro-his.nr-ord-produ)).
    ASSIGN c-erro = "*** Erro Nr: 30406 - " + RETURN-VALUE.
    DISP c-erro WITH FRAME f-erro-1 WIDTH 120.
END.

IF l-valida THEN DO:

    assign i-total = 0.
    for each tt-estat-modul use-index i-sequencia:
        disp c-modulo
             tt-estat-modul.c-tabela
             tt-estat-modul.c-modulo 
             tt-estat-modul.i-modulo 
             with frame f-modul.
        down with frame f-modul.
        assign i-total = i-total + tt-estat-modul.i-modulo. 
    end.
    
    disp c-total
         i-total with frame f-tot.

END.
ELSE DO:
    
    DO i-cont = 1 TO NUM-ENTRIES(c-valida):
        DISP ENTRY(i-cont, c-valida) FORMAT "X(100)" WITH FRAME f-erros WIDTH 120.
    END.

END.

page.


disp skip(02)
     c-param         at 02  skip(01)
     c-per           at 6
     tt-param.da-per-corte at 30 format "99/99/9999" skip
     c-imp           at 01 skip(01)
     c-dest          at 17 
     c-dest2         at 30 format "x(12)"
     "-"             at 44
     tt-param.arquivo format "x(25)" skip 
     c-usu           at 17
     c-seg-usuario   at 30 skip
     with no-box width 132 row 1 no-label stream-io frame f-dados.


run pi-finalizar in h-acomp.

{include/i-rpclo.i}

/*** RETORNO PARA RPW ***/
return "OK".

