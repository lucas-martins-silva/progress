&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V16IN287 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v16in287 MUT}
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
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var  i-mo-fasb   as integer  no-undo.
def var  i-mo-cmi    as integer  no-undo.
def var  l-corrige   as logical  no-undo.
def var  de-saldo    as decimal  no-undo.
def var l-rej as logical no-undo.

def new shared var da-dt-cotacao  as date  no-undo.
def new shared var da-iniper-x    as date  no-undo.

def new shared var i-moeda        like cotacao.mo-codigo  no-undo.
def new shared var c-it-codigo    like item.it-codigo.

def var i-empresa like param-global.empresa-prin no-undo.

{cep/ce1234.i}  /* Valida‡Æo Decimais */
{cdp/cdcfgdis.i}
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold de-saldo-mat1 de-valor-mat1 ~
de-saldo-mat2 de-valor-mat2 de-saldo-mat3 de-valor-mat3 
&Scoped-Define DISPLAYED-OBJECTS de-saldo-mat1 de-valor-mat1 de-saldo-mat2 ~
de-valor-mat2 de-saldo-mat3 de-valor-mat3 c-saldo1 c-val1 

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
DEFINE VARIABLE c-saldo1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-val1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE de-saldo-mat1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-mat2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo-mat3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-mat1 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-mat2 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-mat3 AS DECIMAL FORMAT ">>>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 7.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-saldo-mat1 AT ROW 3.5 COL 25.57 COLON-ALIGNED
     de-valor-mat1 AT ROW 3.5 COL 47.57 COLON-ALIGNED HELP
          "Saldo Inicial Mat Mensal" NO-LABEL
     de-saldo-mat2 AT ROW 4.5 COL 25.57 COLON-ALIGNED
     de-valor-mat2 AT ROW 4.5 COL 47.57 COLON-ALIGNED NO-LABEL
     de-saldo-mat3 AT ROW 5.5 COL 25.57 COLON-ALIGNED
     de-valor-mat3 AT ROW 5.5 COL 47.57 COLON-ALIGNED NO-LABEL
     c-saldo1 AT ROW 2.5 COL 29.43 COLON-ALIGNED NO-LABEL
     c-val1 AT ROW 2.5 COL 50.43 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         WIDTH              = 85.14.
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

/* SETTINGS FOR FILL-IN c-saldo1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-val1 IN FRAME f-main
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

&Scoped-define SELF-NAME de-saldo-mat2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-saldo-mat2 V-table-Win
ON LEAVE OF de-saldo-mat2 IN FRAME f-main
DO:
   /* ATUALIZA O PRECO MEDIO DO ITEM NO ESTABEL EM MOEDA ALTERNATIVA */          


   if (i-moeda = 1 or i-moeda = 3) and param-estoq.tem-moeda1 then do:                               
      if input frame {&frame-name} de-valor-mat1 <> 0 and de-saldo <> 0 then do:       

         display (input frame {&frame-name} de-saldo-mat2 / de-saldo) @ de-valor-mat2 with frame {&frame-name}.         
      end.
      else do:
         display 0 @ de-valor-mat2 with frame {&frame-name}.
      end.
   end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-saldo-mat3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-saldo-mat3 V-table-Win
ON LEAVE OF de-saldo-mat3 IN FRAME f-main
DO:
   /* ATUALIZA O PRECO MEDIO DO ITEM NO ESTABEL EM MOEDA ALTERNATIVA */


   if (i-moeda = 2 or i-moeda = 3) and param-estoq.tem-moeda2 then do:
       if input frame {&frame-name} de-valor-mat1 <> 0 and de-saldo <> 0 then do:
          display input frame {&frame-name} de-saldo-mat3 / de-saldo @ de-valor-mat3 with frame {&frame-name}.
       end.
       else do:
          display 0 @ de-valor-mat3 with frame {&frame-name}.
       end.
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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  disable de-saldo-mat1
          de-saldo-mat2
          de-saldo-mat3
          de-valor-mat1
          de-valor-mat2
          de-valor-mat3 with frame {&frame-name}.

  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                        input 16,
                        input "").
     return 'adm-error'.
  end.

  find first param-estoq exclusive-lock no-error. 
  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show",
                        input 1059,
                        input "").
     return 'adm-error'.
  end.

/*  if param-estoq.ult-fech-dia < param-estoq.mensal-ate then do:
     run utp/ut-msgs.p (input "show",
                        input 2052,
                        input "").
     apply 'close' to this-procedure.
     return 'adm-error'.
  end. */

   if param-estoq.tem-moeda1 and param-estoq.tem-moeda2 then do:
     assign i-moeda = 3.
   end.
   else do: 
      if param-estoq.tem-moeda1 then do:
         assign i-moeda = 1.
      end. 
      if param-estoq.tem-moeda2 then do:
         assign i-moeda = 2.
      end.  
   end.

  find param-fasb where param-fasb.ep-codigo = i-empresa no-lock no-error.
  if avail param-fasb then do:
     assign i-mo-fasb = param-fasb.moeda-fasb
            i-mo-cmi  = param-fasb.moeda-cmi.   
  end.

  {utp/ut-liter.i  Saldo_Inicial * C}
  assign c-saldo1 = return-value.
  display c-saldo1 with frame {&frame-name}.

  {utp/ut-liter.i  Valor_Unit rio * C}
  assign c-val1 = return-value.  
  display c-val1 with frame {&frame-name}.

  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-saldo-mat1:label in frame {&frame-name} = moeda.descricao.
  end.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-saldo-mat2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
     assign de-saldo-mat2:label in frame {&frame-name} = "".
     disable de-saldo-mat2
             de-valor-mat2 with frame {&frame-name}.
  end.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-saldo-mat3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
     assign de-saldo-mat3:label in frame {&frame-name} = "".
     disable de-saldo-mat3 
             de-valor-mat3 with frame {&frame-name}.
  end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava V-table-Win 
PROCEDURE pi-grava :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

assign i-empresa = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = estab-mat.cod-estabel no-lock no-error.

    run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa).
&endif

   find first estab-mat where item-estab.cod-estabel = estab-mat.cod-estabel no-lock no-error.

   if avail estab-mat and estab-mat.custo-contab = 1 /* mensal */ then do:  
      assign item-estab.sald-ini-mat-m[2] = input frame {&frame-name} de-saldo-mat2
             item-estab.sald-ini-mat-m[3] = input frame {&frame-name} de-saldo-mat3
             item-estab.val-unit-mat-m[2] = input frame {&frame-name} de-valor-mat2
             item-estab.val-unit-mat-m[3] = input frame {&frame-name} de-valor-mat3.
   end.

   if avail estab-mat and estab-mat.usa-on-line = yes then do:  
      assign item-estab.sald-ini-mat-o[2] = input frame {&frame-name} de-saldo-mat2
             item-estab.sald-ini-mat-o[3] = input frame {&frame-name} de-saldo-mat3
             item-estab.val-unit-mat-o[2] = input frame {&frame-name} de-valor-mat2
             item-estab.val-unit-mat-o[3] = input frame {&frame-name} de-valor-mat3.
   end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa V-table-Win 
PROCEDURE pi-inicializa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param rw-item       as rowid   no-undo.
  def input param rw-item-estab as rowid   no-undo. 
  def input param de-saldos     as decimal no-undo.

  assign de-saldo  = de-saldos.

  /* VERIFICA SE O ITEM DE ESTOQUE POSSUI SALDO DE ESTOQUE IMPLANTADO */
  find item-estab where rowid(item-estab) =  rw-item-estab no-lock no-error.
  if not available item-estab then do:
     disable de-saldo-mat2
             de-saldo-mat3 with frame {&frame-name}.
  end.
  else do:
     if param-estoq.tem-moeda1 then
        enable de-saldo-mat2 with frame {&frame-name}.
     if param-estoq.tem-moeda2 then   
        enable de-saldo-mat3 with frame {&frame-name}.
  end.           

  find first estab-mat where item-estab.cod-estabel = estab-mat.cod-estabel no-lock no-error.

  if estab-mat.custo-contab = 1 /* mensal */ then do:
     assign de-saldo-mat1 = item-estab.sald-ini-mat-m[1]
            de-saldo-mat2 = item-estab.sald-ini-mat-m[2]
            de-saldo-mat3 = item-estab.sald-ini-mat-m[3]
            de-valor-mat1 = item-estab.val-unit-mat-m[1]
            de-valor-mat2 = item-estab.val-unit-mat-m[2]
            de-valor-mat3 = item-estab.val-unit-mat-m[3].

     display de-saldo-mat1 de-saldo-mat2 de-saldo-mat3 
             de-valor-mat1 de-valor-mat2 de-valor-mat3 with frame {&frame-name}.
  end.

  if estab-mat.usa-on-line = yes then do:
     assign de-saldo-mat1 = item-estab.sald-ini-mat-o[1]
            de-saldo-mat2 = item-estab.sald-ini-mat-o[2]
            de-saldo-mat3 = item-estab.sald-ini-mat-o[3]
            de-valor-mat1 = item-estab.val-unit-mat-o[1]
            de-valor-mat2 = item-estab.val-unit-mat-o[2]
            de-valor-mat3 = item-estab.val-unit-mat-o[3].

     display de-saldo-mat1 de-saldo-mat2 de-saldo-mat3 
             de-valor-mat1 de-valor-mat2 de-valor-mat3 with frame {&frame-name}.
  end.

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
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

def output parameter l-rej as logical initial yes.

 /*Parametriza‡Æo Casas decimais para Chile*/

        assign l-rejeita-dec = no

        de-saldo-mat1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-saldo-mat1, 0 ))
        de-saldo-mat2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-saldo-mat2, param-estoq.moeda1 ))
        de-saldo-mat3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-saldo-mat3, param-estoq.moeda2 ))      


        de-valor-mat1:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-valor-mat1, 0 ))
        de-valor-mat2:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-valor-mat2, param-estoq.moeda1 ))
        de-valor-mat3:screen-value in frame {&frame-name}  = string( fn_vld_ajust_dec( input frame {&frame-name} 
                                                                             de-valor-mat3, param-estoq.moeda2 )).




 if  l-rejeita-dec then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show":U, 
                        input 18100, 
                        input " ").                      
    assign l-rej = no.                      
    return "adm-error":U.

 end.




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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


