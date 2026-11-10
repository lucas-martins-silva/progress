/* axsep509extradeclarations */

DEF TEMP-TABLE tt-roman-faturam NO-UNDO
    FIELD num-romaneio     LIKE roman-faturam.num-romaneio
    FIELD cod-estabel      LIKE roman-faturam.cod-estabel
    FIELD idi-sit-roman    LIKE roman-faturam.idi-sit-roman
    FIELD dt-cancela       LIKE roman-faturam.dt-cancela
    FIELD dsl-motiv-cancel LIKE roman-faturam.dsl-motiv-cancel
    FIELD cod-usuar-cancel LIKE roman-faturam.cod-usuar-cancel
    INDEX ch-id IS PRIMARY UNIQUE num-romaneio.
