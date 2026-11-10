&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ABAPI012 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi012 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI011.p
**       DATA....: Setembro de 2005
**       AUTOR...: Leonardo Lazarini
**       OBJETIVO: Atualizar em todas as tabelas de abastecimento o a Empresa 
**                 e o Estabelecimento do Motorista
**                 run abp/abapi012.p (input  pFlag, 1-Motorista, 2-Funcion rio
                                       input  pEpCodigoMatr,
**                                     input  pCodEstabelMatr,
**                                     input  pCodMatr).
**
*****************************************************************************/


/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER pFlag             AS INTEGER                    NO-UNDO.
DEFINE INPUT PARAMETER pEpCodigoMatr     LIKE mab-motoris.ep-codigo    NO-UNDO.
DEFINE INPUT PARAMETER pCodEstabelMatr   LIKE mab-motoris.cod-estabel  NO-UNDO.
DEFINE INPUT PARAMETER pCodMatr          LIKE mab-motoris.cod-matr     NO-UNDO.

DEFINE VARIABLE h-acomp AS HANDLE     NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN pi-inicializa IN THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-inicializa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa Procedure 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     inicializa a api, conforme o bem passado por parametro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run utp/ut-acomp.p persistent set h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Atualiza‡Æo Tabelas").


IF pFlag = 1 THEN
    RUN piAtualizaMotorista IN this-procedure.
ELSE IF pFlag = 2 THEN
    RUN piAtualizaFuncionario IN THIS-PROCEDURE.
    

RUN pi-finalizar IN h-acomp.

IF  RETURN-VALUE = "NOK":U THEN
    RETURN "NOK":U.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaFuncionario) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaFuncionario Procedure 
PROCEDURE piAtualizaFuncionario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-acompanhar IN h-acomp (INPUT "mpn-movto-pneu":U).
FOR EACH mpn-movto-pneu EXCLUSIVE-LOCK
   WHERE mpn-movto-pneu.ep-codigo-matr = pEpCodigoMatr
     AND mpn-movto-pneu.cod-matr       = pCodMatr:
    ASSIGN mpn-movto-pneu.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mmv-movto-mdo":U).
FOR EACH mmv-movto-mdo EXCLUSIVE-LOCK
   WHERE mmv-movto-mdo.ep-codigo = pEpCodigoMatr
     AND mmv-movto-mdo.cod-matr  = pCodMatr:
    ASSIGN mmv-movto-mdo.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piAtualizaMotorista) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaMotorista Procedure 
PROCEDURE piAtualizaMotorista :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN pi-acompanhar IN h-acomp (INPUT "mab-motoris-model":U).
FOR EACH mab-motoris-model EXCLUSIVE-LOCK
   WHERE mab-motoris-model.cod-matr = pCodMatr:
    ASSIGN mab-motoris-model.ep-codigo   = pEpCodigoMatr
           mab-motoris-model.cod-estabel = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mab-abastec-lubrific":U).
FOR EACH mab-abastec-lubrific EXCLUSIVE-LOCK
   WHERE mab-abastec-lubrific.cod-matr = pCodMatr:
    ASSIGN mab-abastec-lubrific.ep-codigo-matr   = pEpCodigoMatr
           mab-abastec-lubrific.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mab-movto-event":U).
FOR EACH mab-movto-event EXCLUSIVE-LOCK
   WHERE mab-movto-event.cod-matr = pCodMatr:
    ASSIGN mab-movto-event.ep-codigo-matr   = pEpCodigoMatr
           mab-movto-event.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mab-reserva":U).
FOR EACH mab-reserva EXCLUSIVE-LOCK
   WHERE mab-reserva.cod-matr = pCodMatr:
    ASSIGN mab-reserva.ep-codigo-matr   = pEpCodigoMatr
           mab-reserva.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mab-viagem":U).
FOR EACH mab-viagem EXCLUSIVE-LOCK
   WHERE mab-viagem.cod-matr = pCodMatr:
    ASSIGN mab-viagem.ep-codigo-matr   = pEpCodigoMatr
           mab-viagem.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.

RUN pi-acompanhar IN h-acomp (INPUT "mnd-movto-infracao":U).
FOR EACH mnd-movto-infracao EXCLUSIVE-LOCK
   WHERE mnd-movto-infracao.cod-matr = pCodMatr:
    ASSIGN mnd-movto-infracao.ep-codigo-matr   = pEpCodigoMatr
           mnd-movto-infracao.cod-estabel-matr = pCodEstabelMatr NO-ERROR.
END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

