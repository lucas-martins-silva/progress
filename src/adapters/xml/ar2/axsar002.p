/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXSAR002 2.00.00.006}  /*** 010006 ***/


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : AXSAR002.p
    Purpose     : ENVIO DE PREÄO MêDIO DO ITEM

    Syntax      :

    Description : ADAPTER DE ENVIO DE PREÄO MêDIO DO ITEM
    CREATEd     : 09/03/2004 10:30
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was CREATEd with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* **********************  Definitions  *********************** */

/* PrÇ-Processadores*/
&GLOBAL-DEFINE XmlTranName      ItemCosting
&GLOBAL-DEFINE XmlTranVersion   204.000
&GLOBAL-DEFINE XmlProdName      EMS2
&GLOBAL-DEFINE XmlProdVersion   204
&GLOBAL-DEFINE XmlApp           AR2 
&GLOBAL-DEFINE XmlMod           MCE
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 299.999


/* Definiá∆o das temp-tables tt-item, tt-item-estab e tt-saldo-custo */
{adapters/xml/ar2/axsar002.i}


/* Definiá∆o temp-table RowErrors */
{cdp/cd9043.i}
{cdp/cd9043.i1}

/* ParÉmetros de entrada */
DEF INPUT  PARAM pProgName    AS CHAR    NO-UNDO.
DEF INPUT  PARAM pProgVersion AS CHAR    NO-UNDO.

{adapters/xml/ar2/axsar002.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  CREATE Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 25.46
         WIDTH              = 36.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Estas validaá‰es abaixo precisam ficar no main-block do programa */

/* Verifica se MessageHandler.p est† na mem¢ria */
{xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cMHReturnValue"}

/* Verifica se API est† na mem¢ria */
{xmlinc/xmlloadgenxml.i &GenXml="hGenXml" &GXReturnValue="cGXReturnValue"}

{adapters/xml/ar2/axsar002.i1} /* PROCEDURE SendMessage */

{adapters/xml/ar2/axsar002.i2} /* PROCEDURE SendMessageByItemRowid */

{adapters/xml/ar2/axsar002.i3} /* PROCEDURE GetErrors */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
