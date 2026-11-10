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
{include/i-prgvrs.i ABAPI013 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i abapi013 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ABAPI013.p
**
**       DATA....: Outubro de 2005
**
**       AUTOR...: Herc¡lio Werneck de Capistrano - KSM35590.
**
**       OBJETIVO: Fazer a valida‡Æo conforme contrato de cliente para
**                 verificar a quantidade m xima de equipamentos que podem ser
**                 cadastrados dentro do Manuten‡Æo de Frota.
**                 Sintaxe: run abp/abapi013.p (output table RowErrors append).
**
*****************************************************************************/

/*******************************  Definitions  ******************************/
/** Temp-Tables **/
{abp/ab9004.i}  /** RowErrors **/

/** Parƒmetros **/
define output parameter table for RowErrors.

/** Vari veis **/
DEFINE VARIABLE Qtd-Eqpto   AS INTEGER initial 0 NO-UNDO.
DEFINE VARIABLE i-Qtd-Eqpto AS INTEGER initial 0   NO-UNDO.

/** Buffers **/
DEFINE BUFFER bf-mab-param FOR mab-param.

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
         HEIGHT             = 7
         WIDTH              = 36.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/abapi001.i2} /** Cria‡Æo de Erros **/

/** M ximo de Equipamentos **/ /** Dever  ser alterado com a l¢gica implementada para calculo de m ximo de equipamentos **/
FOR FIRST mab-param
    WHERE mab-param.cdn-param = 1 NO-LOCK:
    ASSIGN Qtd-Eqpto = mab-param.num-livre-1.
END.

IF Qtd-Eqpto = 0 THEN
    ASSIGN Qtd-Eqpto = 999999999.

/** FO 2236.773 **/
RUN piAlteraMaxEqpto IN THIS-PROCEDURE.

RUN piInicializar IN THIS-PROCEDURE.

IF CAN-FIND (FIRST RowErrors NO-LOCK) THEN DO:
    RETURN "NOK":U.
END.
ELSE DO:
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAlteraMaxEqpto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraMaxEqpto Procedure 
PROCEDURE piAlteraMaxEqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST bf-mab-param
         WHERE bf-mab-param.cdn-param = 1 EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL bf-mab-param THEN
        ASSIGN bf-mab-param.num-livre-1 = 999999999
               Qtd-Eqpto                = 999999999.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicializar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializar Procedure 
PROCEDURE piInicializar :
/*------------------------------------------------------------------------------
  Purpose:     inicializa a api
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run verificaCadastro in this-procedure.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-verificaCadastro) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaCadastro Procedure 
PROCEDURE verificaCadastro :
/*------------------------------------------------------------------------------
  Purpose:     verificaCadastro
  Parameters:  <none>
  Notes:       Verifica o cadastro de equipamentos com base a licensa adquirida
               pelo cliente, para bloquear, ou nÆo, o cadastro de novos
               equipamentos.
------------------------------------------------------------------------------*/
/** Busca equipamentos **/
for each  mab-eqpto
    where mab-eqpto.idi-tip-eqpto = 1 and
          mab-eqpto.dat-situacao  = ? no-lock:
    assign i-Qtd-Eqpto = i-Qtd-Eqpto + 1.
end.

/** Compara quantidade de equipamentos ativos com a licensa do cliente **/
if i-Qtd-Eqpto > Qtd-Eqpto then do:
    {utp/ut-liter.i Equipamentos }
    run piCriaErro in this-procedure (input 31380,
                                      input "EMS":U,
                                      input trim(return-value) + '~~' + string(Qtd-Eqpto)).
    return "NOK":U.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

