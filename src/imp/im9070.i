/********************************************************************************
** Defini‡äes
*******************************************************************************/

{dibo/bodi317im2bra.i1}  /* Defini‡Æo tb-wt-docto, tb-wt-it-docto, tb-wt-it-imposto */
{dibo/bodi516.i tt-item-nf-adc}

def new global shared var c-seg-usuario as char format "x(12)" no-undo.

DEFINE BUFFER b-tb-ct-trib-wt-item-docto FOR tb-ct-trib-wt-item-docto.
DEFINE BUFFER b-tb-wt-it-docto           FOR tb-wt-it-docto.
DEFINE BUFFER b-tb-wt-it-imposto         FOR tb-wt-it-imposto.
DEFINE BUFFER b-natur-oper               FOR natur-oper.

{dibo/bodi613calc.i3}  //defini‡Æo da tb-wt-it-impostoCBSIBS 

DEFINE VARIABLE h-cdapi995         AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-bodi613calc2     AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h_bodi317im2bra    AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin01017        AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx225na        AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin176          AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-cdcfgfiscal      AS   HANDLE      NO-UNDO.
DEFINE VARIABLE h-acomp            AS   HANDLE      NO-UNDO.

DEF VAR i                    AS INTEGER INITIAL 0   NO-UNDO.
DEF VAR i-seq-item-doc-est   AS INTEGER             NO-UNDO.
DEF VAR i-seq                AS INTEGER INITIAL 0   NO-UNDO.
DEF VAR c-char-1             AS CHAR                NO-UNDO.
DEF VAR de-qtd-aux           LIKE item-doc-est.quantidade  NO-UNDO.

DEFINE TEMP-TABLE tt-desconto-icms NO-UNDO 
       FIELD numero-ordem       LIKE ordens-embarque.numero-ordem
       FIELD parcela            LIKE ordens-embarque.parcela
       FIELD de-perc-desc-icms  AS DECIMAL             
       FIELD l-aplica-desc-icms AS LOGICAL .

DEFINE TEMP-TABLE tt-ext-item-doc-est NO-UNDO LIKE ext-item-doc-est
    FIELD r-Rowid          AS ROWID.

DEFINE VARIABLE c-lbl-acomp        AS   CHARACTER    NO-UNDO.
DEFINE VARIABLE c-lbl-acomp2       AS   CHARACTER    NO-UNDO.
DEFINE VARIABLE c-lbl-item         AS   CHARACTER    NO-UNDO.
DEFINE VARIABLE de-vl-icm-old      AS   DECIMAL      NO-UNDO.
DEFINE VARIABLE de-tot-icms-old    AS   DECIMAL      NO-UNDO.
DEFINE VARIABLE de-tot-val-fcp-st  AS   DECIMAL      NO-UNDO.
DEFINE VARIABLE de-tot-base-fcp-st AS   DECIMAL      NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto-aux AS   INTEGER      NO-UNDO.
 
