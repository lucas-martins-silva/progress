DEFINE TEMP-TABLE tt-parameters NO-UNDO
    FIELD estabIni         AS CHARACTER                        COLUMN-LABEL 'Estabelecimento inicial'
    FIELD estabFim         AS CHARACTER INITIAL 'ZZZZZ'        COLUMN-LABEL 'Estabelecimento final'
    FIELD codCanalVendaIni AS INTEGER                          COLUMN-LABEL 'Canal venda inicial'
    FIELD codCanalVendaFim AS INTEGER   INITIAL 999            COLUMN-LABEL 'Canal venda final'
    FIELD codGrCliIni      AS INTEGER                          COLUMN-LABEL 'Grupo cliente inicial'
    FIELD codGrCliFim      AS INTEGER   INITIAL 9999           COLUMN-LABEL 'Grupo cliente final'
    FIELD nomeAbrevIni     AS CHARACTER                        COLUMN-LABEL 'Cliente inicial'
    FIELD nomeAbrevFim     AS CHARACTER INITIAL 'ZZZZZZZZZZZZ' COLUMN-LABEL 'Cliente final'
    FIELD nomeAbRegIni     AS CHARACTER                        COLUMN-LABEL 'Regi∆o inicial'
    FIELD nomeAbRegFim     AS CHARACTER INITIAL 'ZZZZZZZZZZZZ' COLUMN-LABEL 'Regi∆o final'
    FIELD nomeMicRegIni    AS CHARACTER                        COLUMN-LABEL 'Micro regi∆o inicial'
    FIELD nomeMicRegFim    AS CHARACTER INITIAL 'ZZZZZZZZ'     COLUMN-LABEL 'Micro regi∆o final'
    FIELD repIni           AS INTEGER                          COLUMN-LABEL 'C¢digo do representante inicial'
    FIELD repFim           AS INTEGER   INITIAL 99999          COLUMN-LABEL 'C¢digo do representante final'
    FIELD itCodigoIni      AS CHARACTER                        COLUMN-LABEL 'Item inicial'
    FIELD itCodigoFim      AS CHARACTER INITIAL 'ZZZZZZZZZZZZ' COLUMN-LABEL 'Item final'
    FIELD dataIni          AS DATE      INITIAL TODAY          COLUMN-LABEL 'Per°odo Inicial'
    FIELD dataFim          AS DATE      INITIAL '12/31/2100'   COLUMN-LABEL 'Per°odo Final'
    FIELD cotasPor         AS INTEGER   INITIAL 1              COLUMN-LABEL 'CotasPor'
    FIELD tipoCota         AS INTEGER   INITIAL 1              COLUMN-LABEL 'Tipo Cota'
    FIELD realizada        AS INTEGER   INITIAL 1              COLUMN-LABEL 'Realizada'.

DEFINE TEMP-TABLE tt-resultados NO-UNDO
    FIELD cotasPor AS CHARACTER
    FIELD valor    LIKE cotas.qt-prevista.
    
DEFINE TEMP-TABLE tt-info
    FIELD campo-chave AS CHARACTER
    FIELD qtde        LIKE cotas.qt-prevista.
    
DEFINE VARIABLE h-tt-parameters AS HANDLE             NO-UNDO.
