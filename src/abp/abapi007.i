&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: ABAPI007.i
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Elimina‡Æo / Gera‡Æo / Atualiza‡Æo Percurso Rodado por
**                 equipamentos nÆo Motorizados
**
*****************************************************************************/

/*--- Temporary Table Definitions ---*/
/* {frbo/bofr060.i ttKMEqpto} /** Temp-table de cria‡Æo da quilometragem (BO) **/ */

DEFINE TEMP-TABLE ttKMEqpto NO-UNDO LIKE mab-movto-km-eqpto
    FIELD r-Rowid AS ROWID.

define temp-table ttKMImport no-undo like mab-movto-km-eqpto
    field r-rowid as rowid 
    field i-linha as integer.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field todos            as integer  /** 1 = Todos / 2 = Rejeitados **/
    field execucao         as integer
    field arq-entrada      as char format "x(80)"
    field arq-destino      as char format "x(80)"
    field i-origem         as integer  /** 1 = Importa‡Æo(AB0702) / 2 = Gera‡Æo(AB0703) / 3 = Viagem(AB0704)**/
    field dtInicial        as date format "99/99/9999"
    field dtFinal          as date format "99/99/9999"
&IF "{&mguni_version}" >= "2.071" &THEN
    field empIni           LIKE empresa.ep-codigo
    field empFim           LIKE empresa.ep-codigo
&ELSE
    field empIni           as integer format ">>9"
    field empFim           as integer format ">>9"
&ENDIF
    field eqptoIni         as character format "x(16)"
    field eqptoFim         as character format "x(16)"
&IF "{&mguni_version}" >= "2.071" &THEN
    field estabIni         as character format "x(5)"
    field estabFim         as character format "x(5)"
&ELSE
    field estabIni         as character format "x(3)"
    field estabFim         as character format "x(3)"
&ENDIF
    field grupoIni         as character format "x(8)"
    field grupoFim         as character format "x(8)"
    field modeloIni        as character format "x(8)"
    field modeloFim        as character format "x(8)"
    field dePercurso       as decimal
    field un               as character format "x(2)"
    field iTpPercurso      as integer /** 1 = Dia  /  2 = Total **/
&IF DEFINED(bf_mnt_ems206b) &THEN
    FIELD unidNegocIni     AS CHARACTER FORMAT "x(3)"
    FIELD unidNegocFim     AS CHARACTER FORMAT "x(3)"
&ENDIF
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.96
         WIDTH              = 27.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


