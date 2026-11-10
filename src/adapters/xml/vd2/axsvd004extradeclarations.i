/* Defini‡Æo de vari veis */

DEFINE VAR cEvent                   AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction              AS CHARACTER INITIAL ? NO-UNDO.

DEFINE VAR Comments                 AS CHARACTER INITIAL ? NO-UNDO.  
DEFINE VAR CurrencyDescription      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR CurrencyID               AS INTEGER   INITIAL ? NO-UNDO.  
DEFINE VAR CurrencySign             AS CHARACTER INITIAL ? NO-UNDO.  
DEFINE VAR DiscountPercentage       AS decimal   INITIAL ? NO-UNDO.
DEFINE VAR InitialValidityDate      AS date      INITIAL ? NO-UNDO. 
DEFINE VAR PriceGroupDescription    AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR PriceGroupID             AS integer   INITIAL ? NO-UNDO.
DEFINE VAR PriceTableDescription    AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR PriceTableNumber         AS CHARACTER INITIAL ? NO-UNDO. 
DEFINE VAR TableStatus              AS integer   INITIAL ? NO-UNDO.
DEFINE VAR ValidityDate             AS DATE      INITIAL ? NO-UNDO.  
                                 
DEFINE VAR iContItem                AS           INTEGER   NO-UNDO.  
DEFINE VAR iContUpd                 AS           INTEGER   NO-UNDO.  

{cdp/cdcfgdis.i}
{method/dbotterr.i}
{include/i-epc200.i axsvd004}

&IF '{&BF_DIS_VERSAO_EMS}' >= '2.062' &THEN
    DEFINE TEMP-TABLE tt-variavel NO-UNDO
        FIELD cod-var-oper LIKE config-var-operac-regra-cond.cod-variavel
        FIELD cod-val-var  LIKE config-var-operac-regra-cond.cod-val-var.

    DEFINE TEMP-TABLE tt-retorno NO-UNDO
        FIELD valor-retorno LIKE config-var-operac-regra-ret.cod-val-ret
        FIELD campo-retorno LIKE config-var-operac-regra-ret.cod-campo-ret
        FIELD perc-rateio   LIKE config-var-operac-regra-ret.cdd-perc-rat.   

    DEF VAR i-cod-regra-utilizada LIKE config-var-operac-regra.cdn-regra-operac.
&ENDIF
