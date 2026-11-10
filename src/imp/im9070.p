USING rep.imp.*.
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/

{include/i-prgvrs.i IM9070 2.00.00.019 } /* 05/10/2026 08:04:06 */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM9070 MIM}
&ENDIF

{cdp/cd4305.i1}  /* Defini‡Æo tt-docto, tt-it-docto e tt-it-imposto */
{cdp/cd9701.i}   /* Defini‡Æo/atribui‡Æo da vari vel l-mult-natur-receb -> Usa multiplas naturezas no recebimento */

DEFINE VARIABLE de-vl-icm               LIKE docum-est.icm-deb-cre   NO-UNDO. 
DEFINE VARIABLE de-base-icm             LIKE docum-est.base-icm      NO-UNDO.
DEFINE VARIABLE de-base-ipi             LIKE docum-est.base-ipi      NO-UNDO. 
DEFINE VARIABLE de-vl-ipi               LIKE docum-est.ipi-deb-cre   NO-UNDO.
DEFINE VARIABLE de-base-subs            LIKE docum-est.base-subs     NO-UNDO.
DEFINE VARIABLE de-vl-subs              LIKE docum-est.vl-subs       NO-UNDO.
DEFINE VARIABLE l-nota-rateio           AS   LOGICAL                 NO-UNDO.
DEFINE VARIABLE l-procedimento-ok       AS   LOGICAL                 NO-UNDO.
DEFINE VARIABLE de-tot-val-fcp          AS   DECIMAL                 NO-UNDO.
DEFINE VARIABLE de-tot-base-fcp         AS   DECIMAL                 NO-UNDO.
DEFINE VARIABLE de-valor-ipi-unid       LIKE item.valor-ipi-beb      NO-UNDO.
DEFINE VARIABLE de-valor-un-pis         AS DEC FORMAT ">>>9.99999"   NO-UNDO.
DEFINE VARIABLE de-valor-un-cofins      AS DEC FORMAT ">>>9.99999"   NO-UNDO.
DEFINE VARIABLE h-imapi017              AS HANDLE                    NO-UNDO.
DEFINE VARIABLE l-utilizaImpostoMonitor AS LOGICAL INITIAL NO        NO-UNDO.
DEFINE VARIABLE l-NT2024002             AS LOGICAL INITIAL NO        NO-UNDO.
DEFINE VARIABLE lSujTribMonofasica      AS LOGICAL INITIAL NO        NO-UNDO.

DEFINE TEMP-TABLE tt-item-doc-est-tribut NO-UNDO LIKE item-doc-est-tribut.

{imp/im9070.i}
{imp/im9070.i2}
{rep/imp/utilizaImpostosMonitor.i} /*Procedure para validar se utiliza o monitor NFe utilizada na boin176.m97*/
