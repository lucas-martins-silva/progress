&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V01IN622 2.00.00.019 } /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN622 MUT}
&ENDIF



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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{include/i-vrtab.i aprovador}
{include/i-vrtab.i moeda}

    {cdp/cd0669.i} /** Defini‡Æo da tt-erro **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES Aprovador
&Scoped-define FIRST-EXTERNAL-TABLE Aprovador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR Aprovador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS aprovador.aprov-tec aprovador.mo-codigo ~
aprovador.mestre aprovador.perm-solic aprovador.lim-solic ~
aprovador.perm-requis aprovador.lim-requis aprovador.perm-cotac ~
aprovador.lim-cotac aprovador.perm-pedido aprovador.lim-pedido ~
aprovador.perm-manut aprovador.lim-req-manut aprovador.log-1 ~
aprovador.dec-1 aprovador.log-2 aprovador.dec-2 aprovador.lim-medic ~
aprovador.perm-medic aprovador.lim-event aprovador.perm-contdoc ~
aprovador.perm-event 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}mo-codigo ~{&FP2}mo-codigo ~{&FP3}~
 ~{&FP1}lim-solic ~{&FP2}lim-solic ~{&FP3}~
 ~{&FP1}lim-requis ~{&FP2}lim-requis ~{&FP3}~
 ~{&FP1}lim-cotac ~{&FP2}lim-cotac ~{&FP3}~
 ~{&FP1}lim-pedido ~{&FP2}lim-pedido ~{&FP3}~
 ~{&FP1}lim-req-manut ~{&FP2}lim-req-manut ~{&FP3}~
 ~{&FP1}dec-1 ~{&FP2}dec-1 ~{&FP3}~
 ~{&FP1}dec-2 ~{&FP2}dec-2 ~{&FP3}~
 ~{&FP1}lim-medic ~{&FP2}lim-medic ~{&FP3}~
 ~{&FP1}lim-event ~{&FP2}lim-event ~{&FP3}
&Scoped-define ENABLED-TABLES aprovador
&Scoped-define FIRST-ENABLED-TABLE aprovador
&Scoped-Define ENABLED-OBJECTS rt-key RECT-4 RECT-9 RECT-3 RECT-5 ~
de-lim-contdoc 
&Scoped-Define DISPLAYED-FIELDS aprovador.cod-aprov aprovador.des-aprov ~
aprovador.aprov-tec aprovador.mo-codigo aprovador.mestre ~
aprovador.perm-solic aprovador.lim-solic aprovador.perm-requis ~
aprovador.lim-requis aprovador.perm-cotac aprovador.lim-cotac ~
aprovador.perm-pedido aprovador.lim-pedido aprovador.perm-manut ~
aprovador.lim-req-manut aprovador.log-1 aprovador.dec-1 aprovador.log-2 ~
aprovador.dec-2 aprovador.lim-medic aprovador.perm-medic ~
aprovador.lim-event aprovador.perm-contdoc aprovador.perm-event 
&Scoped-Define DISPLAYED-OBJECTS c_des_moeda de-lim-contdoc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS aprovador.cod-aprov aprovador.des-aprov 
&Scoped-define ADM-MODIFY-FIELDS aprovador.cod-aprov 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-aprov|y|y|mgind.Aprovador.cod-aprov
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "cod-aprov",
     Keys-Supplied = "cod-aprov"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c_des_moeda AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88.

DEFINE VARIABLE de-lim-contdoc AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Limite Aprov Docto Contrato" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 8.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29.14 BY 2.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.29 BY 8.71.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.29 BY 2.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.29 BY 1.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     aprovador.cod-aprov AT ROW 1.25 COL 19.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .88
     aprovador.des-aprov AT ROW 1.25 COL 36.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     aprovador.aprov-tec AT ROW 2.88 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 20.72 BY .83
     aprovador.mo-codigo AT ROW 3.25 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     c_des_moeda AT ROW 3.25 COL 63.29 COLON-ALIGNED NO-LABEL
     aprovador.mestre AT ROW 3.88 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     aprovador.perm-solic AT ROW 5.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .88
     aprovador.lim-solic AT ROW 5.5 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.perm-requis AT ROW 6.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .88
     aprovador.lim-requis AT ROW 6.5 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.perm-cotac AT ROW 7.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .88
     aprovador.lim-cotac AT ROW 7.5 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.perm-pedido AT ROW 8.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .88
     aprovador.lim-pedido AT ROW 8.5 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.perm-manut AT ROW 9.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .88
     aprovador.lim-req-manut AT ROW 9.5 COL 59.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.log-1 AT ROW 10.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     aprovador.dec-1 AT ROW 10.5 COL 59.43 COLON-ALIGNED FORMAT "->>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.log-2 AT ROW 11.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.29 BY .83
     aprovador.dec-2 AT ROW 11.5 COL 59.43 COLON-ALIGNED FORMAT "->>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     aprovador.lim-medic AT ROW 12.42 COL 61.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY 1
     aprovador.perm-medic AT ROW 12.46 COL 14.14
          VIEW-AS TOGGLE-BOX
          SIZE 12.57 BY .83
     aprovador.lim-event AT ROW 12.46 COL 66.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY 1
     aprovador.perm-contdoc AT ROW 12.5 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .83
     de-lim-contdoc AT ROW 12.5 COL 59.43 COLON-ALIGNED
     aprovador.perm-event AT ROW 12.67 COL 11.72
          VIEW-AS TOGGLE-BOX
          SIZE 11.14 BY .83
     rt-key AT ROW 1 COL 1
     RECT-4 AT ROW 2.63 COL 1
     RECT-9 AT ROW 2.63 COL 31
     RECT-3 AT ROW 5.13 COL 1
     RECT-5 AT ROW 5.13 COL 31
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.Aprovador
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 12.83
         WIDTH              = 88.29.
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

/* SETTINGS FOR FILL-IN aprovador.cod-aprov IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c_des_moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN aprovador.dec-1 IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN aprovador.dec-2 IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN aprovador.des-aprov IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME aprovador.cod-aprov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.cod-aprov V-table-Win
ON F5 OF aprovador.cod-aprov IN FRAME f-main /* C¢digo Aprovador */
DO:
assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in627.w 
                     &campo=mgind.aprovador.cod-aprov
                     &campozoom=cod-usuario}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.cod-aprov V-table-Win
ON LEAVE OF aprovador.cod-aprov IN FRAME f-main /* C¢digo Aprovador */
DO:

  {include/leave.i &tabela=usuar-mater
                   &atributo-ref=nome-usuar                 
                   &variavel-ref=mgind.aprovador.des-aprov
                   &where="usuar-mater.cod-usuario = input frame {&frame-name} aprovador.cod-aprov"} 
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.cod-aprov V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aprovador.cod-aprov IN FRAME f-main /* C¢digo Aprovador */
DO:

    apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.log-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.log-1 V-table-Win
ON VALUE-CHANGED OF aprovador.log-1 IN FRAME f-main /* log-1 */
DO:
  if aprovador.log-1:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.dec-1 with frame {&frame-name}.
  end.
  else do:
       disable aprovador.dec-1 with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.log-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.log-2 V-table-Win
ON VALUE-CHANGED OF aprovador.log-2 IN FRAME f-main /* log-2 */
DO:
  if aprovador.log-2:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.dec-2 with frame {&frame-name}.
  end.
  else do:
       disable aprovador.dec-2 with frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.mo-codigo V-table-Win
ON F5 OF aprovador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  assign l-implanta = yes.
  
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w 
                     &campo=aprovador.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.mo-codigo V-table-Win
ON LEAVE OF aprovador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao                   
                   &variavel-ref=c_des_moeda
                   &where="moeda.mo-codigo = input frame {&frame-name} aprovador.mo-codigo"} 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aprovador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w 
                     &campo=aprovador.mo-codigo
                     &campozoom=mo-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-contdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-contdoc V-table-Win
ON VALUE-CHANGED OF aprovador.perm-contdoc IN FRAME f-main /* T‚cnica Contratos */
DO:
  &if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}: 
    assign de-lim-contdoc:screen-value in frame {&frame-name} = "0".
    if aprovador.perm-contdoc:checked in frame {&frame-name} then 
         assign de-lim-contdoc:sensitive in frame {&frame-name} = yes.
    else assign de-lim-contdoc:sensitive in frame {&frame-name} = no.
  &endif  
      
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-cotac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-cotac V-table-Win
ON VALUE-CHANGED OF aprovador.perm-cotac IN FRAME f-main /* Aprova Cota‡Æo */
DO:
  if aprovador.perm-cotac:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.lim-cotac with frame {&frame-name}.
  end.
  else do:
       disable aprovador.lim-cotac with frame {&frame-name}. 
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-event
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-event V-table-Win
ON VALUE-CHANGED OF aprovador.perm-event IN FRAME f-main /* Eventos */
DO:
    &if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}:
        assign aprovador.lim-event:screen-value in frame {&frame-name} = "0".
        if aprovador.perm-event:checked in frame {&frame-name} then 
             assign aprovador.lim-event:sensitive in frame {&frame-name} = yes.
        else assign aprovador.lim-event:sensitive in frame {&frame-name} = no.     
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-manut V-table-Win
ON VALUE-CHANGED OF aprovador.perm-manut IN FRAME f-main /* Aprova Manuten‡Æo */
DO:
  
  if aprovador.perm-manut:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.lim-req-manut with frame {&frame-name}.
  end.
  else do:
       disable aprovador.lim-req-manut with frame {&frame-name}.
  end.


  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-medic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-medic V-table-Win
ON VALUE-CHANGED OF aprovador.perm-medic IN FRAME f-main /* Medi‡äes */
DO:
    &if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}:
        assign aprovador.lim-medic:screen-value in frame {&frame-name} = "0".
        if aprovador.perm-medic:checked in frame {&frame-name} then 
             assign aprovador.lim-medic:sensitive in frame {&frame-name} = yes.
        else assign aprovador.lim-medic:sensitive in frame {&frame-name} = no. 
    &endif        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-pedido V-table-Win
ON VALUE-CHANGED OF aprovador.perm-pedido IN FRAME f-main /* Aprova Pedido */
DO:
  if aprovador.perm-pedid:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.lim-pedid with frame {&frame-name}.
  end.
  else do:
       disable aprovador.lim-pedid with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-requis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-requis V-table-Win
ON VALUE-CHANGED OF aprovador.perm-requis IN FRAME f-main /* Aprova Requisi‡Æo */
DO:
  if aprovador.perm-requis:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.lim-requis with frame {&frame-name}.
  end.
  else do:
       disable aprovador.lim-requis with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aprovador.perm-solic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aprovador.perm-solic V-table-Win
ON VALUE-CHANGED OF aprovador.perm-solic IN FRAME f-main /* Aprova Solic Compras */
DO:
  
  if aprovador.perm-solic:checked in frame {&frame-name} = yes
  then do:
       enable aprovador.lim-solic with frame {&frame-name}.
  end.
  else do:
       disable aprovador.lim-solic with frame {&frame-name}.
  end.
  
  
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

  if aprovador.cod-aprov:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if aprovador.mo-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

    {utp/ut-liter.i Limite_Aprov_Docto_Contrato * r}
    assign de-lim-contdoc:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'cod-aprov':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = Aprovador
           &WHERE = "WHERE Aprovador.cod-aprov eq key-value"
       }
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "Aprovador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "Aprovador"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    assign aprovador.mestre:checked in frame {&frame-name} = no.

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */
  
 if aprovador.cod-aprov:sensitive in frame {&frame-name} then do:
     find usuar-mater where 
         usuar-mater.cod-usuario = input frame {&frame-name} aprovador.cod-aprov 
         no-lock no-error.
     if not avail usuar-mater then do:
         {utp/ut-table.i mgind usuar-mater 1}
         run utp/ut-msgs.p (input "show", input 2, input return-value).
         apply "entry" to aprovador.cod-aprov in frame {&frame-name}.
         return "adm-error".
     end.

     find aprovador where 
         aprovador.cod-aprov = input frame {&frame-name} aprovador.cod-aprov 
         no-lock no-error.
     if avail aprovador then do:
         {utp/ut-table.i mgind aprovador 1}
         run utp/ut-msgs.p (input "show", input 1, input return-value).
         apply "entry" to aprovador.cod-aprov in frame {&frame-name}.
         return "adm-error".
     end.
 end.  

 find moeda where 
     moeda.mo-codigo = input frame {&frame-name} aprovador.mo-codigo 
     no-lock no-error.
 if not avail moeda then do:
     {utp/ut-table.i mguni moeda 1}
     run utp/ut-msgs.p (input "show", input 2, input return-value).
     apply "entry" to aprovador.mo-codigo in frame {&frame-name}.
     return "adm-error".
 end.       

 if adm-new-record = no then do:
    IF  aprovador.aprov-tec:checked in frame {&frame-name} = no then do:
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.aprov-tec    = yes 
            no-lock no-error.
        
        IF  not available doc-pend-aprov then        
            find first doc-pend-aprov 
                 WHERE doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                       doc-pend-aprov.ind-situacao = 3 and
                       doc-pend-aprov.aprov-tec    = yes 
                 no-lock no-error.
         
        IF  avail doc-pend-aprov then do:
            {utp/ut-liter.i Aprova‡Æo_T‚cnica * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.aprov-tec:checked in frame {&frame-name} = yes.
        END.
    END.    

    if  aprovador.perm-solic:checked in frame {&frame-name} = no then do:
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov     = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao  = 1 and
            doc-pend-aprov.ind-tip-doc   = 1
            no-lock no-error.
        IF  not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov     = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao  = 1 and
                doc-pend-aprov.ind-tip-doc   = 5
                no-lock no-error.
        if  not available doc-pend-aprov then            
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov     = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao  = 3 and
                doc-pend-aprov.ind-tip-doc   = 1
                no-lock no-error.
        if  not available doc-pend-aprov then            
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov     = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao  = 3 and
                doc-pend-aprov.ind-tip-doc   = 5
                no-lock no-error.
        if  avail doc-pend-aprov then do:
            {utp/ut-liter.i Solicita‡Æo * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.perm-solic:checked in frame {&frame-name} = yes.
        end.
    end.  

    if  aprovador.perm-requis:checked in frame {&frame-name} = no then do:
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.ind-tip-doc  = 2
            no-lock no-error.
        if not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao = 3 and
                doc-pend-aprov.ind-tip-doc  = 2
                no-lock no-error.
        if avail doc-pend-aprov then do:
            {utp/ut-liter.i Requisi‡Æo * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.perm-requis:checked in frame {&frame-name} = yes.
        end.
    end.  
    
    IF  aprovador.perm-cotac:checked in frame {&frame-name} = no then do:
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.ind-tip-doc  = 3
            no-lock no-error.
        if not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao = 3 and
                doc-pend-aprov.ind-tip-doc  = 3
                no-lock no-error.
        if avail doc-pend-aprov then do:
            {utp/ut-liter.i Cota‡Æo * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.perm-cotac:checked in frame {&frame-name} = yes.
        end. 
    end. 

    if  aprovador.perm-pedido:checked in frame {&frame-name} = no then do:
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.ind-tip-doc  = 4
            no-lock no-error.
        if not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao = 3 and
                doc-pend-aprov.ind-tip-doc  = 4
                no-lock no-error.
        if avail doc-pend-aprov then do:
            {utp/ut-liter.i Pedido * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.perm-pedido:checked in frame {&frame-name} = yes.
        end. 
    end. 

    IF  aprovador.log-1:checked in frame {&frame-name} = no then do: /* permite processo */
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.ind-tip-doc  = 7
            no-lock no-error.
        if not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao = 3 and
                doc-pend-aprov.ind-tip-doc  = 7
                no-lock no-error.
        if avail doc-pend-aprov then do:
            {utp/ut-liter.i Processo * l}
            run utp/ut-msgs.p (input "show", input 15925, input return-value).
            assign aprovador.log-1:checked in frame {&frame-name} = yes.
        end. 
    end. 

    IF  aprovador.log-2:checked in frame {&frame-name} = no then do: /* permite contrato */
        find first doc-pend-aprov where
            doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
            doc-pend-aprov.ind-situacao = 1 and
            doc-pend-aprov.ind-tip-doc  = 8
            no-lock no-error.
        if not available doc-pend-aprov then
            find first doc-pend-aprov where
                doc-pend-aprov.cod-aprov    = input frame {&frame-name} aprovador.cod-aprov and
                doc-pend-aprov.ind-situacao = 3 and
                doc-pend-aprov.ind-tip-doc  = 8
                no-lock no-error.
        if avail doc-pend-aprov then do:
            {utp/ut-liter.i Contrato * l}
            
            run utp/ut-msgs.p (input "show", 
                               input 15925, 
                               input return-value).
            assign aprovador.log-2:checked in frame {&frame-name} = yes.
            assign aprovador.log-1:checked in frame {&frame-name} = yes.
            
            RETURN "adm-error".
            
        end. 
    end. 
 end.

 assign input frame {&frame-name} de-lim-contdoc.
 
 /* Dispatch standard ADM method.                             */
 RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
 if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.
  
 if aprovador.perm-cotac = no then 
     assign aprovador.lim-cotac = 0.
 if aprovador.perm-manut = no then 
     assign aprovador.lim-req-manut = 0.
 if aprovador.perm-pedido = no then
     assign aprovador.lim-pedido = 0.
 if aprovador.perm-requis = no then 
     assign aprovador.lim-requis = 0.
 if aprovador.perm-solic = no then
     assign aprovador.lim-solic = 0.
 if aprovador.log-1 = no then /* permite processo */
     assign aprovador.dec-1 = 0.
 if aprovador.log-2 = no then /* permite contrato */
     assign aprovador.dec-2 = 0.
     
 disp aprovador.lim-cotac 
      aprovador.lim-pedido 
      aprovador.lim-req-manut 
      aprovador.lim-requis 
      aprovador.lim-solic 
      aprovador.dec-1 /* limite processo */
      aprovador.dec-2 /* limite contrato */
      with frame {&frame-name}.
     
/*  if aprovador.perm-solic or aprovador.perm-requis then do:
 *    for each aprov-requis where aprov-requis.nome-abrev = aprovador.cod-aprov:
 *      assign aprov-requis.limite-requis    = aprovador.lim-requis
 *             aprov-requis.limite-req-manut = aprovador.lim-req-manut
 *             aprov-requis.limite-solic     = aprovador.lim-solic
 *             aprov-requis.mo-codigo        = aprovador.mo-codigo. 
 *    end.         
 *   end.          */
            
 if aprovador.perm-cotac or aprovador.perm-pedido then do:
    for each aprov-comp where aprov-comp.cod-aprovador = aprovador.cod-aprov exclusive-lock:
        assign aprov-comp.lim-aprovacao = aprovador.lim-cotac.
    end. 
 end.

 find usuar-mater where 
      usuar-mater.cod-usuario = aprovador.cod-aprov 
      exclusive-lock no-error.
     if available usuar-mater then
        assign usuar-mater.usuar-aprovador = yes.
    
 release usuar-mater.        

 assign substring(aprovador.char-1,34,15) = string(de-lim-contdoc,">>>,>>>,>>9.99").
              
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    for each tt-erro:
        delete tt-erro.
    end.
    /**  Verifica relacionamentos com o Aprovador
    **/
    run cdp/cdapi175.p (input input frame {&frame-name} aprovador.cod-aprov ,
                        input 2 ,
                        output table tt-erro).
    find first tt-erro
        no-lock no-error.
    if available tt-erro then do:
        run cdp/cd0669.w (input table tt-erro).
        return "adm-error".
    end.

    for each tipo-aprov-aprov where
        tipo-aprov-aprov.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete tipo-aprov-aprov.
    end.
    
    for each aprov-altern where
        aprov-altern.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete aprov-altern.
    end. 

    for each aprov-familia where
        aprov-familia.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete aprov-familia.
    end.

    for each aprov-item where
        aprov-item.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete aprov-item.
    end.

    for each hierarquia-aprov where
        hierarquia-aprov.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete hierarquia-aprov.
    end.

    for each hierarquia-faixa where
        hierarquia-faixa.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete hierarquia-faixa.
    end.
    
    for each lim-aprov-fam-mat where
        lim-aprov-fam-mat.cod-aprov = input frame {&frame-name} aprovador.cod-aprov exclusive-lock:
        delete lim-aprov-fam-mat.
    end.    
    
    find usuar-mater where
        usuar-mater.cod-usuario = input frame {&frame-name} aprovador.cod-aprov
        exclusive-lock no-error.
    if available usuar-mater then         
        assign usuar-mater.usuar-aprovador = no.
    release usuar-mater.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  &endif.
  
  assign aprovador.lim-cotac:sensitive in frame {&frame-name}     = no 
         aprovador.lim-pedido:sensitive in frame {&frame-name}    = no 
         aprovador.lim-req-manut:sensitive in frame {&frame-name} = no 
         aprovador.lim-requis:sensitive in frame {&frame-name}    = no 
         aprovador.lim-solic:sensitive in frame {&frame-name}     = no
         aprovador.dec-1:sensitive in frame {&frame-name}         = no
         aprovador.dec-2:sensitive in frame {&frame-name}         = no.

    assign de-lim-contdoc:sensitive   in frame {&frame-name}      = no.
  
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    if available aprovador then do:
        find moeda where 
            moeda.mo-codigo = aprovador.mo-codigo 
            no-lock no-error.
        if available moeda then do:
            assign c_des_moeda = moeda.descricao.
        end.
        else do:
            assign c_des_moeda = " ".
        end.
    end.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  &if defined (bf_mat_aprov_contratos) &then
    if available aprovador then do:
        display decimal(substring(aprovador.char-1,34,15)) @ de-lim-contdoc with frame {&frame-name}.    
    end.
  &endif
  /* Code placed here will execute AFTER standard behavior.    */
  
&if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}:
         assign aprovador.perm-contdoc:hidden = no
                aprovador.perm-event  :hidden = no
                aprovador.perm-medic  :hidden = no
                aprovador.lim-event   :hidden = no
                aprovador.lim-medic   :hidden = no
                de-lim-contdoc        :hidden = no.
      end.
  &else
      do with frame {&frame-name}:
         assign aprovador.perm-contdoc:hidden = yes
                aprovador.perm-event  :hidden = yes
                aprovador.perm-medic  :hidden = yes
                aprovador.lim-event   :hidden = yes
                aprovador.lim-medic   :hidden = yes
                de-lim-contdoc        :hidden = yes.
      end.
&endif


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
  /* Dispatch standard ADM method.                             */
    
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if aprovador.perm-cotac:checked in frame {&frame-name} = yes then
     assign aprovador.lim-cotac:sensitive in frame {&frame-name} = yes. 
  else
     assign aprovador.lim-cotac:sensitive in frame {&frame-name} = no.
        
  if aprovador.perm-manut:checked in frame {&frame-name} = yes then
     assign aprovador.lim-req-manut:sensitive in frame {&frame-name} = yes.
  else            
     assign aprovador.lim-req-manut:sensitive in frame {&frame-name} = no.
    
  if aprovador.perm-pedido:checked in frame {&frame-name} = yes then
     assign aprovador.lim-pedido:sensitive in frame {&frame-name} = yes.
  else
     assign aprovador.lim-pedido:sensitive in frame {&frame-name} = no.
        
  if aprovador.perm-requis:checked in frame {&frame-name} = yes then
     assign aprovador.lim-requis:sensitive in frame {&frame-name} = yes.
  else        
     assign aprovador.lim-requis:sensitive in frame {&frame-name} = no.
    
  if aprovador.perm-solic:checked in frame {&frame-name} = yes then
     assign aprovador.lim-solic:sensitive in frame {&frame-name} = yes.
  else
     assign aprovador.lim-solic:sensitive in frame {&frame-name} = no.
 
  if aprovador.log-1:checked in frame {&frame-name} = yes then
     assign aprovador.dec-1:sensitive in frame {&frame-name} = yes.
  else
     assign aprovador.dec-1:sensitive in frame {&frame-name} = no.

  if aprovador.log-2:checked in frame {&frame-name} = yes then
     assign aprovador.dec-2:sensitive in frame {&frame-name} = yes.
  else
     assign aprovador.dec-2:sensitive in frame {&frame-name} = no.

  if adm-new-record = yes then do:
   disable aprovador.lim-cotac 
           aprovador.lim-pedido 
           aprovador.lim-req-manut 
           aprovador.lim-requis 
           aprovador.lim-solic 
           aprovador.dec-1
           aprovador.dec-2
           with frame {&frame-name}.
   assign aprovador.mestre:checked in frame {&frame-name} = no.
  end. 
  
  &if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}: 
    if aprovador.perm-contdoc:checked in frame {&frame-name} then
         assign de-lim-contdoc:sensitive  in frame {&frame-name} = yes.
    else assign de-lim-contdoc:sensitive  in frame {&frame-name} = no.

    if adm-new-record then
        assign de-lim-contdoc:sensitive in frame {&frame-name} = no.
  &endif
  
  if adm-new-record = yes then 
  &if defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif.
  
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  {utp/ut-liter.i "Limite_Aprov_Processo" * R}
  assign aprovador.dec-1:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i "Limite_Aprov_Contrato" * R}
  assign aprovador.dec-2:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i "Aprova_Processo" * L}
  assign aprovador.log-1:label in frame {&FRAME-NAME} = return-value.

  {utp/ut-liter.i "Aprova_Contrato" * L}
  assign aprovador.log-2:label in frame {&FRAME-NAME} = return-value.


  /***** Helps dos campos *****/

  {utp/ut-liter.i "Limite_de_Aprova‡Æo_da_Solicita‡Æo" *}
  assign aprovador.lim-solic:help in frame {&FRAME-NAME} = trim(return-value).  
  
  {utp/ut-liter.i "Limite_de_Aprova‡Æo_para_o_Processo" *}
  assign aprovador.dec-1:help in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i "Limite_de_Aprova‡Æo_para_o_Contrato" *}
  assign aprovador.dec-2:help in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i "Aprova_Processo" *}
  assign aprovador.log-1:help in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i "Aprova_Contrato" *}
  assign aprovador.log-2:help in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i "Aprova_Manuten‡Æo" *}
  assign aprovador.perm-manut:help in frame {&FRAME-NAME} = trim(return-value).
  
  /****************************/
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

    if avail aprovador then
        assign gr-aprovador = rowid(aprovador).
     find moeda where moeda.mo-codigo = aprovador.mo-codigo no-lock no-error.
      if avail moeda then 
      assign gr-moeda = rowid(moeda).   

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
     
     assign v-row-parent = v-row-parent-externo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":u, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-aprov" "Aprovador" "cod-aprov"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "Aprovador"}

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


