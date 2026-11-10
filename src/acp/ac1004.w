&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME w-concom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-concom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1004 2.00.00.019 } /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC1004 MAC}
&ENDIF




/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


def var rw-ped-venda     as rowid no-undo.

def new global shared var gr-emitente      as rowid            no-undo.
def new global shared var r-ped-venda-g    as rowid            no-undo.
def new global shared var gr-ped-venda     as rowid            no-undo.
def new global shared var h-handle-browse  as handle           no-undo.
def new global shared var c-situacao       as char             no-undo.

/* Integra‡Æo EAI */
define new global shared variable v_log_eai_habilit as log  no-undo.
define new global shared variable v-prog-version    as char no-undo.
define new global shared variable v-prog-obj        as char no-undo.

/* temp table rowErrors */
{method/dbotterr.i}

{cdp/cdcfgdis.i} /* Defini‡Æo de pr‚processadores */

def var l-cancela         as logical                           no-undo.
def var l-n-avaliado      as logical        init yes           no-undo.
def var l-aprovado        as logical        init yes            no-undo.
def var l-reprovado       as logical        init yes           no-undo.
def var l-suspenso        as logical        init yes           no-undo.
def var l-ok              as logical                           no-undo.

def var c-quem-aprovou    like ped-venda.quem-aprovou          no-undo.
def var c-pe-motivo       as char                              no-undo.
def var c-pe-motivo-yes   as char                              no-undo.
def var c-pe-motivo-no    as char                              no-undo.
def var c-sit             as char                              no-undo.

def var dt-apr-cred       as date initial today                no-undo.

def var r-rowid           as rowid                             no-undo.

def var c-traducao        as char                              no-undo.

DEF VAR h-bodi261         AS HANDLE                            NO-UNDO.
DEF VAR h-bodi159cal      AS HANDLE                            NO-UNDO.
DEF VAR h-bodi605         AS HANDLE                            NO-UNDO.
DEF VAR h-pdapi513e       AS HANDLE                            NO-UNDO.
def var hShowMsg          as handle                            no-undo.

DEF TEMP-TABLE tt-ped-item-aux NO-UNDO 
    FIELD nr-sequencia AS INT 
    FIELD it-codigo    AS CHAR
    FIELD cod-refer    AS CHAR.

def buffer b-ped-venda for ped-venda.
def buffer b-ped-item for ped-item.

FIND FIRST para-ped NO-LOCK NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-concom
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-aprovar bt-reprovar bt-filtrar rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-concom AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V  para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b13di154 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_folder AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q11di159 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v15di159 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-aprovar 
     IMAGE-UP FILE "image~\ii-cq":U
     LABEL "Aprovar" 
     SIZE 4 BY 1.25 TOOLTIP "Aprovar Pedido".

DEFINE BUTTON bt-filtrar 
     IMAGE-UP FILE "image~\gr-fil":U
     LABEL "Filtrar" 
     SIZE 4 BY 1.25 TOOLTIP "Filtrar".

DEFINE BUTTON bt-reprovar 
     IMAGE-UP FILE "image~\ii-chck2":U
     LABEL "Reprovar" 
     SIZE 4 BY 1.25 TOOLTIP "Reprovar Pedido".

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.43 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-aprovar AT ROW 1.33 COL 54
     bt-reprovar AT ROW 1.33 COL 58
     bt-filtrar AT ROW 1.33 COL 66
     rt-button AT ROW 1.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-concom
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-concom ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta <Insira complemento>"
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-cadastro:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-concom 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-concom.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-concom
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-concom)
THEN w-concom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-concom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-concom w-concom
ON END-ERROR OF w-concom /* Consulta <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-concom w-concom
ON WINDOW-CLOSE OF w-concom /* Consulta <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-aprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-aprovar w-concom
ON CHOOSE OF bt-aprovar IN FRAME f-cad /* Aprovar */
DO:

       RUN pi-posicao-query IN h_q11di159
         (OUTPUT r-rowid).     

       find first ped-venda where
            rowid(ped-venda) = r-rowid no-lock no-error.

       for each tt-ped-item-aux.
           delete tt-ped-item-aux.
       end.

       /* ver se usuario tem permissÆo para aprov/reprov */
       find first user-coml no-lock where
                  user-coml.usuario = c-seg-usuario no-error.
       if user-coml.log-libera-cotas = no then do:           
          {utp/ut-liter.i Aprova‡Æo MAC c}
          run utp/ut-msgs.p(input "show",
                            input 6660,
                            input c-seg-usuario + "~~" + return-value).
          return no-apply.
       end.

       /* pedido reprovado por cr‚dito */
       if ped-venda.cod-sit-aval <> 2 and
          ped-venda.cod-sit-aval <> 3 then do:
          run utp/ut-msgs.p (input "show",
                             input 6270,
                             input "").
          return no-apply.
       end.       

       /* Pedido nÆo aprovado por WF de desconto */
       IF  para-ped.log-usa-aprovac-workflow 
       AND ped-venda.log-aprov-workflow = NO THEN DO:
                      
           run utp/ut-msgs.p (input "show",
                              input 52327, 
                              input ped-venda.nr-pedcli + "~~" + ped-venda.nome-abrev).
           RETURN NO-APPLY.                        
      
       END. 
       
       if ped-venda.cod-sit-ped > 2 then do:
          {utp/ut-liter.i Pedido MPD e}
          assign c-traducao = return-value.
          {utp/ut-liter.i Aprovado MAC e}
          &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
              DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
              ASSIGN cAuxTraducao001 = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.
              run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                  INPUT "",
                                  INPUT "").
              ASSIGN  c-sit = RETURN-VALUE.
          &else
              ASSIGN c-sit = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.
          &endif
          run utp/ut-msgs.p (input "show",
                             input 7972,
                             input c-traducao + " " + ped-venda.nr-pedcli + "~~" + 
                                   return-value + "~~" + c-sit).
          return no-apply.
       end.

       if ped-venda.cod-sit-com = 2 then do:  
          run utp/ut-msgs.p (input "show",
                             input 3410,    /*j  aprovado*/
                             input ped-venda.nr-pedcli).
          return no-apply.
       end.      


       assign c-quem-aprovou  = c-seg-usuario
              c-pe-motivo     = ""
              c-pe-motivo-no  = "".

       run acp/ac1004c.w (input-output c-quem-aprovou,
                          input-output dt-apr-cred,
                          input-output c-pe-motivo,
                          input-output c-pe-motivo-yes,
                          output l-ok ).

       if l-ok then DO TRANS:

          IF  NOT VALID-HANDLE (h-bodi261) OR 
              h-bodi261:TYPE      <> "PROCEDURE":U OR 
              h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
              run dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

          RUN atualizarCotasPedido IN h-bodi261 (INPUT ROWID(ped-venda),
                                                 INPUT 7, /*aprovar forcado*/
                                                 INPUT TABLE tt-ped-item-aux).
          IF VALID-HANDLE(h-bodi261) THEN DO:
             DELETE PROCEDURE h-bodi261.
             ASSIGN h-bodi261 = ?.
          END.                  
          for each b-ped-venda where
                   b-ped-venda.nr-pedcli = ped-venda.nr-pedcli and
                   b-ped-venda.nome-abrev = ped-venda.nome-abrev exclusive-lock:
              for each b-ped-item of b-ped-venda exclusive-lock :              
                  assign b-ped-item.motivo-alt-sit-quota = c-pe-motivo-yes
                         b-ped-item.dat-alter-sit = dt-apr-cred
                         b-ped-item.cod-usu-alt-sit = c-quem-aprovou
                         b-ped-item.cod-sit-com   = 2 .                                
              end.      
              assign b-ped-venda.motivo-alt-sit-quota = c-pe-motivo-yes
                     b-ped-venda.dat-alter-sit = dt-apr-cred
                     b-ped-venda.cod-usu-alt-sit = c-quem-aprovou
                     b-ped-venda.cod-sit-com   = 2 .                    
                    
              run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,
                                            input b-ped-venda.nome-abrev).
          
          end.                   

          &IF DEFINED(bf_dis_adm_cotas) &THEN  /* 2.04 */         
              IF NOT VALID-HANDLE(h-bodi159cal) OR 
                 h-bodi159cal:TYPE      <> "PROCEDURE":U OR 
                 h-bodi159cal:FILE-NAME <> "dibo/bodi159cal.p":U THEN 
                 RUN dibo/bodi159cal.p PERSISTENT SET h-bodi159cal.

              RUN setInvoicingAvaiable in h-bodi159cal(INPUT ROWID(ped-venda)).
              IF VALID-HANDLE(h-bodi159cal) THEN DO:
                 DELETE PROCEDURE h-bodi159cal.
                 ASSIGN h-bodi159cal = ?.
              END.    
          &ELSE  
              RUN cdp/cd4100.p ( INPUT ROWID(ped-venda) ).  
          &ENDIF

          assign v-prog-version = c-prg-vrs
                 v-prog-obj     = c-prg-obj.

          /* Integra‡Æo EAI */
          &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
             IF v_log_eai_habilit THEN DO:
                RUN adapters/xml/vd2/axsvd003.p (INPUT  "upd":U,
                                                 INPUT  v-prog-obj,
                                                 INPUT  v-prog-version,
                                                 INPUT  ROWID(ped-venda),
                                                 OUTPUT TABLE RowErrors).
                IF CAN-FIND(FIRST RowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2}
                    UNDO,RETURN NO-APPLY.
                end.                    
             END.
          &endif

          RUN dispatch IN h_q11di159 ('open-query-cases':U).         
          RUN pi-reposiciona-query IN h_b13di154 (INPUT rowid(ped-venda)).
          RUN dispatch IN h_v15di159 ('display-fields':U).          
       end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-filtrar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-filtrar w-concom
ON CHOOSE OF bt-filtrar IN FRAME f-cad /* Filtrar */
DO:

    run acp/ac1004d.w (input-output l-n-avaliado,
                       input-output l-aprovado  ,
                       input-output l-reprovado ,
                       input-output l-suspenso,
                       output       l-cancela).

    if  l-cancela = no then do:
        if l-n-avaliado then
            assign c-situacao = "S":u.
        else
            assign c-situacao = "N":u.

        if l-aprovado then
           assign c-situacao = c-situacao + "S":u.
        else
           assign c-situacao = c-situacao + "N":u.

        if l-reprovado then
           assign c-situacao = c-situacao + "S":u.
        else
           assign c-situacao = c-situacao + "N":u.

        if l-suspenso then
           assign c-situacao = c-situacao + "S":u.
        else
           assign c-situacao = c-situacao + "N":u.

        run dispatch in h_q11di159 ('open-query-cases':U).
        run dispatch in h_q11di159 (input 'get-first':U).                
    end.           

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-reprovar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-reprovar w-concom
ON CHOOSE OF bt-reprovar IN FRAME f-cad /* Reprovar */
DO:

   RUN pi-posicao-query IN h_q11di159
       (OUTPUT r-rowid).     

   find first ped-venda where
        rowid(ped-venda) = r-rowid no-lock no-error.

   for each tt-ped-item-aux.
       delete tt-ped-item-aux.
   end.

   /* ver se usuario tem permissÆo para aprov/reprov */
   find first user-coml no-lock where
              user-coml.usuario = c-seg-usuario no-error.
   if user-coml.log-libera-cotas = no then do:           
      {utp/ut-liter.i Reprova‡Æo MAC c}
      run utp/ut-msgs.p(input "show",
                        input 6660,
                        input c-seg-usuario + "~~" + return-value).
      return no-apply.
   end.

   /* pedido ja reprovado */
   IF ped-venda.cod-sit-com = 3 THEN DO:  
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Pedido" *}
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 18042,    /*j  aprovado*/
                         INPUT RETURN-VALUE + " " + ped-venda.nr-pedcli ).
      RETURN 'no-apply'.
   END.              

   /* pedido reprovado por cr‚dito */
   if ped-venda.cod-sit-aval <> 2 and
      ped-venda.cod-sit-aval <> 3 then do:
      run utp/ut-msgs.p (input "show",
                         input 6270,
                         input "").
      return no-apply.
   end.       

   /* Pedido nÆo aprovado por WF de desconto */
   IF  para-ped.log-usa-aprovac-workflow 
   AND ped-venda.log-aprov-workflow = NO THEN DO:
               
       run utp/ut-msgs.p (input "show",
                          input 52327, 
                          input ped-venda.nr-pedcli + "~~" + ped-venda.nome-abrev).
       RETURN NO-APPLY.       

   END.

   if ped-venda.cod-sit-ped > 2 then do:

      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao002 = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.
          run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                              INPUT "",
                              INPUT "").
          ASSIGN  c-sit = RETURN-VALUE.
      &else
          ASSIGN c-sit = {diinc/i03di149.i 04 ped-venda.cod-sit-ped}.
      &endif
      {utp/ut-liter.i Pedido MPD e}
      assign c-traducao = return-value.      
      {utp/ut-liter.i Reprovado MAC c}.
      run utp/ut-msgs.p (input "show",
                         input 7972,
                         input c-traducao + " " + ped-venda.nr-pedcli + "~~" + 
                               return-value + "~~" + c-sit).
      return no-apply.
   end.

   assign c-quem-aprovou  = c-seg-usuario
          c-pe-motivo     = ""
          c-pe-motivo-no  = "".

   run acp/ac1004b.w (input-output c-quem-aprovou,
                      input-output dt-apr-cred,
                      input-output c-pe-motivo,
                      input-output c-pe-motivo-no,
                      output l-ok ).
   if l-ok then DO TRANS:

      IF  NOT VALID-HANDLE (h-bodi261) OR 
          h-bodi261:TYPE      <> "PROCEDURE":U OR 
          h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
          run dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

      RUN atualizarCotasPedido IN h-bodi261 (INPUT ROWID(ped-venda),
                                             INPUT 8, /*reprovar forcado*/
                                             INPUT TABLE tt-ped-item-aux).
      IF VALID-HANDLE(h-bodi261) THEN DO:
         DELETE PROCEDURE h-bodi261.
         ASSIGN h-bodi261 = ?.
      END.                  
      for each b-ped-venda where
               b-ped-venda.nr-pedcli = ped-venda.nr-pedcli and
               b-ped-venda.nome-abrev = ped-venda.nome-abrev exclusive-lock:
          for each b-ped-item of b-ped-venda exclusive-lock :              
              assign b-ped-item.motivo-alt-sit-quota = c-pe-motivo-no
                     b-ped-item.dat-alter-sit = dt-apr-cred
                     b-ped-item.cod-usu-alt-sit = c-quem-aprovou
                     b-ped-item.cod-sit-com   = 3 .                                
          end.      
          assign b-ped-venda.motivo-alt-sit-quota = c-pe-motivo-no
                 b-ped-venda.dat-alter-sit = dt-apr-cred
                 b-ped-venda.cod-usu-alt-sit = c-quem-aprovou
                 b-ped-venda.cod-sit-com   = 3 .                    

          run pi-envia-email-comercial (input b-ped-venda.nr-pedcli,
                                        input b-ped-venda.nome-abrev).

      end.    

      &IF DEFINED(bf_dis_adm_cotas) &THEN  /* 2.04 */         
          IF NOT VALID-HANDLE(h-bodi159cal) OR 
             h-bodi159cal:TYPE      <> "PROCEDURE":U OR 
             h-bodi159cal:FILE-NAME <> "dibo/bodi159cal.p":U THEN 
             RUN dibo/bodi159cal.p PERSISTENT SET h-bodi159cal.
          RUN setInvoicingAvaiable in h-bodi159cal(INPUT ROWID(ped-venda)).
          IF VALID-HANDLE(h-bodi159cal) THEN DO:
             DELETE PROCEDURE h-bodi159cal.
             ASSIGN h-bodi159cal = ?.
          END.    
      &ELSE  
          RUN cdp/cd4100.p ( INPUT ROWID(ped-venda) ).  
      &ENDIF

      assign v-prog-version = c-prg-vrs
             v-prog-obj     = c-prg-obj.

      /* Integra‡Æo EAI */
      &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then
         IF v_log_eai_habilit THEN DO:
            RUN adapters/xml/vd2/axsvd003.p (INPUT  "upd":U,
                                             INPUT  v-prog-obj,
                                             INPUT  v-prog-version,
                                             INPUT  ROWID(ped-venda),
                                             OUTPUT TABLE RowErrors).
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2}
                UNDO,RETURN NO-APPLY.
            end.                    
         END.
      &endif

     release b-ped-venda. 
     release b-ped-item.

      RUN dispatch IN h_q11di159 ('open-query-cases':U).             
      RUN pi-reposiciona-query IN h_b13di154 (INPUT rowid(ped-venda)).
      RUN dispatch IN h_v15di159 ('display-fields':U).   
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-anterior w-concom
ON CHOOSE OF MENU-ITEM mi-anterior /* Anterior */
DO:
  RUN pi-anterior IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-concom
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-concom
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-concom
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-concom
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-pesquisa w-concom
ON CHOOSE OF MENU-ITEM mi-pesquisa /* Pesquisa */
DO:
  RUN pi-pesquisa IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-primeiro w-concom
ON CHOOSE OF MENU-ITEM mi-primeiro /* Primeiro */
DO:
  RUN pi-primeiro IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-proximo w-concom
ON CHOOSE OF MENU-ITEM mi-proximo /* Pr¢ximo */
DO:
  RUN pi-proximo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-concom
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-concom
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-ultimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-ultimo w-concom
ON CHOOSE OF MENU-ITEM mi-ultimo /* éltimo */
DO:
  RUN pi-ultimo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-va-para w-concom
ON CHOOSE OF MENU-ITEM mi-va-para /* V  para */
DO:
  RUN pi-vapara IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-concom 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-concom  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-navega.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navega ).
       RUN set-position IN h_p-navega ( 1.33 , 1.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 24.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.33 , 73.57 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'divwr/v15di159.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v15di159 ).
       RUN set-position IN h_v15di159 ( 3.00 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.38 , 89.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'adm/objects/folder.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'FOLDER-LABELS = ':U + 'Itens Pedido' + ',
                     FOLDER-TAB-TYPE = 1':U ,
             OUTPUT h_folder ).
       RUN set-position IN h_folder ( 8.75 , 1.57 ) NO-ERROR.
       RUN set-size IN h_folder ( 8.92 , 88.57 ) NO-ERROR.

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'dibrw/b13di154.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b13di154 ).
       RUN set-position IN h_b13di154 ( 10.00 , 10.72 ) NO-ERROR.
       /* Size in UIB:  ( 7.25 , 72.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'diqry/q11di159.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'ProgPesquisa = dizoom/z06di159.w,
                     ProgVaPara = digo/g04di159.w,
                     ProgIncMod = ,
                     Implantar = no':U ,
             OUTPUT h_q11di159 ).
       RUN set-position IN h_q11di159 ( 1.00 , 27.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.79 , 8.29 ) */

       /* Links to SmartViewer h_v15di159. */
       RUN add-link IN adm-broker-hdl ( h_q11di159 , 'Record':U , h_v15di159 ).

       /* Links to SmartFolder h_folder. */
       RUN add-link IN adm-broker-hdl ( h_folder , 'Page':U , THIS-PROCEDURE ).

       /* Links to BrowserCadastro2 h_b13di154. */
       RUN add-link IN adm-broker-hdl ( h_q11di159 , 'Record':U , h_b13di154 ).

       /* Links to SmartQuery h_q11di159. */
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'Navigation':U , h_q11di159 ).
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'State':U , h_q11di159 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
             bt-aprovar:HANDLE IN FRAME f-cad , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-filtrar:HANDLE IN FRAME f-cad , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v15di159 ,
             h_p-exihel , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_folder ,
             h_v15di159 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b13di154 ,
             h_folder , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF adm-current-page eq 0 
  THEN RUN select-page IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-concom  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-concom  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-concom)
  THEN DELETE WIDGET w-concom.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-concom  _DEFAULT-ENABLE
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
  ENABLE bt-aprovar bt-reprovar bt-filtrar rt-button 
      WITH FRAME f-cad IN WINDOW w-concom.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-concom.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-concom 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-concom 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  {method/showmessage.i3}

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-concom 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  /* Inicia vari veis para o botÆo de filtro */
  assign l-cancela         = yes
         l-n-avaliado      = yes
         l-aprovado        = yes
         l-reprovado       = yes
         l-suspenso        = yes
         c-situacao        = "SSSS".

  run pi-before-initialize.

{utp/ut9000.i "AC1004" "2.00.00.016"}

  /* Implementado depois */

   for first ped-venda fields(ped-venda.cod-sit-com 
                              ped-venda.cod-sit-ped) no-lock
                  where rowid(ped-venda) = gr-ped-venda:
   end.    

   if  not avail ped-venda 
       or       (ped-venda.cod-sit-ped  >= 5 )
       or  not ((ped-venda.cod-sit-com  =  1 and l-n-avaliado)  
       or       (ped-venda.cod-sit-com  =  2 and l-aprovado  ) 
       or       (ped-venda.cod-sit-com  =  3 and l-reprovado ) 
       or       (ped-venda.cod-sit-com  =  4 and l-suspenso  )) then do:   
       run dispatch in h_q11di159 ('open-query-cases':U).
       run dispatch in h_q11di159 (input 'get-first':U).    
       run dispatch in h_q11di159 ('row-available':U).  
   end.
   ELSE do:
      run dispatch in h_q11di159 ('open-query-cases':U).
      run dispatch in h_q11di159 ('row-available':U).
   end.


  /************/                                    

  ASSIGN rw-ped-venda = gr-ped-venda.
  RUN set-attribute-list IN h_q11di159
      (INPUT "Reposition-Pending=YES":U).


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  assign h-handle-browse =  h_b13di154.


  IF gr-ped-venda <> ? THEN do:
     for first ped-venda fields(ped-venda.cod-sit-ped
                                ped-venda.cod-sit-com) no-lock
         where rowid(ped-venda) = gr-ped-venda.
     end.
      if  not avail ped-venda 
           or      (ped-venda.cod-sit-ped  >= 5 )
           or not ((ped-venda.cod-sit-com   = 1 and l-n-avaliado)  
           or      (ped-venda.cod-sit-com   = 2 and l-aprovado  ) 
           or      (ped-venda.cod-sit-com   = 3 and l-reprovado ) 
           or      (ped-venda.cod-sit-com   = 4 and l-suspenso  )) then do:     
           RUN dispatch IN h_q11di159 (INPUT "get-first":U).            
      end.
      else do:
       RUN pi-reposiciona-query IN h_q11di159 (INPUT gr-ped-venda).
      end.
  end.
  else do:
    RUN pi-reposiciona-query IN h_q11di159 (INPUT gr-ped-venda).
  end.


  ASSIGN gr-ped-venda = rw-ped-venda.

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-handle-query w-concom 
PROCEDURE pi-busca-handle-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param h-query as handle no-undo.

assign h-query = h_q11di159.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_ems_xref w-concom 
PROCEDURE pi_ems_xref :
/*------------------------------------------------------------------------------
  Purpose:     Referˆncias XRef
  Parameters:  <none> 
  Notes:       NÆo altere/elimine o c¢digo abaixo.
------------------------------------------------------------------------------*/
RUN dizoom/z06di159.w.
RUN digo/g04di159.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-concom 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN "panel/p-navega.w *RTB-SmObj* ".
  RUN "panel/p-exihel.w *RTB-SmObj* ".
  RUN "divwr/v15di159.w *RTB-SmObj* ".
  RUN "adm/objects/folder.w *RTB-SmObj* ".
  RUN "dibrw/b13di154.w *RTB-SmObj* ".
  RUN "diqry/q11di159.w *RTB-SmObj* ".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-concom  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-concom, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-concom 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email-comercial w-concom 
PROCEDURE pi-envia-email-comercial :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
-------------------------------------------------------------*/

  define input param p-nr-pedcli  as char no-undo.
  define input param p-nome-abrev as char no-undo.

  IF NOT AVAIL para-ped THEN
      FIND FIRST para-ped NO-LOCK NO-ERROR.

  IF SUBSTRING(para-ped.char-1,64,3) = "YES" THEN DO: /* Verifica se o parƒmetro de hist¢rico de pedido esta ativo no PD0301 */

      IF NOT VALID-HANDLE(h-bodi605) THEN                                         
         RUN dibo/bodi605.p PERSISTENT SET h-bodi605.                             
                                                                                  
      RUN logComercial IN h-bodi605 (INPUT p-nr-pedcli,                   
                                     INPUT p-nome-abrev).                 
                                                                                  
      IF VALID-HANDLE(h-bodi605) THEN DELETE PROCEDURE h-bodi605.                 
  END.
                                                                              
  IF NOT VALID-HANDLE(h-pdapi513e) THEN                                       
     RUN pdp/pdapi513e.p PERSISTENT SET h-pdapi513e.                          
                                                                              
  RUN piMandaEmailComercial IN h-pdapi513e (INPUT p-nr-pedcli,        
                                            INPUT p-nome-abrev).      
                                                                              
  IF VALID-HANDLE(h-pdapi513e) THEN DELETE PROCEDURE h-pdapi513e.             
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

