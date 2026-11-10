/* PROCEDURE buscaTipEmisAmbSEFAZNotaFiscal: */

    DEFINE INPUT  PARAMETER cXmlProt   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER iTpAmb     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER cdhRecbto  AS CHARACTER NO-UNDO.

    ASSIGN iTpAmb = 0.

    IF  INDEX(cXmlProt, "<tpAmb>":U) > 0 THEN
        ASSIGN iTpAmb = INT(SUBSTR(cXmlProt, INDEX(cXmlProt, "<tpAmb>":U) + 7, 1)) NO-ERROR.

    IF  INDEX(cXmlProt, "<dhRecbto>":U) > 0 THEN
        ASSIGN cdhRecbto = SUBSTR(cXmlProt, INDEX(cXmlProt, "<dhRecbto>":U) + 10, 19) NO-ERROR.
    
/* END PROCEDURE */


