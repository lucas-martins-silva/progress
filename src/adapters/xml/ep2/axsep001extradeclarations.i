/* Defini‡Æo de vari veis */

DEFINE VAR cTranEvent    AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction   AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR iContItem     AS INTEGER             NO-UNDO.
DEFINE VAR iContDiscount AS INTEGER INIT 0      NO-UNDO.
DEFINE VAR iValue        AS INTEGER             NO-UNDO.
DEFINE VAR i-cont        AS INTEGER             NO-UNDO.

DEFINE VAR l-nfe         AS LOGICAL             NO-UNDO.

/* Vendor */
DEFINE VAR da-base        AS DATE      FORMAT "99/99/9999":U         NO-UNDO.
DEFINE VAR de-tx-cli      AS DECIMAL   FORMAT ">>9.9999":U INITIAL 0 NO-UNDO.
DEFINE VAR i-cod-cond-cli AS INTEGER   FORMAT ">>9":U      INITIAL 0 NO-UNDO.
DEFINE VAR i-dias-base    AS INTEGER   FORMAT ">>9":U      INITIAL 0 NO-UNDO.
DEFINE VAR l-vendor       AS LOGICAL                                 NO-UNDO.

/*ZFM   VARIABLES - BEGIN*/
def var de-vl-unit               as decimal                             no-undo.
def var de-conv                  as decimal format ">>>>9.99"           NO-UNDO.
def var de-conv-total            as decimal format ">>>>9.99"           NO-UNDO.
DEF VAR r-cidade-zf              AS ROWID                               NO-UNDO.
def var de-vl-total              as decimal                             no-undo.
def var de-qt-fatur              as decimal format ">>>>,>>9.9999"      no-undo.
def var l-frete-bipi             as log                                 no-undo. 
def var de-vl-bipi-it            like it-nota-fisc.vl-bipi-it           no-undo. 
def var de-vl-ipi-it             like it-nota-fisc.vl-ipi-it            no-undo.
/*ZFM    VARIABLES - END*/    


{cdp/cdcfgdis.i}
DEF VAR l-funcao-SGT AS LOG NO-UNDO INITIAL NO.
ASSIGN l-funcao-SGT = CAN-FIND(FIRST funcao
                                      WHERE funcao.cd-funcao = "spp-sgt":U
                                      AND   funcao.ativo).

DEF VAR c-customerItemCode AS CHARACTER NO-UNDO.
DEF VAR c-eanCode          AS CHARACTER NO-UNDO.
