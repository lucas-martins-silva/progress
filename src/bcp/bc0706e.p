&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0706E 2.00.00.002}  /*** 010002 ***/
/*:T--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ‚ um programa 
                 PROGRESS que cont‚m a l¢gica de neg¢cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName    BC0706E
&GLOBAL-DEFINE DBOVersion 1.00.00.000

{bcp/bc0706.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER iprBCTipoTransEquip AS ROWID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-var-equip.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-server-error.

/* Local Variable Definitions ---                                       */
DEFINE BUFFER bfBCEqpto             FOR bc-eqpto.
DEFINE BUFFER bfBCTipoTransEquip    FOR bc-tip-trans-eqpto.
DEFINE BUFFER bfBCTipoTransEquipVar FOR bc-tip-trans-eqpto-var.

DEFINE VARIABLE lReturnError AS LOGICAL NO-UNDO INITIAL NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 9
         WIDTH              = 40.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */
FIND bfBCTipoTransEquip NO-LOCK WHERE
     ROWID(bfBCTipoTransEquip) = iprBCTipoTransEquip NO-ERROR.

IF NOT AVAIL bfBCTipoTransEquip THEN DO:
    RUN insServError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                        INPUT "":U, /* Codigo da Transacao */
                                        INPUT "":U, /* Codigo do Equipamento */
                                        INPUT "":U, /* Codigo da Variavel Datasul */
                                        INPUT "":U, /* Codigo da Variavel Equipamento */
                                        INPUT 0, /* Numero do Erro */
                                        INPUT "Transacao do Equipamento nao foi encontrada.":U, /* Mensagem de Erro */
                                        INPUT "":U). /* Detalhe da Mensagem */
    RETURN "NOK":U.
END.

FIND bfBCEqpto NO-LOCK WHERE
     bfBCEqpto.cod-eqpto = bfBCTipoTransEquip.cod-eqpto NO-ERROR.

IF NOT AVAIL bfBCEqpto THEN DO:
    RUN insServError IN THIS-PROCEDURE (INPUT "":U, /* Codigo do Servidor */
                                        INPUT bfBCTipoTransEquip.cd-trans, /* Codigo da Transacao */
                                        INPUT bfBCTipoTransEquip.cod-eqpto, /* Codigo do Equipamento */
                                        INPUT "":U, /* Codigo da Variavel Datasul */
                                        INPUT "":U, /* Codigo da Variavel Equipamento */
                                        INPUT 0, /* Numero do Erro */
                                        INPUT "Equipamento nao foi encontrado.":U, /* Mensagem de Erro */
                                        INPUT "":U). /* Detalhe da Mensagem */
    RETURN "NOK":U.
END.

FIND FIRST bfBCTipoTransEquipVar NO-LOCK
     WHERE bfBCTipoTransEquipVar.cd-trans = bfBCTipoTransEquip.cd-trans
     AND   bfBCTipoTransEquipVar.cod-eqpto = bfBCTipoTransEquip.cod-eqpto
     AND   bfBCTipoTransEquipVar.log-monitora-var = YES NO-ERROR.

/* Se nao monitorar alguma variavel - Deve retornor NOK para nao gerar a transacao */
IF NOT AVAIL bfBCTipoTransEquipVar THEN
    RETURN "NOK":U.

/* Para "num-gera-trans" igual a 3 - Deve retornar OK indepedente de os
   valores das vari veis terem mudado */
IF bfBCTipoTransEquip.num-gera-trans = 3 THEN
    RETURN "OK":U.


FOR EACH  bfBCTipoTransEquipVar NO-LOCK
    WHERE bfBCTipoTransEquipVar.cd-trans = bfBCTipoTransEquip.cd-trans
    AND   bfBCTipoTransEquipVar.cod-eqpto = bfBCTipoTransEquip.cod-eqpto
    AND   bfBCTipoTransEquipVar.log-monitora-var = YES:

    FIND FIRST tt-var-equip NO-LOCK
         WHERE tt-var-equip.cd-trans      = bfBCTipoTransEquipVar.cd-trans
         AND   tt-var-equip.cod-eqpto     = bfBCTipoTransEquipVar.cod-eqpto
         AND   tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul
         AND   tt-var-equip.valor        <> bfBCTipoTransEquipVar.ind-val-leitura NO-ERROR.

    /* Para "num-gera-trans" igual a 1 - Deve retornar OK se o valor de
       QUALQUER vari vel mudou em rela‡Æo ao valor anterior */
    IF bfBCTipoTransEquip.num-gera-trans = 1 AND AVAIL tt-var-equip THEN
        RETURN "OK":U.

    /* Para "num-gera-trans" igual a 2 - Deve retornar OK somente se o
       valor de TODAS as vari veis mudaram em rela‡Æo aos valores
       anteriores */
    IF bfBCTipoTransEquip.num-gera-trans = 2 AND NOT AVAIL tt-var-equip THEN DO:
        
        ASSIGN lReturnError = YES.
        
        /**
        RUN insServError IN THIS-PROCEDURE (INPUT bfBCEqpto.cod-servid, /* Codigo do Servidor */
                                            INPUT bfBCTipoTransEquipVar.cd-trans, /* Codigo da Transacao */
                                            INPUT bfBCTipoTransEquipVar.cod-eqpto, /* Codigo do Equipamento */
                                            INPUT bfBCTipoTransEquipVar.cod-var-dtsul, /* Codigo da Variavel Datasul */
                                            INPUT bfBCTipoTransEquipVar.cod-var-eqpto, /* Codigo da Variavel Equipamento */
                                            INPUT 0, /* Numero do Erro */
                                            INPUT "A variavel nao teve seu valor alterado e a transacao exige que todas as variaveis tenham seus valores alterados.":U, /* Mensagem de Erro */
                                            INPUT "":U). /* Detalhe da Mensagem */
        **/                                   
    END.
END.

IF bfBCTipoTransEquip.num-gera-trans = 2 
THEN
    IF lReturnError THEN DO:

        /* retornar o valor anterior pois nao foi atendida a regra de todos forem alterados, sem este ajuste nao ir  causar diferenca tem todos os campos monitorados */
        FOR EACH  bfBCTipoTransEquipVar NO-LOCK
            WHERE bfBCTipoTransEquipVar.cd-trans = bfBCTipoTransEquip.cd-trans
            AND   bfBCTipoTransEquipVar.cod-eqpto = bfBCTipoTransEquip.cod-eqpto
            AND   bfBCTipoTransEquipVar.log-monitora-var = YES:

            FIND FIRST tt-var-equip NO-LOCK
                 WHERE tt-var-equip.cd-trans      = bfBCTipoTransEquipVar.cd-trans
                 AND   tt-var-equip.cod-eqpto     = bfBCTipoTransEquipVar.cod-eqpto
                 AND   tt-var-equip.cod-var-dtsul = bfBCTipoTransEquipVar.cod-var-dtsul
                 NO-ERROR.

            IF AVAIL tt-var-equip
            THEN DO:
                ASSIGN tt-var-equip.valor = bfBCTipoTransEquipVar.ind-val-leitura.
            END.

        END.
        /* retornar o valor anterior pois nao foi atendida a regra de todos forem alterados, sem este ajuste nao ir  causar diferenca tem todos os campos monitorados */

        RETURN "NOK":U.

    END.        
    ELSE
        RETURN "OK":U.

/*
RUN insServError IN THIS-PROCEDURE (INPUT bfBCEqpto.cod-servid, /* Codigo do Servidor */
                                    INPUT bfBCTipoTransEquip.cd-trans, /* Codigo da Transacao */
                                    INPUT bfBCTipoTransEquip.cod-eqpto, /* Codigo do Equipamento */
                                    INPUT "":U, /* Codigo da Variavel Datasul */
                                    INPUT "":U, /* Codigo da Variavel Equipamento */
                                    INPUT 0, /* Numero do Erro */
                                    INPUT "Nenhuma variavel teve seu valor alterado e a transacao exige que pelo menos uma variavel tenha seu valor alterado.":U, /* Mensagem de Erro */
                                    INPUT "":U). /* Detalhe da Mensagem */
*/

RETURN "NOK":U.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


