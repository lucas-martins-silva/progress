/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9039 2.00.00.016 } /*** "010016" 15/04/2024 15:18:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9039 MIM}
&ENDIF

/***************************************************************************
**
**   IM9039P - Desatualizacao do Contas a Pagar/Importa‡Æo
**
***************************************************************************/
 
{cdp/cdcfgmat.i}
{include/i-epc200.i im9039}
&if defined(bf-mat-comex) &then 
&else

{utp/ut-glob.i}
{cdp/cd0666.i} 

/*
/******************** Multi-Planta **********************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.

{cdp/cd7300.i1}
/************************* Fim **************************/
*/

def input        param r-docum          as rowid    no-undo.
def output       param l-erro           as logical  no-undo.
def input-output param table            for tt-erro.


{app/apapi018.i}         /* Definicao temp-table tt-param    */
{rep/re0402d.i1}         /* Definicao temp-tables do EMS 5.0 */
{cdp/cd4300.i3}          /* Variaveis para o cd4300.i4       */
{rep/re1001a.i50}

def buffer b-docum-est           for docum-est.
def buffer b-dupli-apagar        for dupli-apagar.
def buffer b-item-doc-est        for item-doc-est.

def var l-rec-brasil             as log                      no-undo.
def var l-integracao-ems50       as log                      no-undo.
def var de-vl-previsao           as dec                      no-undo.
def var de-vl-item-fatura        as dec                      no-undo.
def var v_log_livre_1            as log  format "Sim/Nao"    no-undo.
def var c-nr-duplic              like dupli-apagar.nr-duplic no-undo.
def var l-imp                    as logical                  INIT NO no-undo.
def var l-imp-rateio             as logical                  INIT NO no-undo.
DEF VAR i-cod-emitente-upc       LIKE docum-est.cod-emitente NO-UNDO.
DEF VAR h-boar2011               AS HANDLE                   NO-UNDO.
DEF VAR h-boec022                AS HANDLE                   NO-UNDO.
DEF VAR c-serie-docto-ems5       AS CHAR                     NO-UNDO.
def var i-empresa                like param-global.empresa-prin no-undo.
DEF VAR l-credito-debito         AS LOG                      INIT NO NO-UNDO.
DEF VAR i-cod-emitente-aux       AS INT                      NO-UNDO.
DEF var i-cdn-emitente-sri       AS INT                      NO-UNDO.

{cdp/cdcfgdis.i}

assign l-imp = yes.

find first param-global no-lock no-error.

find docum-est
    where rowid(docum-est) = r-docum exclusive-lock no-error.

{cdp/cd4300.i4 "yes" docum-est.char-1}
{rep/re1001a.i51 "yes"}

/*--------- INICIO UPC ---------*/ 
create tt-epc.
assign tt-epc.cod-event     = "Atualiza-Embarque"
       tt-epc.cod-parameter = "Nro-Docto"
       tt-epc.val-parameter = docum-est.nro-docto.

{include/i-epc201.i "Atualiza-Embarque"}

FIND FIRST tt-epc
     WHERE tt-epc.cod-event     = "Atualiza-Embarque"
       AND tt-epc.cod-parameter = "Embarque" NO-ERROR.
IF AVAIL tt-epc THEN
    ASSIGN c-embarque = tt-epc.val-parameter.

/*--------- FINAL UPC ---------*/

FIND natur-oper
    WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

find funcao
    where funcao.cd-funcao = "adm-apb-ems-5.00"
      and funcao.ativo
      and funcao.log-1 
    no-lock no-error. 

assign l-integracao-ems50 = avail funcao
       l-rec-brasil       = i-pais-impto-usuario = 1.   /* Brasil */

IF AVAIL natur-oper
AND natur-oper.nota-rateio
AND c-embarque <> ""  THEN
    ASSIGN l-imp-rateio = YES.

{rep/re0402d.i2 "-cex" "-desp"}

{rep/re0402d.i3}

&endif
