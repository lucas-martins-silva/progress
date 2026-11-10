&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V06IN404 2.00.00.020} /*** "010020" 30/01/2024 14:41:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in404 MUT}
&ENDIF

{cdp/cdcfgdis.i} /*  definiá∆o e prÇ-processadores distribuiá∆o */
 
/*------------------------------------------------------------------------
 
  File:
 
  Description: from VIEWER.W - Template for SmartViewer Objects
 
  Input Parameters:
      <none>
 
  Output Parameters:
      <none>
 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
 
/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
 
CREATE WIDGET-POOL.
 
/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w
 
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */
 
 
/* Local Variable Definitions ---                                       */
 
 
def buffer b-componente for componente.
 
/********* Vari†veis alteradas na PI **************/
def var i-mo-origem        like cotacao.mo-codigo           no-undo.
def var i-mo-destino       like cotacao.mo-codigo           no-undo.
def var de-vl-mat          like item-estab.val-unit-mat-m   no-undo.
def var de-vl-mob          like item-estab.val-unit-mat-m   no-undo.
def var de-vl-ggf          like item-estab.val-unit-ggf-m   no-undo.
def var de-vl-convertido   like pr-it-per.val-unit-mob-m[2] no-undo. 
def var de-vl-origem       like pr-it-per.val-unit-mob-m[1] no-undo.
def var da-dt-cotacao      like saldo-terc.dt-retorno       no-undo.
def var i-cont             as integer                       no-undo.
def var i-tipo-sal-terc    as integer                       no-undo.
 
def var c-it-codigo       like saldo-terc.it-codigo       no-undo.
def var c-cod-estabel     like saldo-terc.cod-estabel     no-undo.
def var c-nat-operacao    like saldo-terc.nat-operacao    no-undo.
def var da-aux            like saldo-terc.dt-retorno      no-undo.    
def var dt-retorno-aux    like saldo-terc.dt-retorno      no-undo.
def var d-quantidade-aux  like saldo-terc.quantidade      no-undo.
def var de-preco          like saldo-terc.valor-mat-m[1]  no-undo.
def var de-quant          like saldo-terc.quantidade      no-undo.
 
def var d-valor-mat       like saldo-terc.valor           no-undo.
def var d-valor-mob       like saldo-terc.valor-mob       no-undo.
def var d-valor-ggf       like saldo-terc.valor-ggf-m     no-undo.
def var d-valor-icm       like saldo-terc.valor-icm       no-undo.
def var d-valor-ipi       like saldo-terc.valor-ipi       no-undo.
 
def new global shared var r-componente as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-terc.char-1 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}char-1 ~{&FP2}char-1 ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS RECT-1 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.char-1 
&Scoped-Define DISPLAYED-OBJECTS d-val-unit-mat1 d-val-unit-ggf1 ~
d-val-unit-mat2 d-val-unit-ggf2 d-val-unit-mat3 d-val-unit-ggf3 ~
d-val-unit-mob1 d-val-unit-mob2 d-val-unit-mob3 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE d-val-unit-ggf1 AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Unit GGF[1]" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-unit-ggf2 AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Unit GGF[2]" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-unit-ggf3 AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Unit GGF[3]" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-unit-mat1 AS DECIMAL FORMAT "->>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Unit Mat[1]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE d-val-unit-mat2 AS DECIMAL FORMAT "->>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Unit Mat[2]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE d-val-unit-mat3 AS DECIMAL FORMAT "->>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Unit Mat[3]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE d-val-unit-mob1 AS DECIMAL FORMAT "->>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Unit MOB[1]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE d-val-unit-mob2 AS DECIMAL FORMAT "->>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor Unit MOB[2]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE VARIABLE d-val-unit-mob3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Valor Unit MOB[3]":R17 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.14 BY 7.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-terc.char-1 AT ROW 1 COL 82 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2 BY 1
     d-val-unit-mat1 AT ROW 1.5 COL 18 COLON-ALIGNED
     d-val-unit-ggf1 AT ROW 1.5 COL 59 COLON-ALIGNED
     d-val-unit-mat2 AT ROW 2.5 COL 18 COLON-ALIGNED
     d-val-unit-ggf2 AT ROW 2.5 COL 59 COLON-ALIGNED
     d-val-unit-mat3 AT ROW 3.5 COL 18 COLON-ALIGNED
     d-val-unit-ggf3 AT ROW 3.5 COL 59 COLON-ALIGNED
     d-val-unit-mob1 AT ROW 4.5 COL 18 COLON-ALIGNED
     d-val-unit-mob2 AT ROW 5.5 COL 18 COLON-ALIGNED
     d-val-unit-mob3 AT ROW 6.5 COL 18 COLON-ALIGNED
     RECT-1 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-terc
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.17
         WIDTH              = 83.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN saldo-terc.char-1 IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN 
       saldo-terc.char-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN d-val-unit-ggf1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-ggf2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-ggf3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mat1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mat2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mat3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mob1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mob2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-val-unit-mob3 IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d-val-unit-ggf1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-ggf1 V-table-Win
ON LEAVE OF d-val-unit-ggf1 IN FRAME f-main /* Valor Unit GGF[1] */
DO:
 /* run pi-consiste-valor (input yes).*/
  /*if param-estoq.tem-moeda1 then do: 
 *      apply "entry" TO d-val-unit-ggf2 IN FRAME {&frame-name}.
 *      return no-apply.
 *   end.   
 *   else 
 *      if param-estoq.tem-moeda2 then do: 
 *         apply "entry" TO d-val-unit-ggf3 IN FRAME {&frame-name}.
 *         return no-apply.
 *      end. */  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-ggf2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-ggf2 V-table-Win
ON LEAVE OF d-val-unit-ggf2 IN FRAME f-main /* Valor Unit GGF[2] */
DO:
   /*if param-estoq.tem-moeda2 then do: 
 *       apply "entry" TO d-val-unit-ggf3 IN FRAME {&frame-name}.
 *       return no-apply.
 *    end.*/   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-ggf3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-ggf3 V-table-Win
ON LEAVE OF d-val-unit-ggf3 IN FRAME f-main /* Valor Unit GGF[3] */
DO:

  /*apply "entry" TO d-val-unit-mat1 IN FRAME {&frame-name}.
 *   return no-apply.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mat1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mat1 V-table-Win
ON LEAVE OF d-val-unit-mat1 IN FRAME f-main /* Valor Unit Mat[1] */
DO:
  /*run pi-consiste-valor (input yes).*/
  
  /*if param-estoq.tem-moeda1 then do: 
 *      apply "entry" TO d-val-unit-mat2 IN FRAME {&frame-name}.
 *      return no-apply.
 *   end.   
 *   else 
 *      if param-estoq.tem-moeda2 then do: 
 *         apply "entry" TO d-val-unit-mat3 IN FRAME {&frame-name}.
 *         return no-apply.
 *      end. */  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mat2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mat2 V-table-Win
ON LEAVE OF d-val-unit-mat2 IN FRAME f-main /* Valor Unit Mat[2] */
DO:
   /*if param-estoq.tem-moeda2 then do: 
 *       apply "entry" TO d-val-unit-mat3 IN FRAME {&frame-name}.
 *       return no-apply.
 *    end.*/   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mat3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mat3 V-table-Win
ON LEAVE OF d-val-unit-mat3 IN FRAME f-main /* Valor Unit Mat[3] */
DO:

   /*apply "entry" TO d-val-unit-mob1 IN FRAME {&frame-name}.
 *    return no-apply.*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mob1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mob1 V-table-Win
ON LEAVE OF d-val-unit-mob1 IN FRAME f-main /* Valor Unit MOB[1] */
DO:

  /*run pi-consiste-valor (input yes).*/
  /*if param-estoq.tem-moeda1 then do: 
 *      apply "entry" TO d-val-unit-mob2 IN FRAME {&frame-name}.
 *      return no-apply.
 *   end.   
 *   else 
 *      if param-estoq.tem-moeda2 then do: 
 *         apply "entry" TO d-val-unit-mob3 IN FRAME {&frame-name}.
 *         return no-apply.
 *      end.*/   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mob2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mob2 V-table-Win
ON LEAVE OF d-val-unit-mob2 IN FRAME f-main /* Valor Unit MOB[2] */
DO:
   /*if param-estoq.tem-moeda2 then do: 
 *       apply "entry" TO d-val-unit-mob3 IN FRAME {&frame-name}.
 *       return no-apply.
 *    end.*/   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME d-val-unit-mob3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-val-unit-mob3 V-table-Win
ON LEAVE OF d-val-unit-mob3 IN FRAME f-main /* Valor Unit MOB[3] */
DO:

   /*apply "entry" TO d-val-unit-ggf1 IN FRAME {&frame-name}.
 *    return no-apply.*/


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  /************************ INTERNAL PROCEDURES ********************/
 
  {utp/ut-liter.i Valor_Unit_Mat}
  assign d-val-unit-mat1:label in frame {&FRAME-NAME} = trim(return-value) + "[1]"
         d-val-unit-mat2:label in frame {&FRAME-NAME} = trim(return-value) + "[2]"
         d-val-unit-mat3:label in frame {&FRAME-NAME} = trim(return-value) + "[3]".
 
  {utp/ut-liter.i Valor_Unit_MOB}       
  assign d-val-unit-mob1:label in frame {&FRAME-NAME} = trim(return-value) + "[1]"
         d-val-unit-mob2:label in frame {&FRAME-NAME} = trim(return-value) + "[2]"
         d-val-unit-mob3:label in frame {&FRAME-NAME} = trim(return-value) + "[3]".
 
  {utp/ut-liter.i Valor_Unit_GGF}       
  assign d-val-unit-ggf1:label in frame {&FRAME-NAME} = trim(return-value) + "[1]"
         d-val-unit-ggf2:label in frame {&FRAME-NAME} = trim(return-value) + "[2]"
         d-val-unit-ggf3:label in frame {&FRAME-NAME} = trim(return-value) + "[3]".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  {include/i-valid.i}
 
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
 
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
 
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
  assign saldo-terc.valor-mat-m[1] = d-valor-mat[1]
         saldo-terc.valor-mat-m[2] = d-valor-mat[2]
         saldo-terc.valor-mat-m[3] = d-valor-mat[3]
         saldo-terc.valor-mob-m[1] = d-valor-mob[1]
         saldo-terc.valor-mob-m[2] = d-valor-mob[2]
         saldo-terc.valor-mob-m[3] = d-valor-mob[3]
         saldo-terc.valor-ggf-m[1] = d-valor-ggf[1]
         saldo-terc.valor-ggf-m[2] = d-valor-ggf[2]
         saldo-terc.valor-ggf-m[3] = d-valor-ggf[3].
 
  if item.tipo-contr = 1 or
     item.tipo-contr = 4 then do:
 
     RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "de-preco-total").           
     assign de-preco = dec(return-value).
 
     RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "quantidade").           
     assign de-quant = dec(return-value).
 
     assign saldo-terc.valor-mat-m[1] = de-preco / 
                                        de-quant.
 
     RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "dt-retorno").
 
     assign da-dt-cotacao  = date(return-value)
            i-mo-origem = 0.
 
     if saldo-terc.valor-mat-m[1] <> 0 then do:
        if param-estoq.tem-moeda1 then do:            
           assign i-mo-destino = 1
           de-vl-origem = saldo-terc.valor-mat-m[1].
 
           {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
           assign saldo-terc.valor-mat-m[2] = de-vl-convertido.        
        end.          
        if param-estoq.tem-moeda2 then do:            
           assign i-mo-destino = 2
                  de-vl-origem = saldo-terc.valor-mat-m[1].
 
           {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
           assign saldo-terc.valor-mat-m[3] = de-vl-convertido.
        end.
     end.                              
  end.                                      
 
  find first estab-mat where estab-mat.cod-estabel = saldo-terc.cod-estabel
       no-lock no-error.
 
  if avail estab-mat then do:              
 
     if estab-mat.usa-on-line then
        do i-cont = 1 to 3:
           assign saldo-terc.valor-mat-o[i-cont] = d-valor-mat[i-cont]
                  saldo-terc.valor-mob-o[i-cont] = d-valor-mob[i-cont]
                  saldo-terc.valor-ggf-o[i-cont] = d-valor-ggf[i-cont].
     end.
     else
        assign saldo-terc.valor-mat-o = 0
               saldo-terc.valor-mob-o = 0
               saldo-terc.valor-ggf-o = 0.
 
  end. 
  find b-componente where rowid(b-componente) = r-componente
    EXCLUSIVE-LOCK NO-ERROR.
 
  /* Determina Tipo Saldo-Terc - i-tipo-sal-terc */
  {cdp/cd4398.i4}
  assign saldo-terc.tipo-sal-terc = i-tipo-sal-terc.
 
 
 
  find first param-global no-lock no-error.
 
  find empresa where
       empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
 
  find first param-fasb
       where param-fasb.ep-codigo = empresa.ep-codigo  no-lock no-error.
 
 
 
  /* ATUALIZA VALORES DOS IMPOSTOS DO SALDO-TERC */
  assign saldo-terc.valor-icm[1] = b-componente.valor-icm[1]
                                 / saldo-terc.quantidade
                                 * int(b-componente.cd-trib-icm = 1
                                    or b-componente.cd-trib-ipi = 4)
         saldo-terc.valor-ipi[1] = b-componente.valor-ipi[1] 
                                 / saldo-terc.quantidade
                                 * int(b-componente.cd-trib-ipi = 1
                                    or b-componente.cd-trib-ipi = 4).
  /* CONVERSAO PARA MOEDA FASB E CMI */         
  if avail param-fasb then do:
     if (param-estoq.moeda1 = param-fasb.moeda-fasb or param-estoq.moeda2  = param-fasb.moeda-fasb)  and
         param-fasb.moeda-fasb <> 0 then do:
 
         assign i-mo-origem  = int(param-estoq.moeda2 = param-fasb.moeda-fasb) + 1
                i-mo-destino = 0
                de-vl-origem = 1.
 
 
         {rep/re0407.i1}     /* Convers∆o de Moedas */
 
         if de-vl-convertido <> 0 then
            assign saldo-terc.valor-icm[2]   = d-valor-icm[1] / de-vl-convertido       
                   saldo-terc.valor-ipi[2]   = d-valor-ipi[1] / de-vl-convertido.
            if avail b-componente then do:
                assign
                   b-componente.base-ipi[2]    = b-componente.base-ipi[1] / de-vl-convertido
                   b-componente.base-icm[2]    = b-componente.base-icm[1] / de-vl-convertido  
                   b-componente.ipi-ntrib[2]   = b-componente.ipi-ntrib[1] / de-vl-convertido
                   b-componente.icm-ntrib[2]   = b-componente.icm-ntrib[1] / de-vl-convertido
                   b-componente.ipi-outras[2]  = b-componente.ipi-outras[1] / de-vl-convertido
                   b-componente.icm-outras[2]  = b-componente.icm-outras[1] / de-vl-convertido
                   b-componente.preco-total[2] = b-componente.preco-total[1] / de-vl-convertido
                   b-componente.valor-ipi[2]   = b-componente.valor-ipi[1] / de-vl-convertido
                   b-componente.valor-icm[2]   = b-componente.valor-icm[1] / de-vl-convertido.
             end.
     end.
 
     if (param-estoq.moeda1 = param-fasb.moeda-cmi or param-estoq.moeda2  = param-fasb.moeda-cmi)  and
         param-fasb.moeda-cmi <> 0 then do:
         assign i-mo-origem  = int(param-estoq.moeda2 = param-fasb.moeda-cmi) + 1
                i-mo-destino = 0
                de-vl-origem = 1.
 
         {rep/re0407.i1}     /* Convers∆o de Moedas */
 
         if de-vl-convertido <> 0 then do:
            assign saldo-terc.vl-icm-cmi     = d-valor-icm[1] / de-vl-convertido       
                   saldo-terc.vl-ipi-cmi     = d-valor-ipi[1] / de-vl-convertido.
            if avail b-componente then 
                assign b-componente.icm-ntr-cmi    = b-componente.base-ipi[1] / de-vl-convertido
                       b-componente.ipi-ntr-cmi    = b-componente.base-icm[1] / de-vl-convertido  
                       b-componente.icm-out-cmi    = b-componente.ipi-ntrib[1] / de-vl-convertido
                       b-componente.ipi-out-cmi    = b-componente.icm-ntrib[1] / de-vl-convertido
                       b-componente.vl-icm-cmi     = d-valor-icm[1] / de-vl-convertido
                       b-componente.vl-ipi-cmi     = d-valor-icm[1] / de-vl-convertido
                       b-componente.pr-total-cmi   = b-componente.preco-total[1] / de-vl-convertido
                       b-componente.base-icm-cmi   = b-componente.base-icm[1] / de-vl-convertido
                       b-componente.base-ipi-cmi   = b-componente.base-ipi[1] / de-vl-convertido.
         end.  
     end.
   end.     
 
 
   /*  atualizaá∆o da relaá∆o Item X Estabelecimento */
 
   find item-estab where item-estab.it-codigo   = saldo-terc.it-codigo    and
                         item-estab.cod-estabel = saldo-terc.cod-estabel  no-lock no-error.
 
   if not avail item-estab then do:
      create item-estab.
      assign item-estab.cod-estabel  = saldo-terc.cod-estabel
             item-estab.deposito-pad = item.deposito-pad
             item-estab.it-codigo    = saldo-terc.it-codigo.
   end.          
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
 
 
  disable d-val-unit-mat1
          d-val-unit-mat2
          d-val-unit-mat3
          d-val-unit-mob1
          d-val-unit-mob2
          d-val-unit-mob3
          d-val-unit-ggf1
          d-val-unit-ggf2
          d-val-unit-ggf3
          with frame {&frame-name}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var d-mob1 as decimal format "->>>>,>>>,>>9.99".
def var d-mob2 as decimal format "->>>>,>>>,>>9.99".
def var d-mob3 as decimal format "->>>>,>>>,>>9.99".
 
def var d-mat1 as decimal format "->>>>,>>>,>>9.99".
def var d-mat2 as decimal format "->>>>,>>>,>>9.99".
def var d-mat3 as decimal format "->>>>,>>>,>>9.99".
 
def var d-ggf1 as decimal format "->>>>,>>>,>>9.99".
def var d-ggf2 as decimal format "->>>>,>>>,>>9.99".
def var d-ggf3 as decimal format "->>>>,>>>,>>9.99".
 

 
  /* Code placed here will execute PRIOR to standard behavior. */
 
if d-val-unit-mat1:sensitive in frame {&frame-name} = no and
   d-val-unit-mat2:sensitive in frame {&frame-name} = no then do:
 
  if avail saldo-terc then
     assign d-val-unit-mat1 = saldo-terc.valor-mat-m[1]
            d-val-unit-mat2 = saldo-terc.valor-mat-m[2]
            d-val-unit-mat3 = saldo-terc.valor-mat-m[3]
            d-val-unit-mob1 = saldo-terc.valor-mob-m[1]
            d-val-unit-mob2 = saldo-terc.valor-mob-m[2]
            d-val-unit-mob3 = saldo-terc.valor-mob-m[3]
            d-val-unit-ggf1 = saldo-terc.valor-ggf-m[1]
            d-val-unit-ggf2 = saldo-terc.valor-ggf-m[2]
            d-val-unit-ggf3 = saldo-terc.valor-ggf-m[3].
  else do:
     find first pr-it-per where pr-it-per.it-codigo = saldo-terc.it-codigo no-lock no-error.
     if avail pr-it-per then
        assign d-val-unit-mat1 = pr-it-per.val-unit-mat-m[1]
               d-val-unit-mat2 = pr-it-per.val-unit-mat-m[2]
               d-val-unit-mat3 = pr-it-per.val-unit-mat-m[3]
               d-val-unit-mob1 = pr-it-per.val-unit-mob-m[1]
               d-val-unit-mob2 = pr-it-per.val-unit-mob-m[2]
               d-val-unit-mob3 = pr-it-per.val-unit-mob-m[3]
               d-val-unit-ggf1 = pr-it-per.val-unit-ggf-m[1]
               d-val-unit-ggf2 = pr-it-per.val-unit-ggf-m[2]
               d-val-unit-ggf3 = pr-it-per.val-unit-ggf-m[3].
 
     else 
        assign d-val-unit-mat1 = 0
               d-val-unit-mat2 = 0
               d-val-unit-mat3 = 0
               d-val-unit-mob1 = 0
               d-val-unit-mob2 = 0
               d-val-unit-mob3 = 0
               d-val-unit-ggf1 = 0
               d-val-unit-ggf2 = 0
               d-val-unit-ggf3 = 0.
  end.          
end.
  assign d-mat1 = input frame {&frame-name} d-val-unit-mat1
         d-mat2 = input frame {&frame-name} d-val-unit-mat2
         d-mat3 = input frame {&frame-name} d-val-unit-mat3
         d-mob1 = input frame {&frame-name} d-val-unit-mob1 
         d-mob2 = input frame {&frame-name} d-val-unit-mob2 
         d-mob3 = input frame {&frame-name} d-val-unit-mob3
         d-ggf1 = input frame {&frame-name} d-val-unit-ggf1 
         d-ggf2 = input frame {&frame-name} d-val-unit-ggf2 
         d-ggf3 = input frame {&frame-name} d-val-unit-ggf3
         . 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
if d-val-unit-mat1:sensitive in frame {&frame-name} = yes or
   d-val-unit-mat2:sensitive in frame {&frame-name} = yes then do:
      assign d-val-unit-mat1 = d-mat1
             d-val-unit-mat2 = d-mat2
             d-val-unit-mat3 = d-mat3 
             d-val-unit-mob1 = d-mob1 
             d-val-unit-mob2 = d-mob2 
             d-val-unit-mob3 = d-mob3 
             d-val-unit-ggf1 = d-ggf1 
             d-val-unit-ggf2 = d-ggf2 
             d-val-unit-ggf3 = d-ggf3.
 
      display d-val-unit-mat1
              d-val-unit-mat2 
              d-val-unit-mat3 
              d-val-unit-mob1 
              d-val-unit-mob2 
              d-val-unit-mob3 
              d-val-unit-ggf1 
              d-val-unit-ggf2 
              d-val-unit-ggf3 
              with frame {&frame-name}. 
end.  
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-valor V-table-Win 
PROCEDURE pi-consiste-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def input parameter l-sensitive-codigo as logical.
 
find first param-estoq no-lock no-error.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "dt-retorno").
assign dt-retorno-aux = date(return-value)
       da-dt-cotacao  = date(return-value)
       da-aux         = date(return-value).    
 
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").       
assign c-it-codigo = return-value. 
 
find first item where item.it-codigo = c-it-codigo no-lock no-error.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").
 
 
find first natur-oper where natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").      
assign c-cod-estabel = return-value.
 
if avail item  and  avail natur-oper  then do:
 
  IF dt-retorno-aux <= param-estoq.mensal-ate and item.tipo-contr = 2 THEN DO:
 
      assign da-aux = if month(dt-retorno-aux) = 12 then 
                          (date(01,01,(year(dt-retorno-aux) + 1)) - 1)
                      else      
                          (date((month(dt-retorno-aux) + 1), 01, year(dt-retorno-aux)) - 1).
 
      assign da-aux = if da-aux > param-estoq.mensal-ate then
                          param-estoq.mensal-ate
                      else
                          da-aux.                                                  
 
      assign i-mo-origem = 0              
             de-vl-mat   = 0
             de-vl-mob   = 0
             de-vl-ggf   = 0.                      
 
 
     if param-estoq.log-fechto-geren then do:
          FIND LAST pr-it-per WHERE pr-it-per.it-codigo              = c-it-codigo       AND
                                    pr-it-per.cod-estabel            = c-cod-estabel     AND
                                    pr-it-per.periodo                >= dt-retorno-aux   AND
                                    pr-it-per.periodo                <= da-aux           AND 
                                   (pr-it-per.val-unit-mat-m[1] +
                                    pr-it-per.val-unit-mob-m[1] +
                                    pr-it-per.val-unit-ggf-m[1])     > 0                 NO-LOCK NO-ERROR.
      end.
      else do:
          find last pr-it-per where pr-it-per.it-codigo   = c-it-codigo     and
                                    pr-it-per.cod-estabel = c-cod-estabel   and
                                    pr-it-per.periodo     >= dt-retorno-aux and
                                    pr-it-per.periodo     <= da-aux         no-lock no-error.
      end.
 
 
     if not avail pr-it-per then do:                                               
        if l-sensitive-codigo then
           enable d-val-unit-mat1 with frame {&frame-name}.
 
        if input frame {&frame-name} d-val-unit-mat1 <> 0 then do:
 
           if param-estoq.tem-moeda1 then do:            
              assign i-mo-destino = 1
                     de-vl-origem = input frame {&frame-name} d-val-unit-mat1.
 
              {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
              if l-sensitive-codigo then
                 enable d-val-unit-mat2 with frame {&frame-name}.
              assign d-val-unit-mat2:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
           if param-estoq.tem-moeda2 then do:            
              assign i-mo-destino = 2
                     de-vl-origem = input frame {&frame-name} d-val-unit-mat1.
 
              {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
              if l-sensitive-codigo then
                 enable d-val-unit-mat3 with frame {&frame-name}.
              assign d-val-unit-mat3:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
        end. /* d-val-unit-mat1 */
 
        if l-sensitive-codigo then
           enable d-val-unit-mob1 with frame {&frame-name}.
 
        if input frame {&frame-name} d-val-unit-mob1 <> 0 then do:
 
           if param-estoq.tem-moeda1 then do:
               assign i-mo-destino = 1
                     de-vl-origem = input frame {&frame-name} d-val-unit-mob1.
 
               {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
               if l-sensitive-codigo then
                  enable d-val-unit-mob2 with frame {&frame-name}.
               assign d-val-unit-mob2:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
           if param-estoq.tem-moeda2 then do:            
              assign i-mo-destino = 2
                     de-vl-origem = input frame {&frame-name} d-val-unit-mob1.
 
              {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
              if l-sensitive-codigo then
                 enable d-val-unit-mob3 with frame {&frame-name}.
              assign d-val-unit-mob3:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
        end. /* d-val-unit-mob1 */
 
        if l-sensitive-codigo then
           enable d-val-unit-ggf1 with frame {&frame-name}.
 
        if input frame {&frame-name} d-val-unit-ggf1 <> 0 then do:
 
           if param-estoq.tem-moeda1 then do:
               assign i-mo-destino = 1
                     de-vl-origem = input frame {&frame-name} d-val-unit-ggf1.
 
               {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
               if l-sensitive-codigo then
                  enable d-val-unit-ggf2 with frame {&frame-name}.
               assign d-val-unit-ggf2:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
           if param-estoq.tem-moeda2 then do:            
              assign i-mo-destino = 2
                     de-vl-origem = input frame {&frame-name} d-val-unit-ggf1.
 
              {rep/re0407.i1}   /*** Convers∆o de Moedas ***/
 
              if l-sensitive-codigo then
                 enable d-val-unit-ggf3 with frame {&frame-name}.
              assign d-val-unit-ggf3:screen-value in frame {&frame-name} = string(de-vl-convertido).        
           end.
 
        end. /* d-val-unit-ggf1 */
 
 
     end. /*  pr-it-per */        
     else do:
        assign  d-val-unit-mat1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[1])
                d-val-unit-mat2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[2])
                d-val-unit-mat3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[3])
                d-val-unit-mob1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[1])
                d-val-unit-mob2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[2])
                d-val-unit-mob3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[3])
                d-val-unit-ggf1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[1])
                d-val-unit-ggf2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[2])
                d-val-unit-ggf3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[3]).
        disable d-val-unit-mat1
                d-val-unit-mat2
                d-val-unit-mat3
                d-val-unit-mob1
                d-val-unit-mob2
                d-val-unit-mob3 
                d-val-unit-ggf1
                d-val-unit-ggf2
                d-val-unit-ggf3 with frame {&frame-name}.
     end. /* else */           
  END.   
end.
else
    disable d-val-unit-mat1
            d-val-unit-mat2
            d-val-unit-mat3
            d-val-unit-mob1
            d-val-unit-mob2
            d-val-unit-mob3
            d-val-unit-ggf1
            d-val-unit-ggf2
            d-val-unit-ggf3 with frame {&frame-name}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-valores V-table-Win 
PROCEDURE pi-habilita-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 
find first param-estoq no-lock no-error.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "dt-retorno").
assign dt-retorno-aux = date(return-value)
       da-dt-cotacao  = date(return-value)
       da-aux         = date(return-value).    
 
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").       
assign c-it-codigo = return-value. 
 
find first item where item.it-codigo = c-it-codigo no-lock no-error.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
  assign c-nat-operacao = return-value.
  assign c-nat-operacao = replace(c-nat-operacao,".","").
  assign c-nat-operacao = replace(c-nat-operacao,"-","").
 
 
find first natur-oper where natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").      
assign c-cod-estabel = return-value.

if avail item  and  avail natur-oper  then do:
          
  if dt-retorno-aux <= param-estoq.mensal-ate and item.tipo-contr = 2 THEN DO:
     
      assign da-aux = if month(dt-retorno-aux) = 12 then 
                          (date(01,01,(year(dt-retorno-aux) + 1)) - 1)
                      else      
                          (date((month(dt-retorno-aux) + 1), 01, year(dt-retorno-aux)) - 1).
 
      assign da-aux = if da-aux > param-estoq.mensal-ate then
                          param-estoq.mensal-ate
                      else
                          da-aux.                                                  
 
      assign i-mo-origem = 0              
             de-vl-mat   = 0
             de-vl-mob   = 0
             de-vl-ggf   = 0.                      
 
 
     if param-estoq.log-fechto-geren then do:
         FIND LAST pr-it-per WHERE pr-it-per.it-codigo              = c-it-codigo       AND
                                   pr-it-per.cod-estabel            = c-cod-estabel     AND
                                   pr-it-per.periodo                >= dt-retorno-aux   AND
                                   pr-it-per.periodo                <= da-aux           AND 
                                  (pr-it-per.val-unit-mat-m[1] +
                                   pr-it-per.val-unit-mob-m[1] +
                                   pr-it-per.val-unit-ggf-m[1])     > 0                 NO-LOCK NO-ERROR.
     end.
     else do:
         find last pr-it-per where pr-it-per.it-codigo   = c-it-codigo     and
                                   pr-it-per.cod-estabel = c-cod-estabel   and
                                   pr-it-per.periodo     >= dt-retorno-aux and
                                   pr-it-per.periodo     <= da-aux         no-lock no-error.
     end.
     
     if  not avail pr-it-per then do:                                               
         enable d-val-unit-mat1 with frame {&frame-name}.
         if param-estoq.tem-moeda1 then 
            enable d-val-unit-mat2 with frame {&frame-name}.
         if param-estoq.tem-moeda2 then            
            enable d-val-unit-mat3 with frame {&frame-name}.
       
         enable d-val-unit-mob1 with frame {&frame-name}.
         if param-estoq.tem-moeda1 then 
            enable d-val-unit-mob2 with frame {&frame-name}.
         if param-estoq.tem-moeda2 then            
            enable d-val-unit-mob3 with frame {&frame-name}.
 
         enable d-val-unit-ggf1 with frame {&frame-name}.
         if param-estoq.tem-moeda1 then 
            enable d-val-unit-ggf2 with frame {&frame-name}.
         if param-estoq.tem-moeda2 then           
            enable d-val-unit-ggf3 with frame {&frame-name}.
  
     end. /*  pr-it-per */        
     else do:
         assign  d-val-unit-mat1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[1])
                 d-val-unit-mat2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[2])
                 d-val-unit-mat3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mat-m[3])
                 d-val-unit-mob1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[1])
                 d-val-unit-mob2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[2])
                 d-val-unit-mob3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-mob-m[3])
                 d-val-unit-ggf1:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[1])
                 d-val-unit-ggf2:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[2])
                 d-val-unit-ggf3:screen-value in frame {&frame-name} = string(pr-it-per.val-unit-ggf-m[3]).
         disable d-val-unit-mat1
                 d-val-unit-mat2
                 d-val-unit-mat3
                 d-val-unit-mob1
                 d-val-unit-mob2
                 d-val-unit-mob3 
                 d-val-unit-ggf1
                 d-val-unit-ggf2
                 d-val-unit-ggf3 with frame {&frame-name}.
     end. /* else */           
  end.
  else do:
     disable d-val-unit-mat1
             d-val-unit-mat2
             d-val-unit-mat3
             d-val-unit-mob1
             d-val-unit-mob2
             d-val-unit-mob3
             d-val-unit-ggf1
             d-val-unit-ggf2
             d-val-unit-ggf3 with frame {&frame-name}.
   end.          
end.
else
    disable d-val-unit-mat1
            d-val-unit-mat2
            d-val-unit-mat3
            d-val-unit-mob1
            d-val-unit-mob2
            d-val-unit-mob3
            d-val-unit-ggf1
            d-val-unit-ggf2
            d-val-unit-ggf3 with frame {&frame-name}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
 
   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
/*run pi-consiste-valor (input yes).*/
 
if d-val-unit-mat2:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-mat2 < 0 then do:
 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-mat[2] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-mat2.
      return 'ADM-ERROR':U.
end.
 
if d-val-unit-mat3:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-mat3 < 0 then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-mat[3] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-mat3.
      return 'ADM-ERROR':U.
end. 
 
if d-val-unit-mob2:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-mob2 < 0 then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-mob[2] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-mob2.
      return 'ADM-ERROR':U.
end.
 
if d-val-unit-mob3:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-mob3 < 0 then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-mob[3] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-mob3.
      return 'ADM-ERROR':U.
end. 
 
if d-val-unit-ggf2:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-ggf2 < 0 then do:
 
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-ggf[2] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-ggf2.
      return 'ADM-ERROR':U.
end.
 
if d-val-unit-ggf3:sensitive in frame {&frame-name} = yes and
    input frame {&frame-name} d-val-unit-ggf3 < 0 then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgind pr-it-per val-unit-ggf[3] 1}
      run utp/ut-msgs.p (input "show":U, input 6179, input string(return-value)).
      apply 'entry' to input frame {&frame-name} d-val-unit-ggf3.
      return 'ADM-ERROR':U.
end. 
 
 
find first param-estoq no-lock no-error.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "quantidade").
 
assign d-quantidade-aux = dec(return-value).
 
RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").
 
find item where item.it-codigo = return-value no-lock no-error.
 
if avail item then  do:
   RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "dt-retorno").
 
   if date(return-value) <= param-estoq.mensal-ate and item.tipo-contr = 2 
   then do:
      
      if param-estoq.log-fechto-geren then do:
          FIND LAST pr-it-per WHERE pr-it-per.it-codigo              = c-it-codigo       AND
                                    pr-it-per.cod-estabel            = c-cod-estabel     AND
                                    pr-it-per.periodo                >= dt-retorno-aux   AND
                                    pr-it-per.periodo                <= da-aux           AND 
                                   (pr-it-per.val-unit-mat-m[1] +
                                    pr-it-per.val-unit-mob-m[1] +
                                    pr-it-per.val-unit-ggf-m[1])     > 0                 NO-LOCK NO-ERROR.
      end.
      else do:
          find last pr-it-per where pr-it-per.it-codigo   = c-it-codigo     and
                                    pr-it-per.cod-estabel = c-cod-estabel   and
                                    pr-it-per.periodo     >= dt-retorno-aux and
                                    pr-it-per.periodo     <= da-aux         no-lock no-error.
      end.
 
      if avail pr-it-per then 
          assign d-valor-mat[1] = pr-it-per.val-unit-mat-m[1]
                 d-valor-mat[2] = pr-it-per.val-unit-mat-m[2]
                 d-valor-mat[3] = pr-it-per.val-unit-mat-m[3]
                 d-valor-mob[1] = pr-it-per.val-unit-mob-m[1]
                 d-valor-mob[2] = pr-it-per.val-unit-mob-m[2]
                 d-valor-mob[3] = pr-it-per.val-unit-mob-m[3]
                 d-valor-ggf[1] = pr-it-per.val-unit-ggf-m[1]
                 d-valor-ggf[2] = pr-it-per.val-unit-ggf-m[2]
                 d-valor-ggf[3] = pr-it-per.val-unit-ggf-m[3].
 
 
      else do:
         if (input frame {&frame-name} d-val-unit-mat1 + 
         input frame {&frame-name} d-val-unit-mob1)    <= 0 then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, input 1538, input "").
            apply 'entry' to input frame {&frame-name} d-val-unit-mob1.
            return 'ADM-ERROR':U.
         end.
         assign  d-valor-mat[1] = input frame {&frame-name} d-val-unit-mat1
                 d-valor-mat[2] = input frame {&frame-name} d-val-unit-mat2
                 d-valor-mat[3] = input frame {&frame-name} d-val-unit-mat3
                 d-valor-mob[1] = input frame {&frame-name} d-val-unit-mob1
                 d-valor-mob[2] = input frame {&frame-name} d-val-unit-mob2
                 d-valor-mob[3] = input frame {&frame-name} d-val-unit-mob3
                 d-valor-ggf[1] = input frame {&frame-name} d-val-unit-ggf1
                 d-valor-ggf[2] = input frame {&frame-name} d-val-unit-ggf2
                 d-valor-ggf[3] = input frame {&frame-name} d-val-unit-ggf3. 
      end.
   end.
   else do:
      if item.tipo-contr <> 2 /*or natur-oper.oper-terc = 2*/ then do:
         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "de-preco-total").     
 
 
         /**** N∆o Ç necess†rio para beneficiamento ****
 
         assign d-valor-mat[1] = dec(return-value) / d-quantidade-aux .
 
         if param-estoq.tem-moeda1 then do:
            assign i-mo-destino = 1
                   de-vl-origem = d-valor[1].
 
            {rep/re0407.i1}    /*  Convers∆o de Moedas  */       
 
            assign d-valor-mat[2] = de-vl-convertido.
 
            if d-valor-mat[2] = 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U, input 15277, input "").
                apply 'entry' to input frame {&frame-name} d-val-unit-mat2.
                return 'ADM-ERROR':U.
            end.
         end.
         if param-estoq.tem-moeda2 then do:
            assign i-mo-destino =  2
                   de-vl-origem = d-valor[1].
 
            {rep/re0407.i1}    /*  onvers∆o de Moedas  */   
 
            assign d-valor-mat[3] = de-vl-convertido.
 
            if d-valor-mat[3] = 0 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U, input 6343, input "").
                apply 'entry' to input frame {&frame-name} d-val-unit-mat3.
                return 'ADM-ERROR':U.
            end.
         end.
         *******************************************************************/
      end.                
   end.
end. 
 
          /**************  Atualiza Valores dos Impostos do Saldo-Terc  ***************/
 
RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "valor-icm").
 
assign d-valor-icm[1] =  dec(return-value).
 
RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "valor-ipi").
 
assign d-valor-ipi[1] =  dec(return-value).
 
RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "cb-cd-trib-icm").
 
if return-value = {ininc/i07in122.i 04 01} or return-value = {ininc/i07in122.i 04 04} then
   assign d-valor-icm[1] =  d-valor-icm[1] / d-quantidade-aux *  1
          d-valor-ipi[1] =  d-valor-ipi[1] / d-quantidade-aux *  1.
else         
   assign d-valor-icm[1] =  d-valor-icm[1] / d-quantidade-aux *  0
          d-valor-ipi[1] =  d-valor-ipi[1] / d-quantidade-aux *  0.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "saldo-terc"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
 
  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


