/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9005 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im9005 MIM}
&ENDIF

/*****************************************************************************
**
** IM9005 - Integra‡Æo entre Importa‡Æo e Recebimento (EMS)
**
** Objetivo: Duplicata das despesas.
**
******************************************************************************/

{cdp/cdcfgmat.i} /* include preprocessadores Magnus x EMS */

&if defined(bf-mat-comex) &then
&else

{cdp/cd0666.i}
{cdp/cd4300.i3} /* vari veis utilizadas pelo cd4300.i4 */
{include/i-epc200.i im9005}

def input        parameter rw-docum-est as rowid.
def input-output parameter l-existe-ap    as  logical no-undo.
def input-output parameter l-erro         as  logical no-undo.
def input-output parameter l-ems50        as  logical no-undo.
def input-output parameter l-existe-ems50 as  logical no-undo.
def input-output parameter l-dp-cont      as  logical no-undo.

def var l-imp        as   logical                INIT NO no-undo.
def var l-imp-rateio as   logical                INIT NO no-undo.
def var c-nr-duplic  like dupli-apagar.nr-duplic no-undo.
DEF VAR i-cod-emitente-upc LIKE docum-est.cod-emitente NO-UNDO.
def var i-empresa like param-global.empresa-prin no-undo.

{cdp/cdcfgdis.i}

find first docum-est
    where rowid(docum-est) = rw-docum-est no-lock no-error.    
    
FIND FIRST natur-oper
     WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.

find first param-global no-lock no-error.        

{rep/re1001a.i50} /* vari veis e informa‡äes utilizadas pelo re1001a.i51 */

{cdp/cd4300.i4  "yes" docum-est.char-1} 

{rep/re1001a.i51 "yes"}

if c-embarque <> "" then
    assign l-imp = yes.

IF AVAIL natur-oper
AND natur-oper.nota-rateio
AND c-embarque <> "" THEN
    ASSIGN l-imp-rateio = YES.

/* Verifica duplicatas -  docum-est.char-1 refere-se ao n£mero do embarque */
                                       
{rep/re0402b.i "-cex" "-desp" "c-embarque"}         

{rep/re0402b.i2}     /* Procedures comuns ao re0402b.p e im9005 */

&endif
