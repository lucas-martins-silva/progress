/***************************************************************************
**                                                                        **
**    AQ0320.I - Fechamento Período Cálculo                               **
**                                                                        **
**    DEFINIÇÃO DAS TEMP-TABLES                                           **
**                                                                        **  
****************************************************************************/
 
DEFINE TEMP-TABLE tt-param 
    FIELD destino       AS INTEGER
    FIELD arquivo       AS CHARACTER
    FIELD usuario       AS CHARACTER 
    FIELD data-exec     AS DATE
    FIELD hora-exec     AS INTEGER
    FIELD l-habilitaRtf AS LOGICAL
    FIELD cod-period    LIKE fechto-produt-period.cod-period
    FIELD cod-estabel   LIKE fechto-produt-period.cod-estabel
    FIELD acao          AS INTEGER /*1 fechar  2 reabrir*/
    FIELD c-destino     AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
   FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD cod-estabel LIKE estabelec.cod-estabel
    FIELD nomeest     AS CHARACTER FORMAT "X(40)":U
    FIELD cod-period  LIKE fechto-produt-period.cod-period.

DEFINE TEMP-TABLE tt-erros NO-UNDO
    FIELD error-number      AS INT
    FIELD error-description AS CHAR
    FIELD cdn-produt-rural  LIKE fechto-produt-period.cdn-produt-rural
    FIELD cod-propried      LIKE fechto-produt-period.cod-propried.

DEFINE TEMP-TABLE tt-fechto NO-UNDO
    FIELD fechto-description AS CHAR.

DEFINE TEMP-TABLE tt_estab_fechto NO-UNDO
    FIELD tta_cod_estab                    AS CHARACTER FORMAT "x(3)":U LABEL "Estabelecimento":U COLUMN-LABEL "Estab":U
    FIELD ttv_log_fechto                   AS LOGICAL FORMAT   "Sim/NÆo":U INITIAL NO
    INDEX tt_cod_estab                     IS PRIMARY UNIQUE
          tta_cod_estab                    ASCENDING
    .