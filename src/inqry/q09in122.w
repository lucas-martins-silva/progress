&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS q-tables 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Q09IN122 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Q09IN122 MUT}
&ENDIF



/*------------------------------------------------------------------------

  File:  

  Description: from QUERY.W - Template For Query objects in the ADM

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

/* ***************** Support for Change Query to Find ***************** */
&Scoped-define CHANGE-QUERY-TO-FIND TRUE
&Scoped-define WHERE-FIRST-TABLE-IN-QUERY-Query-Main 
&Scoped-define JOIN-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-SECOND-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define JOIN-THIRD-TABLE-IN-QUERY-Query-Main TRUE
&Scoped-define WHERE-THIRD-TABLE-IN-QUERY-Query-Main TRUE

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/queryd.w

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

def temp-table tt-familia like familia.
def buffer b-familia      for  familia.

&IF DEFINED (bf_mat_tipo_ressup) &THEN
    def temp-table tt-familia-mat like familia-mat.
    def buffer b-familia-mat      for  familia-mat.
&ENDIF.

def var c-reg-alter as char no-undo.
def var l-passou as log no-undo.


def var c-programa  as char no-undo.
def var l-confirma  as logical init no no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartQuery

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,Navigation-Target

&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES familia

/* Definitions for QUERY Query-Main                                     */
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH familia NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-Query-Main familia
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main familia


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" q-tables _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
class-fiscal||y|mgind.familia.class-fiscal
cod-comprado||y|mgind.familia.cod-comprado
fm-codigo||y|mgind.familia.fm-codigo
nr-linha||y|mgind.familia.nr-linha
cd-planejado||y|mgind.familia.cd-planejado
un||y|mgind.familia.un
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "class-fiscal,cod-comprado,fm-codigo,nr-linha,cd-planejado,un"':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" q-tables _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&QUERY-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
************************
* Initialize Filter Attributes */
RUN set-attribute-list IN THIS-PROCEDURE ('
  Filter-Value=':U).
/************************
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      familia
    FIELDS() SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartQuery
   Allow: Basic,Query
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW q-tables ASSIGN
         HEIGHT             = 1.33
         WIDTH              = 21.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW q-tables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for QUERY Query-Main
     _TblList          = "mgind.familia"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = "USED"
     _Design-Parent    is WINDOW q-tables @ ( 1.13 , 8.72 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB q-tables 
/* ************************* Included-Libraries *********************** */

{src/adm/method/query.i}
{include/c-query.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK q-tables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases q-tables adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEF VAR Filter-Value AS CHAR NO-UNDO.

  /* Copy 'Filter-Attributes' into local variables. */
  RUN get-attribute ('Filter-Value':U).
  Filter-Value = RETURN-VALUE.

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&QUERY-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available q-tables _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI q-tables _DEFAULT-DISABLE
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
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key q-tables adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "class-fiscal" "familia" "class-fiscal"}
  {src/adm/template/sndkycas.i "cod-comprado" "familia" "cod-comprado"}
  {src/adm/template/sndkycas.i "fm-codigo" "familia" "fm-codigo"}
  {src/adm/template/sndkycas.i "nr-linha" "familia" "nr-linha"}
  {src/adm/template/sndkycas.i "cd-planejado" "familia" "cd-planejado"}
  {src/adm/template/sndkycas.i "un" "familia" "un"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records q-tables _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "familia"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed q-tables 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

if  p-state = "Update":U then do:  
      RUN get-attribute in this-procedure (input "DIALOG-EXPORTA":U).
      if  return-value <> "" and return-value <> ? then do:
          for each tt-familia:
              delete tt-familia.
          end.
          find b-familia where rowid(b-familia) = rowid(familia) no-lock no-error.
          buffer-copy b-familia to tt-familia.


/*           MESSAGE "Ap½s buffer-coppy 1 " SKIP                              */
/*               "tt-familia.char-1 " SUBSTRING(tt-familia.char-1,1,135) SKIP */
/*               "   familia.char-1 " SUBSTRING(familia.char-1,1,135)         */
/*               VIEW-AS ALERT-BOX INFO BUTTONS OK.                           */

          assign l-passou = no.
         &if defined (bf_mat_tipo_ressup) &then 
          find b-familia-mat where 
               b-familia-mat.fm-codigo = b-familia.fm-codigo no-lock no-error.
          buffer-copy b-familia-mat to tt-familia-mat.     
         &endif
      end.
end.



if  p-state = "Update-complete":U then do: 
    RUN get-attribute in this-procedure (input "DIALOG-EXPORTA":U).      
    if  return-value <> "" and return-value <> ? then do:
        assign c-programa = return-value.
        if not l-passou THEN DO:
           buffer-compare b-familia to tt-familia save result in c-reg-alter.
/*            MESSAGE "*** Ap½s buffer-compare *** " SKIP      */
/*                "tt-familia.char-1: " tt-familia.char-1 SKIP */
/*                "b-familia.char-1 : " b-familia.char-1 SKIP  */
/*                "familia.char-1   : " familia.char-1         */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.           */

           IF SUBSTRING(b-familia.char-1,10,1)  <> "" AND 
              SUBSTRING(tt-familia.char-1,10,1)  = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,10,1)  = SUBSTRING(b-familia.char-1,10,1).       /* reab-estoq */          

           IF SUBSTRING(b-familia.char-1,20,12) <> "" AND 
              SUBSTRING(tt-familia.char-1,20,12) = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,20,12) = SUBSTRING(b-familia.char-1,20,12).       /* qtd-min-ressup */      

           IF SUBSTRING(b-familia.char-1,15,4)  <> "" AND 
              SUBSTRING(tt-familia.char-1,15,4)  = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,15,4)  = SUBSTRING(b-familia.char-1,15,4).       /* dias-dlt-ressup */     

           IF SUBSTRING(b-familia.char-1,35,12) <> "" AND 
              SUBSTRING(tt-familia.char-1,35,12) = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,35,12) = SUBSTRING(b-familia.char-1,35,12).       /* qtd-dlt-ressup */      

           IF SUBSTRING(b-familia.char-1,129,3) <> "" AND 
              SUBSTRING(tt-familia.char-1,129,3) = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,129,3) = SUBSTRING(b-familia.char-1,129,3).       /* horizonte libera»’o */  

           IF SUBSTRING(b-familia.char-1,132,1) <> "" AND 
              SUBSTRING(tt-familia.char-1,132,1) = "" THEN
              ASSIGN SUBSTRING(tt-familia.char-1,132,1) = SUBSTRING(b-familia.char-1,132,1).       /* represa demanda */     

/*            MESSAGE "*** Ap½s ASSIGN *** " SKIP              */
/*                "tt-familia.char-1: " tt-familia.char-1 SKIP */
/*                "b-familia.char-1 : " b-familia.char-1 SKIP  */
/*                "familia.char-1   : " familia.char-1         */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.           */

        END.
       &if defined (bf_mat_tipo_ressup) &then
        find b-familia-mat where
             b-familia-mat.fm-codigo = b-familia.fm-codigo no-lock no-error.
        if c-reg-alter = "" then DO:
           buffer-compare b-familia-mat to tt-familia-mat save result in c-reg-alter.
        END.

       &endif
        /*if  c-reg-alter <> "" then do:*/
            find first item where
                 item.fm-codigo = familia.fm-codigo no-lock no-error.

           &IF DEFINED (bf_man_203) &THEN
            find first fam-uni-estab where
                       fam-uni-estab.fm-codigo = familia.fm-codigo no-lock no-error.
           &ENDIF
            if avail item &IF DEFINED (bf_man_203) &THEN  or
               avail fam-uni-estab &ENDIF  then do:
              &IF DEFINED (bf_man_203) &THEN
              &ELSE
               assign l-passou = yes.
               run utp/ut-msgs.p (input "show":U,
                                  input 8335,
                                  input "").
               if return-value = "yes" then do:
              &ENDIF        
                  /** Desabilita a janela atual **/
                  assign current-window:sensitive = no.
                  /*este programa tem apenas dois par³metros de entrada*/ 
                  if c-programa <> 'cpp/cp0104c.w' then do:
                 &IF DEFINED (bf_mat_tipo_ressup) &THEN 
                     if c-programa = 'cdp/cd0218d.w' then                         
                         run value (c-programa) (input rowid (familia),
                                                 input table tt-familia,
                                                 INPUT NO).
                     ELSE
                         run value (c-programa) (input rowid (familia),
                                                 input table tt-familia).

                 &ENDIF
                  end.    
                  else do:
                     run value (c-programa) (input rowid (familia),
                                             input table tt-familia).                           
                  end.
                  assign current-window:sensitive = yes
                         c-reg-alter = "".

                 &IF DEFINED (bf_man_203) &THEN                      
                 &ELSE
               end.
               else  
                   assign c-reg-alter = ""
                          current-window:sensitive = yes.
                 &ENDIF
            end.
        /*end.*/
    end.
end.
CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/qstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


