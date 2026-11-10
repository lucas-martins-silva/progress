&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
***********************************************************************************/
{include/i-prgvrs.i AB0805A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i AB0805A MAB}
&ENDIF

/***********************************************************************************
**
**  Programa: AB0805A
**
**  Objetivo: Seta vari veis globais para cria‡Æo dos registros de Abastec/Lubrific
**
***********************************************************************************/

{method/dbotterr.i} /* Definicao RowErrors */
{abp/abapi016.i}

/********************************************
** Defini‡Æo de Parƒmetros
********************************************/
DEFINE INPUT PARAMETER pi-emitente  LIKE item-doc-est.cod-emitente.
DEFINE INPUT PARAMETER pc-nota      LIKE item-doc-est.nro-docto.
DEFINE INPUT PARAMETER pc-serie     LIKE item-doc-est.serie-docto.
DEFINE INPUT PARAMETER pc-natureza  LIKE item-doc-est.nat-operacao.
DEFINE INPUT PARAMETER pi-sequencia LIKE item-doc-est.sequencia.
DEFINE INPUT PARAMETER TABLE FOR tt-mab-item-abastec-lubrific.
DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

DEFINE TEMP-TABLE tt-mab-item-abastec-lubrific-aux NO-UNDO LIKE tt-mab-item-abastec-lubrific.

/********************************************
** Defini‡Æo de Vari veis Locais
********************************************/
DEFINE VARIABLE hApiFrota  AS HANDLE NO-UNDO.
DEFINE VARIABLE i-operacao AS INTEGER NO-UNDO.

define buffer bf-item-frota for item.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.04
         WIDTH              = 27.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
EMPTY TEMP-TABLE tt-mab-item-abastec-lubrific-aux.

/** Inicializa Handles necess ria **/
RUN abp/abapi016.p PERSISTENT SET hApiFrota.

RUN pi-dadosItemDocEst IN hApiFrota (INPUT pi-emitente,
                                     INPUT pc-nota,
                                     INPUT pc-serie,
                                     INPUT pc-natureza,
                                     INPUT pi-sequencia).

RUN pi-getTTdadosAbastLubrif IN hApiFrota (OUTPUT TABLE tt-mab-item-abastec-lubrific-aux).

blk-frotas:
DO TRANS:
    FIND FIRST tt-mab-item-abastec-lubrific NO-LOCK NO-ERROR.
    IF AVAIL tt-mab-item-abastec-lubrific THEN DO:

        FIND FIRST tt-mab-item-abastec-lubrific-aux EXCLUSIVE-LOCK NO-ERROR.
        IF  NOT AVAIL tt-mab-item-abastec-lubrific-aux THEN
            ASSIGN i-operacao = 1. /* incluir */
        ELSE
            ASSIGN i-operacao = 2. /* alterar */

        RUN pi-execute IN hApiFrota(INPUT TABLE tt-mab-item-abastec-lubrific,
                                    INPUT i-operacao,
                                    OUTPUT TABLE RowErrors).
        IF  CAN-FIND(FIRST RowErrors NO-LOCK
                     WHERE RowErrors.ErrorSubType = "Error":U) THEN
            UNDO blk-frotas, LEAVE blk-frotas.
    END.
END.

IF  VALID-HANDLE(hApiFrota) THEN
    DELETE OBJECT hApiFrota.

RETURN "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
