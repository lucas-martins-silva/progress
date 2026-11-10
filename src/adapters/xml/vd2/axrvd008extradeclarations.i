/*---------------------------------------------------[ EDI Mercantil com Montadoras ]---*/
{method/dbotterr.i} 
{cdp/cd9043.i1} 

{pdp/pdapi155.i}  /* Prog-cli             */ 
{pdp/pdapi155.i1} /* Prog-item            */ 
{pdp/pdapi155.i2} /* Prog-ent             */ 
{pdp/pdapi155.i3} /* Prog-entreg-cham     */
{cdp/cdapi150.i3} /* tt_versao_efetiv_edi */
{cdp/cdapi150.i4} /* tt_erros_modulo      */ 
{cdp/cdapi150.i7} /* tt_variaveis_api_edi */

DEFINE VAR i-idi-confir-programac-entreg AS   INTEGER            NO-UNDO.
DEFINE VAR c_dat_aux                     AS   CHARACTER          NO-UNDO.
DEFINE VAR d-qt-pedida                   LIKE prog-ent.qt-pedida NO-UNDO.
DEFINE VAR r-rowid-prog-ent              AS   ROWID              NO-UNDO.
DEFINE VAR i-nr-ord-cham                 AS   INTEGER            NO-UNDO.
DEFINE VAR pSendSuccess                  AS   LOGICAL INIT YES   NO-UNDO.
DEFINE VAR pTotalErrors                  AS   INTEGER            NO-UNDO.
DEFINE VAR c-dataEntrega-aux             AS   CHARACTER          NO-UNDO.
DEFINE VAR d-dataEntrega                 AS   DATE               NO-UNDO.
DEFINE VAR c_cdn_trans_edi               AS   CHARACTER          NO-UNDO.

define buffer bf-ttDeliveryScheduling for ttDeliveryScheduling.
define buffer bf-ped-ent              for ped-ent.
/*---------------------------------------------------[ EDI Mercantil com Montadoras ]---*/
