DEFINE TEMP-TABLE {1} NO-UNDO SERIALIZE-NAME 'quotationProcessVendors':U
    FIELD cdd-solicit          AS DECIMAL   INITIAL ? SERIALIZE-NAME 'quotationProcessNumber':U
    FIELD cdn-fornec           AS INTEGER   INITIAL ? SERIALIZE-NAME 'vendorId':U
    FIELD des-e-mail           AS CHARACTER INITIAL ? SERIALIZE-NAME 'email':U
    FIELD assunto-email        AS CHARACTER INITIAL ? SERIALIZE-NAME 'emailSubject':U
    FIELD dsl-texto            AS CHARACTER INITIAL ? SERIALIZE-NAME 'emailContent':U
    FIELD log-responde-via-web AS LOGICAL   INITIAL ? SERIALIZE-NAME 'websiteAnswer':U
    FIELD log-planilha-envda   AS LOGICAL   INITIAL ? SERIALIZE-NAME 'spreadsheetSent':U
    FIELD log-confir-entreg    AS LOGICAL   INITIAL ? SERIALIZE-NAME 'confirmDelivery':U
    FIELD log-confir-recebto   AS LOGICAL   INITIAL ? SERIALIZE-NAME 'confirmReceipt':U
    FIELD nome-abrev           AS CHARACTER INITIAL ? SERIALIZE-NAME 'shortName':U
    FIELD nome-emit            AS CHARACTER INITIAL ? SERIALIZE-NAME 'name':U
    FIELD cgc                  AS CHARACTER INITIAL ? SERIALIZE-NAME 'taxId':U
    FIELD l-nt2024002          AS LOGICAL   INITIAL ? SERIALIZE-NAME 'lRTC'
.
