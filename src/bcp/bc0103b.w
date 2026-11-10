&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0103B 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0103B MBC}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
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

/* Parameters Definitions ---                                           */

def input           param i-campo          as inte.
def input           param i-seq            as inte.
def input           param i-pos-ini-br     as inte.
def input           param i-pos-fim-br     as inte.
def input           param i-pos-ult-seq-br as inte.
def input-output    param c-conteudo       as char.
def input-output    param i-tp-campo       as inte.
def input-output    param i-pos-inicial    as inte.
def input-output    param p-tamanho        as inte.       
                    
def var i-nr-inteiro      as integer.
def var i-nr-decimal      as integer.
def var i-tamanho         as integer.

def var i-nr-max-caracter as integer.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 rt-buttom c-texto ~
rs-tp-campo i-nr-caracter qt-decimal c-formato bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-texto rs-tp-campo i-nr-caracter ~
qt-decimal c-formato 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-formato AS CHARACTER FORMAT "X(999)":U 
     LABEL "Format" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-texto AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Campo:" 
      VIEW-AS TEXT 
     SIZE 15.43 BY .67 NO-UNDO.

DEFINE VARIABLE i-nr-caracter AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "N£mero de Caracteres" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE qt-decimal AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Quantidade Decimais" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tp-campo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Texto", 1,
"N£mero", 2,
"Zeros a Esquerda", 3
     SIZE 47 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 3.33.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64 BY 1.67.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 64 BY 1.42
     BGCOLOR 7 .

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-texto AT ROW 1 COL 1 COLON-ALIGNED NO-LABEL
     rs-tp-campo AT ROW 1.75 COL 11 NO-LABEL
     i-nr-caracter AT ROW 3.5 COL 22 COLON-ALIGNED
     qt-decimal AT ROW 4.5 COL 22 COLON-ALIGNED
     c-formato AT ROW 5.5 COL 22 COLON-ALIGNED
     bt-ok AT ROW 6.75 COL 2
     bt-cancela AT ROW 6.75 COL 13
     bt-ajuda AT ROW 6.75 COL 54.14
     RECT-12 AT ROW 3.17 COL 1
     RECT-13 AT ROW 1.33 COL 1
     rt-buttom AT ROW 6.5 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE ""
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
   Custom                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    apply "leave" to i-nr-caracter.
    if  int(rs-tp-campo:screen-value) = 2
    or  int(rs-tp-campo:screen-value) = 3
    and  session:numeric-format = "European" 
        then assign c-formato:screen-value = replace(c-formato:screen-value,",",".").
    
                         
    assign  c-conteudo      = c-formato      :screen-value in frame {&FRAME-NAME}
            i-tp-campo      = int(rs-tp-campo:screen-value in frame {&FRAME-NAME})
            i-pos-inicial   = (if    i-tp-campo = 1
                                then int(qt-decimal:screen-value)
                               else 0)
            p-tamanho       =  int(i-nr-caracter:screen-value in frame {&FRAME-NAME}).
                          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-nr-caracter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-nr-caracter D-Dialog
ON LEAVE OF i-nr-caracter IN FRAME D-Dialog /* N£mero de Caracteres */
DO:
    do with frame {&FRAME-NAME}:

        if  rs-tp-campo:screen-value = "1"
        then do:        
            /*
            if  (   int(qt-decimal   :screen-value) > int(i-nr-caracter:screen-value)
                 or int(i-nr-caracter:screen-value) = 0)
            then do:
                run utp/ut-msgs.p ( input "show",
                                    input 15990,
                                    input trim(i-nr-caracter:screen-value)).
                apply "entry" to i-nr-caracter.
                return no-apply.
            end.
            else do: 
            */
                if  (i-nr-caracter <> int(i-nr-caracter:screen-value))
                then 
                    assign i-nr-caracter = int(i-nr-caracter:screen-value).
             /*
            end.
            */

        end.
        ELSE do:
            if  int(i-nr-caracter:SCREEN-VALUE) > 999
            then do:
                run utp/ut-msgs.p ( input "show",
                                    input 26461,
                                    input trim(string(999))). /* número máximo para inteiros ou decimais */
                apply "entry" to i-nr-caracter.
                return no-apply.
            end.

        end.

        
        ASSIGN i-nr-max-caracter = 9999 - i-pos-ult-seq-br + (i-pos-fim-br - i-pos-ini-br) + 1.
        
        IF int(i-nr-caracter:screen-value) - i-nr-max-caracter > 0 THEN DO: 
            run utp/ut-msgs.p ( input "show",
                                input 26399,
                                input trim(i-nr-caracter:screen-value) + "~~" +
                                      STRING(i-pos-ult-seq-br) + "~~" +
                                      STRING(int(i-nr-caracter:screen-value) - i-nr-max-caracter + 9999) + "~~" +
                                      STRING(9999) + "~~" +
                                      STRING(i-nr-max-caracter)).
            apply "entry" to i-nr-caracter.
            return no-apply.
        END.
           
        run pi-formato.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME qt-decimal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL qt-decimal D-Dialog
ON LEAVE OF qt-decimal IN FRAME D-Dialog /* Quantidade Decimais */
DO:
    if  rs-tp-campo:screen-value in frame {&FRAME-NAME} = "2"
    or  rs-tp-campo:screen-value in frame {&FRAME-NAME} = "3"
    then do:
        if  int(qt-decimal:SCREEN-VALUE) > 999 
        then do:
            run utp/ut-msgs.p ( input "show",
                                input 26461,
                                input trim(string(999))). /* número máximo para inteiros ou decimais */
            apply "entry" to qt-decimal.
            return no-apply.
        end.

        run pi-formato.
    end.
    else do:
        do with frame {&FRAME-NAME}:
            
            /*******
            if  (   int(qt-decimal:screen-value) > int(i-nr-caracter:screen-value)
                 or int(qt-decimal:screen-value) = 0)
            then do:
                run utp/ut-msgs.p (input "show",
                                   input 15990,
                                   input trim(i-nr-caracter:screen-value)).
                apply "entry" to qt-decimal.
                return no-apply.
            end.
            *********/

            run pi-formato.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tp-campo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tp-campo D-Dialog
ON VALUE-CHANGED OF rs-tp-campo IN FRAME D-Dialog
DO:
    do with frame {&FRAME-NAME} :
        if  (rs-tp-campo:screen-value = "1")  then do:
            {utp/ut-liter.i "N£mero de Caracteres" * R}
            assign  i-nr-caracter:label = trim(return-value).

            {utp/ut-liter.i "Posi‡Æo Inicial" * R}
            assign  qt-decimal:label    = trim(return-value).
        
            if   int(qt-decimal   :screen-value) > int(i-nr-caracter:screen-value)
            then assign qt-decimal:screen-value = "1".
        end.
        else do:
                   
            {utp/ut-liter.i "Quantidade Inteiros" * R}
            assign  i-nr-caracter:label = trim(return-value).

            {utp/ut-liter.i "Quantidade Decimais" * R}
            assign  qt-decimal:label     = trim(return-value).
        end.
        assign  c-formato:sensitive = (rs-tp-campo:screen-value = "1").
        run pi-formato.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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
  HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY c-texto rs-tp-campo i-nr-caracter qt-decimal c-formato 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 RECT-13 rt-buttom c-texto rs-tp-campo i-nr-caracter qt-decimal 
         c-formato bt-ok bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
  VIEW FRAME D-Dialog.
  {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "BC0103B" "2.00.00.007"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i "Tipo de Campo:" * R}
  assign c-texto:screen-value in frame {&FRAME-NAME} = return-value.
  
  {utp/ut-liter.i Format * L}
  assign c-formato:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-rdset.i rs-tp-campo} /* Include para tradu‡Æo dos radio-buttons do radio-set */

  run pi-edita-conteudo.    /* inicializa campos */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-formato D-Dialog 
PROCEDURE pi-calcula-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input         param c-formato     as char.
def output        param i-nr-inteiro  as inte.
def input-output  param i-nr-decimal  as inte.
def input         param i-tp-campo    as inte.
def var                 i-cont        as inte.
def var                 l-int         as logical.

assign  l-int = no.

if  i-tp-campo = 1 then do:

    if length(c-conteudo) = 6 /* X(999) */
    then assign c-conteudo = "X(" + STRING(INT(substring(c-formato,3,3)), "9999") + ")"
                c-formato  = c-conteudo.

    if  p-tamanho = 0 then do:

        if   substring(c-formato,1,2) = "X("
        then do: 
            IF i-nr-decimal = 1 
            THEN 
                assign i-nr-inteiro = int(substring(c-formato,3,4)) /* + i-nr-decimal - 1 */.
            ELSE
                assign   i-nr-inteiro = int(substring(c-formato,3,4)) + (i-nr-decimal - 1) /* + i-nr-decimal - 1 */.
                
        END.

        else 
            assign i-nr-inteiro = length(c-formato) /* + i-nr-decimal - 1 */.
            
    end.
    else do:
    
        assign i-nr-inteiro = p-tamanho.
        
    end.
        
end.
else do:
    do i-cont = 1 to length(c-formato):
      if  substring(c-formato, i-cont, 1) ne "." and
          substring(c-formato, i-cont, 1) ne ","
          then do:
          if      l-int then i-nr-decimal = i-nr-decimal + 1.
          if  not l-int then i-nr-inteiro = i-nr-inteiro + 1.
      end.
      else l-int = yes.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-edita-conteudo D-Dialog 
PROCEDURE pi-edita-conteudo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&FRAME-NAME}:
    assign  i-tp-campo = (if   i-tp-campo = 0 
                          then 1 
                          else i-tp-campo).
        
    if  i-campo = 19
    then do:
        {utp/ut-liter.i "N£mero de Espa‡os" * R}
        assign  i-nr-caracter:label = trim(return-value).
        {utp/ut-liter.i "Quantidade Decimais" * R}
        assign  qt-decimal:label = trim(return-value)
                qt-decimal      :sensitive = no
                rs-tp-campo     :sensitive = no
                c-formato       :sensitive = no.
    end.
    else do:
        if  i-tp-campo = 1
        then do:
            {utp/ut-liter.i "N£mero de Caracteres" * R}
            assign  i-nr-caracter:label = trim(return-value).
            {utp/ut-liter.i "Posi‡Æo Inicial" * R}
            assign  qt-decimal:label    = trim(return-value).
        end.
        else do:
            {utp/ut-liter.i "Quantidade Inteiros" * R}
            assign  i-nr-caracter:label = trim(return-value).
            {utp/ut-liter.i "Quantidade Decimais" * R}
            assign  qt-decimal:label     = trim(return-value).
        end.
    end.
    
    if   i-tp-campo = 1
    then assign i-nr-decimal = (if   i-pos-inicial <> 0
                                then i-pos-inicial
                                else 1).
   
    run pi-calcula-formato (input         c-conteudo,
                            output        i-nr-inteiro,
                            input-output  i-nr-decimal,
                            input         i-tp-campo).
   
    assign  i-nr-caracter       = i-nr-inteiro
            qt-decimal          = i-nr-decimal
            rs-tp-campo         = i-tp-campo
            c-formato           = c-conteudo
            c-formato:sensitive = (rs-tp-campo = 1 and i-campo <> 19).


    display i-nr-caracter
            qt-decimal
            rs-tp-campo
            c-formato.
                
    apply "entry" to i-nr-caracter.
    run pi-formato.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formato D-Dialog 
PROCEDURE pi-formato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&FRAME-NAME}:

    assign c-formato = (if  rs-tp-campo:screen-value = "1"
                        then (if  substring(c-formato:screen-value,1,2) = "X("
                               then
                                   string("X("
                                   + string((int(i-nr-caracter:screen-value) - int(qt-decimal:screen-value)) + 1, "9999")
                                   + ")")
                               else
                                    c-formato:screen-value)
                        else
                            if  rs-tp-campo:screen-value = "2" then
                                fill(">", int(i-nr-caracter:screen-value) - 1)
                                           + "9"
                                           + (if   int(qt-decimal:screen-value) <> 0
                                              then "."  
                                                   + fill("9", int(qt-decimal:screen-value))
                                              else "")
                            else
                                fill("9", int(i-nr-caracter:screen-value))
                                        + ( if   int(qt-decimal:screen-value) <> 0
                                            then "."  
                                                + fill("9", int(qt-decimal:screen-value))
                                            else "")).

    if  int(rs-tp-campo:screen-value) = 2
    or  int(rs-tp-campo:screen-value) = 3
    and  session:numeric-format = "European" 
        then do:
            assign c-formato = replace(c-formato,".",",").
        end.
    display c-formato.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


