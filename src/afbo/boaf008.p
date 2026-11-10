&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAF008 2.00.00.046 } /*** "010046" 29/05/2025 12:29:13 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF008
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-contr-indice
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{afbo/boaf008.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfaf-item-contr-estab-form FOR af-item-contr-estab-form.
DEFINE BUFFER bf2-af-contr-indice FOR af-contr-indice.
def temp-table tt-af-contr-indice NO-UNDO like af-contr-indice.
{utp/ut-glob.i}
def var c-periodo    as char format "99/9999".
def var da-dt-indice as DATE NO-UNDO.

def var c-cod-estabel-ini   like {&TableName}.cod-estabel  no-undo.
def var c-cod-estabel-fim   like {&TableName}.cod-estabel  no-undo.
def var i-cod-emitente-ini  like {&TableName}.cod-emitente no-undo.
def var i-cod-emitente-fim  like {&TableName}.cod-emitente no-undo.
def var c-it-codigo-ini     like {&tablename}.it-codigo    no-undo.
def var c-it-codigo-fim     like {&tablename}.it-codigo    no-undo.
def var i-nr-controle-ini   like {&TableName}.nr-controle  no-undo.
def var i-nr-controle-fim   like {&TableName}.nr-controle  no-undo.
def var da-dt-indice-ini    like {&TableName}.dt-indice    no-undo.
def var da-dt-indice-fim    like {&TableName}.dt-indice    no-undo.

DEFINE VARIABLE dt-data-indice AS DATE       NO-UNDO.
DEFINE VARIABLE i-cont         AS INT        NO-UNDO.
DEFINE VARIABLE l-erro-periodo AS LOG        NO-UNDO.
DEFINE VARIABLE h-boaf016      AS HANDLE     NO-UNDO. 
DEFINE VARIABLE h-boaf021      AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boaf023      AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boaf006      AS HANDLE     NO-UNDO.

{afbo/boaf008.i1}
{afbo/boaf008.i2} /* tt-filtro */
{afbo/boaf008.i3 tt-af-contr-indice-aux}
{afbo/boaf016.i1}
DEFINE TEMP-TABLE tt-versao-data NO-UNDO
    FIELD nr-versao      LIKE af-versao-avaliacao.nr-versao
    FIELD desc-versao    LIKE af-versao-avaliacao.desc-versao
    FIELD ano-avaliacao  LIKE af-versao-avaliacao.ano-avaliacao
    FIELD nr-periodo     LIKE af-versao-avaliacao.nr-periodo
    FIELD data-ini       AS DATE
    FIELD data-fim       AS DATE
    INDEX data-inicial
          data-ini.

DEFINE TEMP-TABLE tt-item-data NO-UNDO LIKE tt-versao-data.
DEFINE TEMP-TABLE tt-dt-periodo-aval2 NO-UNDO LIKE tt-dt-periodo-aval.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 21.75
         WIDTH              = 43.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run piAtualizaDatas.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH af-contr-indice-mov
       WHERE af-contr-indice-mov.ep-codigo     = i-ep-codigo-usuario
         AND af-contr-indice-mov.cod-estabel   = RowObject.cod-estabel
         AND af-contr-indice-mov.cod-emitente  = RowObject.cod-emitente
         AND af-contr-indice-mov.it-codigo     = RowObject.it-codigo 
         AND af-contr-indice-mov.dt-indice     = RowObject.dt-indice 
         AND af-contr-indice-mov.nr-controle   = RowObject.nr-controle 
         EXCLUSIVE-LOCK:
         DELETE af-contr-indice-mov.
    END.

    FOR EACH af-contr-indice-var
       WHERE af-contr-indice-var.ep-codigo     = i-ep-codigo-usuario
         AND af-contr-indice-var.cod-estabel   = RowObject.cod-estabel
         AND af-contr-indice-var.cod-emitente  = RowObject.cod-emitente
         AND af-contr-indice-var.it-codigo     = RowObject.it-codigo 
         AND af-contr-indice-var.dt-indice     = RowObject.dt-indice 
         AND af-contr-indice-var.nr-controle   = RowObject.nr-controle 
         EXCLUSIVE-LOCK:
         DELETE af-contr-indice-var.
    END.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run piAtualizaDatas.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST af-item-contr-estab-form FIELDS(percentual)
        WHERE af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario 
        AND   af-item-contr-estab-form.cod-estabel  = rowObject.cod-estabel 
        AND   af-item-contr-estab-form.cod-emitente = rowObject.cod-emitente 
        AND   af-item-contr-estab-form.nr-versao    = rowObject.nr-versao
        AND   af-item-contr-estab-form.it-codigo    = rowObject.it-codigo 
        AND   af-item-contr-estab-form.nr-controle  = rowObject.nr-controle
        NO-LOCK: END.
    IF AVAIL af-item-contr-estab-form THEN
       ASSIGN rowObject.percentual  =  af-item-contr-estab-form.percentual
              rowObject.nota        =  round(rowObject.indice * af-item-contr-estab-form.percentual / 100,2).
    
    ASSIGN rowObject.dt-alter    = TODAY
           rowObject.hora-alter  = STRING(TIME,"hh:mm:ss")
           rowObject.usuar-alter = c-seg-usuario.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "hora-alter":U THEN ASSIGN pFieldValue = RowObject.hora-alter.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "usuar-alter":U THEN ASSIGN pFieldValue = RowObject.usuar-alter.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataPeriodo DBOProgram 
PROCEDURE getDataPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-dt-indice as date no-undo.

assign p-dt-indice = date(int(substr(c-periodo,1,2)),01, 
                          int(substr(c-periodo,3,4))) no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-alter":U THEN ASSIGN pFieldValue = RowObject.dt-alter.
        WHEN "dt-implantacao":U THEN ASSIGN pFieldValue = RowObject.dt-implantacao.
        WHEN "dt-indice":U THEN ASSIGN pFieldValue = RowObject.dt-indice.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "indice":U THEN ASSIGN pFieldValue = RowObject.indice.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesControle DBOProgram 
PROCEDURE getDesControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-nr-controle like af-controle.nr-controle.
def output param p-des-controle like af-controle.descricao.

assign p-des-controle = "".

for first af-controle fields(descricao)
    where af-controle.nr-controle = p-nr-controle no-lock. end.
if avail af-controle then
   assign p-des-controle = af-controle.descricao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesEmitente DBOProgram 
PROCEDURE getDesEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-emitente like emitente.cod-emitente.
def output param p-des-emitente like emitente.nome-emit.

assign p-des-emitente = "".

for first emitente fields(nome-emit)
    where emitente.cod-emitente = p-cod-emitente no-lock. end.
if avail emitente then
   assign p-des-emitente = emitente.nome-emit.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesEstabelec DBOProgram 
PROCEDURE getDesEstabelec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-cod-estabel like estabelec.cod-estabel.
def output param p-nome-estabel like estabelec.nome.

assign p-nome-estabel = "".

for first estabelec fields(cod-estabel nome)
    where estabelec.cod-estabel = p-cod-estabel no-lock. end.
if avail estabelec then
   assign p-nome-estabel = estabelec.nome.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDesItem DBOProgram 
PROCEDURE getDesItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-it-codigo like item.it-codigo.
def output param p-des-item like item.desc-item.

assign p-des-item = "".

if p-it-codigo = "" then
   assign p-des-item = "      ---------  ÷ndice v†lido para todos itens  ---------".
else do:
    for first item fields(desc-item)
        where item.it-codigo = p-it-codigo no-lock. end.
    if avail item then
       assign p-des-item = item.desc-item.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndices DBOProgram 
PROCEDURE getIndices :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter table for tt-filtro.
    define output parameter table for tt-af-contr-indice-aux.

    empty temp-table tt-af-contr-indice-aux.
    empty temp-table tt-dt-periodo-aval.

    find first tt-filtro no-error.

    FIND FIRST param-af NO-LOCK
        WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.

    if  not valid-handle (h-boaf016) then
        run afbo/boaf016.p persistent set h-boaf016.

    /* Retorna temp-table com as datas referentes ao per°odo selecionado */
    run retornaPeriodosFaixa in h-boaf016 (input int(tt-filtro.ano-ini), 
                                           input tt-filtro.periodo-ini, 
                                           input int(tt-filtro.ano-fim),
                                           input tt-filtro.periodo-fim, 
                                           output table tt-dt-periodo-aval).
    
    IF param-af.log-usa-versao THEN DO:
        IF NOT VALID-HANDLE(h-boaf023) THEN
            RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
         
        RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                              OUTPUT TABLE tt-versao-data).
    END.
    
    FOR EACH af-controle WHERE 
         af-controle.ep-codigo       = i-ep-codigo-usuario AND
         af-controle.nr-controle    >= tt-filtro.nr-controle-ini     AND 
         af-controle.nr-controle    <= tt-filtro.nr-controle-fim     NO-LOCK:

        if  af-controle.padrao 
             or af-controle.log-especifico
             or af-controle.log-formula then 
            NEXT.
         
        for each af-item-contr-estab-form
           where af-item-contr-estab-form.ep-codigo      = i-ep-codigo-usuario
           AND   af-item-contr-estab-form.nr-controle    = af-controle.nr-controle
           and   af-item-contr-estab-form.cod-estabel   >= tt-filtro.cod-estabel-ini  
           and   af-item-contr-estab-form.cod-estabel   <= tt-filtro.cod-estabel-fim  
           and   af-item-contr-estab-form.cod-emitente  >= tt-filtro.cod-emitente-ini 
           and   af-item-contr-estab-form.cod-emitente  <= tt-filtro.cod-emitente-fim 
           and   af-item-contr-estab-form.it-codigo     >= tt-filtro.it-codigo-ini    
           and   af-item-contr-estab-form.it-codigo     <= tt-filtro.it-codigo-fim
           and   af-item-contr-estab-form.cod-grp-resp  >= tt-filtro.cod-grp-resp-ini 
           and   af-item-contr-estab-form.cod-grp-resp  <= tt-filtro.cod-grp-resp-fim  no-lock,
        first af-item-contr-estab  fields (nr-versao cod-grp-avaliacao ativo it-codigo cod-emitente cod-estabel)             
            where af-item-contr-estab.ep-codigo          = i-ep-codigo-usuario
            and   af-item-contr-estab.it-codigo          = af-item-contr-estab-form.it-codigo
            and   af-item-contr-estab.cod-emitente       = af-item-contr-estab-form.cod-emitente
            AND   af-item-contr-estab.nr-versao          = af-item-contr-estab-form.nr-versao
            and   af-item-contr-estab.cod-estabel        = af-item-contr-estab-form.cod-estabel
            and   af-item-contr-estab.cod-grp-avaliacao >= tt-filtro.cod-grp-aval-ini
            and   af-item-contr-estab.cod-grp-avaliacao <= tt-filtro.cod-grp-aval-fim no-lock,
        first emitente fields (nome-emit)
            where emitente.cod-emitente = af-item-contr-estab-form.cod-emitente
            and   emitente.cod-gr-forn >= tt-filtro.cod-gr-forn-ini
            and   emitente.cod-gr-forn <= tt-filtro.cod-gr-forn-fim no-lock,
        first item fields (desc-item)
            where item.it-codigo  = af-item-contr-estab-form.it-codigo
            and   item.fm-codigo >= tt-filtro.fm-codigo-ini
            and   item.fm-codigo <= tt-filtro.fm-codigo-fim
            and   item.ge-codigo >= tt-filtro.ge-codigo-ini
            and   item.ge-codigo <= tt-filtro.ge-codigo-fim no-lock:

                /*verificar parametro de versao:*/
                IF param-af.log-usa-versao THEN DO:
                     IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
                        IF NOT VALID-HANDLE(h-boaf006) THEN
                            RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
                        RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                              INPUT af-item-contr-estab.it-codigo,
                                                              INPUT af-item-contr-estab.cod-emitente,
                                                              INPUT af-item-contr-estab.cod-estabel,
                                                              INPUT TABLE tt-versao-data,
                                                              OUTPUT TABLE tt-item-data).
                        FOR EACH tt-item-data NO-LOCK:
                            FOR EACH tt-dt-periodo-aval:
                                IF tt-dt-periodo-aval.dt-periodo-ini >= tt-item-data.data-ini AND
                                   tt-dt-periodo-aval.dt-periodo-fim <= tt-item-data.data-fim THEN DO:
                                   IF tt-item-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                                        NEXT.               
                                   ELSE
                                        run piCriaIndice in THIS-PROCEDURE (INPUT tt-item-data.nr-versao).
                                END.
                                ELSE DO:
                                    NEXT.
                                END.
                            END.
                        END.
                     END.
                     ELSE DO: /* controle de validade conforme cadastro de versoes */
                        FOR EACH tt-versao-data NO-LOCK:
                            FOR EACH tt-dt-periodo-aval:
                                IF tt-dt-periodo-aval.dt-periodo-ini >= tt-versao-data.data-ini AND
                                   tt-dt-periodo-aval.dt-periodo-fim <= tt-versao-data.data-fim THEN DO:
                                   IF tt-versao-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                                        NEXT.               
                                   ELSE
                                        run piCriaIndice in THIS-PROCEDURE (INPUT tt-versao-data.nr-versao).
                                END.
                                ELSE DO:
                                    NEXT.
                                END.
                            END.
                        END.
                     END.

                END.
                ELSE DO:
                    FOR EACH tt-dt-periodo-aval:
                       RUN piCriaIndice IN THIS-PROCEDURE(INPUT af-item-contr-estab.nr-versao).
                    END.
                END.
        END.
    END. 
    /* Quando o item for branoc o apontamento sera valido para todos os 
       itens do periodo. */
    run piFiltraQuebraIndice.
    
    if  valid-handle (h-boaf016) then do:
        delete procedure h-boaf016.
        assign h-boaf016 = ?.
    end.
    if  valid-handle (h-boaf023) then do:
        delete procedure h-boaf023.
        assign h-boaf023 = ?.
    end.
    if  valid-handle (h-boaf006) then do:
        delete procedure h-boaf006.
        assign h-boaf006 = ?.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndicesUsuario DBOProgram 
PROCEDURE getIndicesUsuario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter p-cod-usuario like usuar-mater.cod-usuario no-undo.
    define input  parameter table for tt-filtro.
    define output parameter table for tt-af-contr-indice-aux.

    empty temp-table tt-af-contr-indice-aux.
    empty temp-table tt-dt-periodo-aval.

    find first tt-filtro no-error.

    if  not valid-handle (h-boaf016) then
        run afbo/boaf016.p persistent set h-boaf016.

    /* Retorna temp-table com as datas referentes ao per°odo selecionado */
    run retornaPeriodosFaixa in h-boaf016 (input int(tt-filtro.ano-ini), 
                                           input tt-filtro.periodo-ini, 
                                           input int(tt-filtro.ano-fim),
                                           input tt-filtro.periodo-fim, 
                                           output table tt-dt-periodo-aval).
    FIND FIRST param-af NO-LOCK
        WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.
    IF param-af.log-usa-versao THEN DO:
        IF NOT VALID-HANDLE(h-boaf023) THEN
            RUN afbo/boaf023.p PERSISTENT SET h-boaf023.
        RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                              OUTPUT TABLE tt-versao-data).
    END.
        
    /* Verifica todos os grupos que o usu†rio pertence */
    for each  af-grp-resp-usuario
        where af-grp-resp-usuario.ep-codigo     = i-ep-codigo-usuario 
        and   af-grp-resp-usuario.cod-usuario   = p-cod-usuario 
        and   af-grp-resp-usuario.cod-grp-resp >= tt-filtro.cod-grp-resp-ini
        and   af-grp-resp-usuario.cod-grp-resp <= tt-filtro.cod-grp-resp-fim no-lock:

        FOR EACH af-controle WHERE 
             af-controle.ep-codigo       = i-ep-codigo-usuario AND
             af-controle.nr-controle    >= tt-filtro.nr-controle-ini     AND 
             af-controle.nr-controle    <= tt-filtro.nr-controle-fim     NO-LOCK:
         
            /* Se o ponto de controle for padr∆o ou espec°fico n∆o dever† ser digitado, ent∆o ser† ignorado */
            IF af-controle.padrao 
               or af-controle.log-especifico
               or af-controle.log-formula then 
                NEXT.

            /* Verifica os pontos de controle sob responsabilidade do grupo */
            for each af-item-contr-estab-form
               where af-item-contr-estab-form.ep-codigo      = af-grp-resp-usuario.ep-codigo
               AND   af-item-contr-estab-form.nr-controle    = af-controle.nr-controle
               and   af-item-contr-estab-form.cod-grp-resp   = af-grp-resp-usuario.cod-grp-resp
               and   af-item-contr-estab-form.cod-estabel   >= tt-filtro.cod-estabel-ini  
               and   af-item-contr-estab-form.cod-estabel   <= tt-filtro.cod-estabel-fim  
               and   af-item-contr-estab-form.cod-emitente  >= tt-filtro.cod-emitente-ini 
               and   af-item-contr-estab-form.cod-emitente  <= tt-filtro.cod-emitente-fim 
               and   af-item-contr-estab-form.it-codigo     >= tt-filtro.it-codigo-ini    
               and   af-item-contr-estab-form.it-codigo     <= tt-filtro.it-codigo-fim no-lock,
            first af-item-contr-estab fields (nr-versao cod-grp-avaliacao ativo it-codigo cod-emitente cod-estabel)
                where af-item-contr-estab.ep-codigo          = i-ep-codigo-usuario
                and   af-item-contr-estab.it-codigo          = af-item-contr-estab-form.it-codigo
                and   af-item-contr-estab.cod-emitente       = af-item-contr-estab-form.cod-emitente
                AND   af-item-contr-estab.nr-versao          = af-item-contr-estab-form.nr-versao
                and   af-item-contr-estab.cod-estabel        = af-item-contr-estab-form.cod-estabel
                and   af-item-contr-estab.cod-grp-avaliacao >= tt-filtro.cod-grp-aval-ini
                and   af-item-contr-estab.cod-grp-avaliacao <= tt-filtro.cod-grp-aval-fim no-lock,
            first emitente fields (nome-emit)
                where emitente.cod-emitente = af-item-contr-estab-form.cod-emitente
                and   emitente.cod-gr-forn >= tt-filtro.cod-gr-forn-ini
                and   emitente.cod-gr-forn <= tt-filtro.cod-gr-forn-fim no-lock,
            first item fields (desc-item)
                where item.it-codigo  = af-item-contr-estab-form.it-codigo
                and   item.fm-codigo >= tt-filtro.fm-codigo-ini
                and   item.fm-codigo <= tt-filtro.fm-codigo-fim
                and   item.ge-codigo >= tt-filtro.ge-codigo-ini
                and   item.ge-codigo <= tt-filtro.ge-codigo-fim no-lock:
    
                if  not avail estabelec
                or  estabelec.cod-estabel <> af-item-contr-estab-form.cod-estabel then
                    for first estabelec fields (cod-estabel nome)
                        where estabelec.cod-estabel = af-item-contr-estab-form.cod-estabel no-lock: end.
    
                if  not avail af-grp-avaliacao
                or (avail af-grp-avaliacao and  af-grp-avaliacao.cod-grp-avaliacao <> af-item-contr-estab.cod-grp-avaliacao) then
                    for first af-grp-avaliacao fields (cod-grp-avaliacao des-grp-avaliacao)
                        where af-grp-avaliacao.cod-grp-avaliacao = af-item-contr-estab.cod-grp-avaliacao no-lock: end.

                IF param-af.log-usa-versao THEN DO:
                    IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
                        IF NOT VALID-HANDLE(h-boaf006) THEN
                            RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
                        RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                              INPUT af-item-contr-estab.it-codigo,
                                                              INPUT af-item-contr-estab.cod-emitente,
                                                              INPUT af-item-contr-estab.cod-estabel,
                                                              INPUT TABLE tt-versao-data,
                                                              OUTPUT TABLE tt-item-data).
                        FOR EACH tt-item-data NO-LOCK:
                            FOR EACH tt-dt-periodo-aval:
                                IF tt-dt-periodo-aval.dt-periodo-ini >= tt-item-data.data-ini AND
                                   tt-dt-periodo-aval.dt-periodo-fim <= tt-item-data.data-fim THEN DO:
                                   
                                   IF tt-item-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                                        NEXT.               
                                   ELSE
                                        run piCriaIndice in THIS-PROCEDURE (INPUT tt-item-data.nr-versao).
                                END.
                                ELSE DO:
                                    NEXT.
                                END.
                            END.
                        END.
                    END.
                    ELSE DO: /* controle de validade conforme cadastro de versoes */
                         FOR EACH tt-versao-data NO-LOCK:
                            FOR EACH tt-dt-periodo-aval:
                                IF tt-dt-periodo-aval.dt-periodo-ini >= tt-versao-data.data-ini AND
                                   tt-dt-periodo-aval.dt-periodo-fim <= tt-versao-data.data-fim THEN DO:
                                   
                                   IF tt-versao-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                                        NEXT.               
                                   ELSE
                                        run piCriaIndice in THIS-PROCEDURE (INPUT tt-versao-data.nr-versao).
                                END.
                                ELSE DO:
                                    NEXT.
                                END.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    FOR EACH tt-dt-periodo-aval:
                       RUN piCriaIndice IN THIS-PROCEDURE(INPUT af-item-contr-estab.nr-versao).
                    END. 
                END.

            END.
        end.
    end.

   run piFiltraQuebraIndice.
    
    if  valid-handle (h-boaf016) then do:
        delete procedure h-boaf016.
        assign h-boaf016 = ?.
    end.

    IF VALID-HANDLE (h-boaf023) THEN DO:
        DELETE PROCEDURE h-boaf023.
        ASSIGN h-boaf023 = ?.
    END.
    IF  valid-handle (h-boaf006) THEN DO:
        DELETE PROCEDURE h-boaf006.
        ASSIGN h-boaf006 = ?.
    END.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "nr-controle":U THEN ASSIGN pFieldValue = RowObject.nr-controle.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-ind
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo nr-controle
               retorna valor do campo dt-indice
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE af-contr-indice.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-controle LIKE af-contr-indice.nr-controle NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-indice LIKE af-contr-indice.dt-indice NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE af-contr-indice.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE af-contr-indice.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE af-contr-indice.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pnr-controle = RowObject.nr-controle
           pdt-indice = RowObject.dt-indice
           pit-codigo = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente
           pcod-estabel = RowObject.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNotas DBOProgram 
PROCEDURE getNotas :
/*------------------------------------------------------------------------------
  Purpose:    Cria temp-table para consulta e relat¢rio das notas   
  Parameters: Retorna temp-table tt-notas, definida na boaf008.i1.
  Notes:      O campo tipo da temp-table pode conter os seguintes valores:
              
              DE - Detalhe, ou seja, °ndice digitado no af0301 ou calculado no af0303.
              TF - Total Fornecedor.
              DF - Detalhe Fornecedor, ou seja, pontos de controle do fornecedor.
              TI - Total Item por fornecedor .
              
              p-filtro - 1 TODOS
                         2 Melhores
                         3 Piores
              p-melhor-pior - N£mero de fornecedores a listar considerando 
                              p-filtro igual a 2 ou 3.       
                              
              p-media  - 1 Sem mÇdia
                         2 Notas do per°odo + mÇdia
                         3 Apenas mÇdia
------------------------------------------------------------------------------*/
def input param c-cod-estabel-ini  like af-contr-indice.cod-estabel      no-undo.
def input param c-cod-estabel-fim  like af-contr-indice.cod-estabel      no-undo.      
def input param i-cod-emitente-ini like af-contr-indice.cod-emitente     no-undo.                                        
def input param i-cod-emitente-fim like af-contr-indice.cod-emitente     no-undo.
def input param c-it-codigo-ini    like af-contr-indice.it-codigo        no-undo.
def input param c-it-codigo-fim    like af-contr-indice.it-codigo        no-undo.
def input param i-nr-controle-ini  like af-contr-indice.nr-controle      no-undo.
def input param i-nr-controle-fim  like af-contr-indice.nr-controle      no-undo.
def input param i-ano-ini          LIKE af-periodo-aval.ano-avaliacao    no-undo.
def input param c-periodo-ini      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
def input param i-ano-fim          LIKE af-periodo-aval.ano-avaliacao    no-undo.
def input param c-periodo-fim      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
def input param c-cod-grp-aval-ini like af-item-contr-estab.cod-grp-avaliacao no-undo.
def input param c-cod-grp-aval-fim like af-item-contr-estab.cod-grp-avaliacao no-undo.
DEF INPUT PARAM c-cod-grp-resp-ini LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
DEF INPUT PARAM c-cod-grp-resp-fim LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
def input param i-cod-gr-forn-ini  like emitente.cod-gr-forn             no-undo.
def input param i-cod-gr-forn-fim  like emitente.cod-gr-forn             no-undo.
def input param c-fm-codigo-ini    like item.fm-codigo                   no-undo.
def input param c-fm-codigo-fim    like item.fm-codigo                   no-undo.
def input param i-ge-codigo-ini    like item.ge-codigo                   no-undo.
def input param i-ge-codigo-fim    like item.ge-codigo                   no-undo.
def input param p-filtro           as   int                              no-undo.
def input param p-melhor-pior      as   int                              no-undo.
def input param p-media            as   int                              no-undo.
def output param table for tt-notas .

def var de-tot-for         as dec     no-undo.
def var de-tot-item        as dec     no-undo.
def var de-tot-perc        as dec     no-undo.
def var de-tot-indice      as dec     no-undo.
def var de-nr-for          as dec     no-undo.
def var de-nr-item         as dec     no-undo.
def var i-ano              as int     no-undo.
def var i-mes              as int     no-undo.
def var i-mes-ini          as int     no-undo.
def var da-dt-indice       as date    no-undo.
def var c-dt-ini           as char format "99/9999" no-undo.
def var c-dt-fim           as char format "99/9999" no-undo.
def buffer b-tt-notas for tt-notas.
def var i-count            as int no-undo.
def var de-ultima-nota     as dec no-undo.
def var de-ultima-nota-aux as dec no-undo.
DEF VAR i-emit-old         LIKE emitente.cod-emitente NO-UNDO.
DEF VAR c-it-old           LIKE ITEM.it-codigo NO-UNDO.
DEF VAR h-boaf016          AS HANDLE NO-UNDO.
def var da-data-ini        as date no-undo.
def var da-data-fim        as date no-undo.

for each tt-notas:
    delete tt-notas.
end.

IF NOT VALID-HANDLE(h-boaf006) THEN
    RUN afbo/boaf006.p PERSISTENT SET h-boaf006.
IF NOT VALID-HANDLE(h-boaf023) THEN
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.

FIND FIRST param-af NO-LOCK
    WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.

RUN afbo/boaf016.p persistent set h-boaf016.

RUN retornaPeriodosFaixa IN h-boaf016 (INPUT i-ano-ini, 
                                       INPUT c-periodo-ini,
                                       INPUT i-ano-fim,
                                       INPUT c-periodo-fim,
                                       OUTPUT TABLE tt-dt-periodo-aval).
IF VALID-HANDLE(h-boaf016) THEN DO:
    DELETE PROCEDURE h-boaf016.
    ASSIGN h-boaf016 = ?.
END.

IF param-af.log-usa-versao THEN DO:
    RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                          OUTPUT TABLE tt-versao-data).
END.

IF VALID-HANDLE(h-boaf023) THEN DO:
    DELETE PROCEDURE h-boaf023.
    ASSIGN h-boaf023 = ?.
END.

/*Controle de validade conforme CADASTRO DE VERSÂES*/
IF param-af.log-usa-versao AND param-af.i-tipo-validade-versao = 2  THEN DO: 

    FOR EACH tt-dt-periodo-aval: /*Filtro informado em tela  (outubro por exemplo)*/
        
        /* TT com a validade da vers∆o (Exemplo: Vers∆o 1, ano de 2018) */
        FOR EACH tt-versao-data NO-LOCK:
            IF  tt-dt-periodo-aval.dt-periodo-ini >= tt-versao-data.data-ini 
            AND tt-dt-periodo-aval.dt-periodo-fim <= tt-versao-data.data-fim THEN DO:
                
                FOR EACH af-item-contr-estab FIELDS(cod-emitente it-codigo cod-estabel nr-versao cod-grp-avaliacao)
                   WHERE af-item-contr-estab.ep-codigo      = i-ep-codigo-usuario 
                     AND af-item-contr-estab.it-codigo     >= c-it-codigo-ini 
                     AND af-item-contr-estab.it-codigo     <= c-it-codigo-fim
                     AND af-item-contr-estab.cod-emitente  >= i-cod-emitente-ini
                     AND af-item-contr-estab.cod-emitente  <= i-cod-emitente-fim
                     AND af-item-contr-estab.cod-estabel   >= c-cod-estabel-ini
                     AND af-item-contr-estab.cod-estabel   <= c-cod-estabel-fim
                     AND af-item-contr-estab.nr-versao      = tt-versao-data.nr-versao NO-LOCK:

                    IF af-item-contr-estab.cod-grp-avaliacao < c-cod-grp-aval-ini 
                    OR af-item-contr-estab.cod-grp-avaliacao > c-cod-grp-aval-fim THEN NEXT.

                    IF NOT AVAIL emitente OR i-emit-old <> af-item-contr-estab.cod-emitente THEN DO:
                        FOR FIRST emitente FIELDS(cod-gr-forn nome-emit nome-abrev) 
                            WHERE emitente.cod-emitente = af-item-contr-estab.cod-emitente NO-LOCK: END.
                        IF NOT AVAIL emitente THEN NEXT.
                        ASSIGN i-emit-old = af-item-contr-estab.cod-emitente.
                    END.
                    
                    IF emitente.cod-gr-forn < i-cod-gr-forn-ini 
                    OR emitente.cod-gr-forn > i-cod-gr-forn-fim THEN NEXT.
                
                    FOR FIRST item FIELDS(fm-codigo ge-codigo desc-item)
                        WHERE item.it-codigo = af-item-contr-estab.it-codigo NO-LOCK: END.
                    IF NOT AVAIL ITEM THEN NEXT.

                    IF item.fm-codigo < c-fm-codigo-ini 
                    OR item.fm-codigo > c-fm-codigo-fim THEN NEXT.

                    IF item.ge-codigo < i-ge-codigo-ini 
                    OR item.ge-codigo > i-ge-codigo-fim THEN NEXT.

                    RUN piCriaTTnotas  (INPUT i-nr-controle-ini, 
                                        INPUT i-nr-controle-fim, 
                                        INPUT c-cod-grp-resp-ini,
                                        INPUT c-cod-grp-resp-fim).
                END.
            END.
        END.
    END.
END.
ELSE DO:
    /* Verifica os itens que n∆o tiveram as notas livres, pois foram digitadas por fornecedor com item branco */
    for each af-item-contr-estab FIELDS(cod-emitente it-codigo cod-estabel nr-versao)
       where af-item-contr-estab.ep-codigo          = i-ep-codigo-usuario 
         and af-item-contr-estab.cod-estabel       >= c-cod-estabel-ini
         and af-item-contr-estab.cod-estabel       <= c-cod-estabel-fim
         and af-item-contr-estab.cod-emitente      >= i-cod-emitente-ini
         and af-item-contr-estab.cod-emitente      <= i-cod-emitente-fim
         and af-item-contr-estab.it-codigo         >= c-it-codigo-ini 
         and af-item-contr-estab.it-codigo         <= c-it-codigo-fim
         and af-item-contr-estab.cod-grp-avaliacao >= c-cod-grp-aval-ini 
         and af-item-contr-estab.cod-grp-avaliacao <= c-cod-grp-aval-fim no-lock:
    
         IF NOT AVAIL emitente OR i-emit-old <> af-item-contr-estab.cod-emitente THEN DO:
             for first emitente fields(cod-gr-forn nome-emit nome-abrev) 
                 where emitente.cod-emitente = af-item-contr-estab.cod-emitente no-lock: end.
             if not avail emitente then next.
             ASSIGN i-emit-old = af-item-contr-estab.cod-emitente.
         END.
         if emitente.cod-gr-forn < i-cod-gr-forn-ini or
            emitente.cod-gr-forn > i-cod-gr-forn-fim then next.
    
         for first item fields(fm-codigo ge-codigo desc-item)
             where item.it-codigo = af-item-contr-estab.it-codigo no-lock: end.
         if not avail item then next.
         if item.fm-codigo < c-fm-codigo-ini or
            item.fm-codigo > c-fm-codigo-fim then next.
         if item.ge-codigo < i-ge-codigo-ini or
            item.ge-codigo > i-ge-codigo-fim then next.
    
         IF param-af.log-usa-versao THEN DO:
             IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
                 RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                       INPUT af-item-contr-estab.it-codigo,
                                                       INPUT af-item-contr-estab.cod-emitente,
                                                       INPUT af-item-contr-estab.cod-estabel,
                                                       INPUT TABLE tt-versao-data,
                                                       OUTPUT TABLE tt-item-data).
        
                 FOR EACH tt-dt-periodo-aval: 
                    /* validar af-item-contr-estab */
                    FOR EACH tt-item-data NO-LOCK:
                        IF tt-dt-periodo-aval.dt-periodo-ini >= tt-item-data.data-ini AND
                           tt-dt-periodo-aval.dt-periodo-fim <= tt-item-data.data-fim THEN DO:
            
                            IF tt-item-data.nr-versao <> af-item-contr-estab.nr-versao THEN
                               NEXT.               
            
                            RUN piCriaTTnotas  (input i-nr-controle-ini, 
                                                input i-nr-controle-fim, 
                                                input c-cod-grp-resp-ini,
                                                input c-cod-grp-resp-fim).
    
                        END.
                        ELSE
                            NEXT.
                    END.
                 END. /* for each tt-dt-periodo-aval */
             END.
         END.
         ELSE DO: /* nao utiliza versao */
            FOR EACH tt-dt-periodo-aval: 
                RUN piCriaTTnotas  (input i-nr-controle-ini, 
                                    input i-nr-controle-fim, 
                                    input c-cod-grp-resp-ini,
                                    input c-cod-grp-resp-fim).
            END. /* for each tt-dt-periodo-aval */
         END.
    END.
END.

ASSIGN i-emit-old = 0
       c-it-old   = "".

FOR EACH af-controle FIELDS(padrao log-formula log-especifico nr-controle descricao)
   where af-controle.ep-codigo   = i-ep-codigo-usuario 
     and af-controle.nr-controle >= i-nr-controle-ini
     and af-controle.nr-controle <= i-nr-controle-fim no-lock:

     IF af-controle.padrao OR
        af-controle.log-formula OR
        af-controle.log-especifico THEN NEXT.

    /* Verifica os itens que n∆o tiveram as notas livres, pois foram digitadas por fornecedor com item branco */
    for each af-item-contr-estab-form FIELDS(it-codigo cod-emitente cod-estabel nr-versao nr-controle cod-grp-resp percentual)
       where af-item-contr-estab-form.ep-codigo = i-ep-codigo-usuario 
         and af-item-contr-estab-form.cod-estabel >= c-cod-estabel-ini
         and af-item-contr-estab-form.cod-estabel <= c-cod-estabel-fim
         and af-item-contr-estab-form.cod-emitente >= i-cod-emitente-ini
         and af-item-contr-estab-form.cod-emitente <= i-cod-emitente-fim
         and af-item-contr-estab-form.it-codigo >= c-it-codigo-ini 
         and af-item-contr-estab-form.it-codigo <= c-it-codigo-fim
         AND af-item-contr-estab-form.cod-grp-resp >= c-cod-grp-resp-ini 
         AND af-item-contr-estab-form.cod-grp-resp <= c-cod-grp-resp-fim
         and af-item-contr-estab-form.nr-controle = af-controle.nr-controle no-lock:

         IF param-af.log-usa-versao THEN DO:            
            RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                                  INPUT af-item-contr-estab-form.it-codigo,
                                                  INPUT af-item-contr-estab-form.cod-emitente,
                                                  INPUT af-item-contr-estab-form.cod-estabel,
                                                  INPUT TABLE tt-versao-data,
                                                  OUTPUT TABLE tt-item-data).
         END.

         IF NOT AVAIL ITEM OR af-item-contr-estab-form.it-codigo <> c-it-old THEN DO:
            for first item fields(fm-codigo ge-codigo desc-item)
                 where item.it-codigo = af-item-contr-estab-form.it-codigo no-lock: end.
             if not avail item then next.
             ASSIGN c-it-old = af-item-contr-estab-form.it-codigo.
         END.
         if item.fm-codigo < c-fm-codigo-ini or
            item.fm-codigo > c-fm-codigo-fim then next.
         if item.ge-codigo < i-ge-codigo-ini or
            item.ge-codigo > i-ge-codigo-fim then next.
         
         IF NOT AVAIL emitente OR i-emit-old <> af-item-contr-estab-form.cod-emitente THEN DO:
             for first emitente fields(cod-gr-forn nome-emit nome-abrev) 
                 where emitente.cod-emitente = af-item-contr-estab-form.cod-emitente no-lock: end.
             if not avail emitente then next.
             ASSIGN i-emit-old = af-item-contr-estab-form.cod-emitente.
         END.
         if emitente.cod-gr-forn < i-cod-gr-forn-ini or
            emitente.cod-gr-forn > i-cod-gr-forn-fim then next.

         FOR EACH tt-dt-periodo-aval: 

            IF param-af.log-usa-versao THEN DO:
                IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */
                    /* validar af-item-contr-estab */
                    FOR EACH tt-item-data NO-LOCK:
                        IF tt-dt-periodo-aval.dt-periodo-ini >= tt-item-data.data-ini AND
                           tt-dt-periodo-aval.dt-periodo-fim <= tt-item-data.data-fim THEN DO:
        
                            IF tt-item-data.nr-versao = af-item-contr-estab-form.nr-versao THEN DO:        
                                RUN pi-cria-nota-item-branco.     
                            END.
                        END.
                        ELSE
                            NEXT.
                    END.
                END.
                ELSE DO:   
                    FOR EACH tt-versao-data NO-LOCK:
                        IF tt-dt-periodo-aval.dt-periodo-ini >= tt-versao-data.data-ini AND
                           tt-dt-periodo-aval.dt-periodo-fim <= tt-versao-data.data-fim THEN DO:
            
                            IF tt-versao-data.nr-versao <> af-item-contr-estab-form.nr-versao THEN
                               NEXT.               
            
                            RUN pi-cria-nota-item-branco. 
                        END.
                        ELSE
                            NEXT.
                    END.
                END.
            END.
            /* N∆o usa controle de vers∆o */
            ELSE DO:
                RUN pi-cria-nota-item-branco. 
            END.
         END.
    END.
END.

RUN piRecalculaPercentualItem.

for each tt-notas where
         tt-notas.tipo = "DE"
   break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente
         by tt-notas.it-codigo
         by tt-notas.nr-controle:

   assign de-tot-item = de-tot-item + tt-notas.nota.

   if last-of(tt-notas.it-codigo) then do:
       create b-tt-notas.
       assign b-tt-notas.cod-estabel      = tt-notas.cod-estabel
              b-tt-notas.cod-emitente     = tt-notas.cod-emitente
              b-tt-notas.it-codigo        = tt-notas.it-codigo
              b-tt-notas.dt-indice        = tt-notas.dt-indice-fim
              b-tt-notas.des-periodo-aval = tt-notas.des-periodo-aval
              b-tt-notas.ano-avaliacao    = tt-notas.ano-avaliacao
              b-tt-notas.dt-indice-ini    = tt-notas.dt-indice-ini
              b-tt-notas.dt-indice-fim    = tt-notas.dt-indice-fim
              b-tt-notas.cod-grp-resp     = tt-notas.cod-grp-resp
              b-tt-notas.usuar-alter      = tt-notas.usuar-alter
              b-tt-notas.nota             = de-tot-item
              b-tt-notas.tipo             = "TI"   
              b-tt-notas.desc-item        = tt-notas.desc-item
              b-tt-notas.nome-abrev       = tt-notas.nome-abrev
              b-tt-notas.nome-emit        = tt-notas.nome-emit
              b-tt-notas.movimento        = tt-notas.movimento.
       assign de-tot-item = 0.


   end.
end.

assign de-tot-item   = 0
       de-nr-item    = 0
       de-tot-indice = 0
       de-tot-perc   = 0.
for each tt-notas where
         tt-notas.tipo = "DE"
   break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente
         by tt-notas.nr-controle:

   assign de-tot-item = de-tot-item + tt-notas.nota
          de-tot-indice = de-tot-indice + tt-notas.indice
          de-tot-perc = de-tot-perc + tt-notas.percentual
          de-nr-item = de-nr-item + 1.

    if last-of(tt-notas.dt-indice-fim) or
       last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) or
       last-of(tt-notas.nr-controle) then do:
       create b-tt-notas.
       assign b-tt-notas.cod-estabel  = tt-notas.cod-estabel
              b-tt-notas.cod-emitente = tt-notas.cod-emitente
              b-tt-notas.nr-controle  = tt-notas.nr-controle
              b-tt-notas.descricao    = tt-notas.descricao
              b-tt-notas.dt-indice    = tt-notas.dt-indice-fim
              b-tt-notas.des-periodo-aval = tt-notas.des-periodo-aval
              b-tt-notas.ano-avaliacao    = tt-notas.ano-avaliacao
              b-tt-notas.dt-indice-ini    = tt-notas.dt-indice-ini
              b-tt-notas.dt-indice-fim    = tt-notas.dt-indice-fim
              b-tt-notas.cod-grp-resp     = tt-notas.cod-grp-resp
              b-tt-notas.usuar-alter      = tt-notas.usuar-alter
              b-tt-notas.nota         = de-tot-item / de-nr-item
              b-tt-notas.indice       = de-tot-indice / de-nr-item
              b-tt-notas.percentual   = de-tot-perc 
              b-tt-notas.tipo         = "DF"   
              b-tt-notas.nome-abrev   = tt-notas.nome-abrev
              b-tt-notas.nome-emit    = tt-notas.nome-emit
              b-tt-notas.movimento    = tt-notas.movimento.
       IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
       IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
       IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.


       assign de-tot-item   = 0
              de-tot-indice = 0
              de-tot-perc   = 0
              de-nr-item    = 0.
    end.
end.

RUN piRecalculaPercentualFornecedor.

RUN piTotalizaFornecedor.

RUN piFiltro (INPUT p-filtro, INPUT p-melhor-pior).

find first tt-dt-periodo-aval no-error.
if avail tt-dt-periodo-aval then 
    assign da-data-ini = tt-dt-periodo-aval.dt-periodo-ini.

find last  tt-dt-periodo-aval no-error.
if avail tt-dt-periodo-aval then 
    assign da-data-fim = tt-dt-periodo-aval.dt-periodo-fim.

run piMedia (input p-media,
             input da-data-ini,
             input da-data-fim).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-nota-item-branco DBOProgram 
PROCEDURE pi-cria-nota-item-branco :
/*------------------------------------------------------------------------------
  Purpose: Cria na temp-table a nota para de itens genÇricos    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if not can-find(first tt-notas
                    where tt-notas.cod-estabel   = af-item-contr-estab-form.cod-estabel
                      and tt-notas.cod-emitente  = af-item-contr-estab-form.cod-emitente
                      and tt-notas.it-codigo     = af-item-contr-estab-form.it-codigo
                      and tt-notas.nr-controle   = af-item-contr-estab-form.nr-controle
                      and tt-notas.dt-indice-fim = tt-dt-periodo-aval.dt-periodo-fim) then do:

       /* Se n∆o houver nenhuma outra nota para o item n∆o deve considerar a nota em branco,
          pois neste caso o item n∆o foi movimentado no per°odo e desta forma n∆o pode influenciar
          na nota do fornecedor */
       if can-find(first tt-notas
                   where tt-notas.cod-estabel   = af-item-contr-estab-form.cod-estabel
                     and tt-notas.cod-emitente  = af-item-contr-estab-form.cod-emitente
                     and tt-notas.it-codigo     = af-item-contr-estab-form.it-codigo
                     and tt-notas.dt-indice-fim = tt-dt-periodo-aval.dt-periodo-fim) then do:


           /* Procura nota digitada para todos itens (item branco) */
           FOR EACH af-contr-indice 
              where af-contr-indice.ep-codigo    = i-ep-codigo-usuario
                and af-contr-indice.cod-estabel  = af-item-contr-estab-form.cod-estabel
                and af-contr-indice.cod-emitente = af-item-contr-estab-form.cod-emitente
                AND af-contr-indice.nr-versao    = af-item-contr-estab-form.nr-versao
                and af-contr-indice.it-codigo    = ""
                and af-contr-indice.nr-controle  = af-item-contr-estab-form.nr-controle
                and af-contr-indice.dt-indice    >= tt-dt-periodo-aval.dt-periodo-ini
                AND af-contr-indice.dt-indice    <= tt-dt-periodo-aval.dt-periodo-fim no-lock:
    
                create tt-notas.
                assign tt-notas.cod-estabel  = af-item-contr-estab-form.cod-estabel
                       tt-notas.cod-emitente = af-item-contr-estab-form.cod-emitente
                       tt-notas.it-codigo    = af-item-contr-estab-form.it-codigo
                       tt-notas.nr-controle  = af-item-contr-estab-form.nr-controle
                       tt-notas.dt-indice    = af-contr-indice.dt-indice
                       tt-notas.des-periodo-aval = tt-dt-periodo-aval.des-periodo-aval
                       tt-notas.cod-grp-resp  = af-item-contr-estab-form.cod-grp-resp
                       tt-notas.usuar-alter   = af-contr-indice.usuar-alter
                       tt-notas.ano-avaliacao = tt-dt-periodo-aval.ano-avaliacao
                       tt-notas.dt-indice-ini = tt-dt-periodo-aval.dt-periodo-ini
                       tt-notas.dt-indice-fim = tt-dt-periodo-aval.dt-periodo-fim
                       tt-notas.indice       = af-contr-indice.indice when avail af-contr-indice
                       tt-notas.percentual   = af-item-contr-estab-form.percentual
                       tt-notas.nota         = af-contr-indice.nota when avail af-contr-indice
                       tt-notas.tipo         = "DE"
                       tt-notas.desc-item    = item.desc-item
                       tt-notas.nome-abrev   = emitente.nome-abrev
                       tt-notas.nome-emit    = emitente.nome-emit
                       tt-notas.descricao    = af-controle.descricao when avail af-controle
                       tt-notas.narrativa    = af-contr-indice.narrativa when avail af-contr-indice
                       tt-notas.movimento    = af-contr-indice.movimento when avail af-contr-indice.
                IF tt-notas.nota = ? THEN ASSIGN tt-notas.nota = 0.
                IF tt-notas.indice = ? THEN ASSIGN tt-notas.indice = 0.
                IF tt-notas.percentual = ? THEN ASSIGN tt-notas.percentual = 0.
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPeriodo DBOProgram 
PROCEDURE getPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-periodo as char. 

assign p-periodo = string(month(da-dt-indice),"99") + string(year(da-dt-indice),"9999") no-error.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice ep-ind
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo nr-controle
               recebe valor do campo dt-indice
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE af-contr-indice.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE af-contr-indice.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE af-contr-indice.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pnr-controle LIKE af-contr-indice.nr-controle NO-UNDO.
    DEFINE INPUT PARAMETER pdt-indice LIKE af-contr-indice.dt-indice NO-UNDO.

    FIND FIRST bfaf-contr-indice 
         WHERE bfaf-contr-indice.ep-codigo    = i-ep-codigo-usuario 
           AND bfaf-contr-indice.nr-controle  = pnr-controle 
           AND bfaf-contr-indice.dt-indice    = pdt-indice 
           AND bfaf-contr-indice.it-codigo    = pit-codigo 
           AND bfaf-contr-indice.cod-emitente = pcod-emitente 
           AND bfaf-contr-indice.cod-estabel  = pcod-estabel NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-contr-indice THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-contr-indice)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryChave DBOProgram 
PROCEDURE openQueryChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo    = i-ep-codigo-usuario
                                 and {&TableName}.cod-estabel  >= c-cod-estabel-ini
                                 and {&TableName}.cod-estabel  <= c-cod-estabel-fim
                                 and {&TableName}.cod-emitente >= i-cod-emitente-ini
                                 and {&TableName}.cod-emitente <= i-cod-emitente-fim
                                 and {&tablename}.it-codigo    >= c-it-codigo-ini
                                 and {&tablename}.it-codigo    <= c-it-codigo-fim
                                 and {&TableName}.nr-controle  >= i-nr-controle-ini
                                 and {&TableName}.nr-controle  <= i-nr-controle-fim
                                 and {&TableName}.dt-indice    >= da-dt-indice-ini
                                 and {&TableName}.dt-indice    <= da-dt-indice-fim NO-LOCK
                            by  {&TableName}.ep-codigo
                            by  {&TableName}.cod-estabel
                            by  {&TableName}.dt-indice
                            by  {&TableName}.cod-emitente
                            by  {&tablename}.it-codigo
                            by  {&TableName}.nr-controle.
                            
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  
    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDatas DBOProgram 
PROCEDURE piAtualizaDatas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable da-prox-aval   as date format 99/99/9999 no-undo.

    find first af-item-contr-estab-form
        where af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario 
        and   af-item-contr-estab-form.cod-estabel  = rowObject.cod-estabel 
        and   af-item-contr-estab-form.cod-emitente = rowObject.cod-emitente 
        and   af-item-contr-estab-form.it-codigo    = rowObject.it-codigo 
        and   af-item-contr-estab-form.nr-controle  = rowObject.nr-controle
        AND   af-item-contr-estab-form.nr-versao    = rowObject.nr-versao exclusive-lock no-error.
    if  avail af-item-contr-estab-form 
    and af-item-contr-estab-form.log-per-variavel then do:

        if  af-item-contr-estab-form.dt-prox-aval <> ? then
            if af-item-contr-estab-form.dt-prox-aval <= today then
               assign af-item-contr-estab-form.dt-ult-aval = af-item-contr-estab-form.dt-prox-aval.
            else 
               assign af-item-contr-estab-form.dt-ult-aval = rowObject.dt-indice.
        else
            assign af-item-contr-estab-form.dt-ult-aval = rowObject.dt-indice.

        case af-item-contr-estab-form.ind-tipo-periodo:
            when 1 then  /* mensal */
                run piSetaDtProxAval (input af-item-contr-estab-form.dt-ult-aval,
                                      input 1,
                                      output da-prox-aval).
    
            when 2 then  /* bimestral */
                run piSetaDtProxAval (input af-item-contr-estab-form.dt-ult-aval,
                                      input 2,
                                      output da-prox-aval).
    
            when 3 then  /*trimestral */
                run piSetaDtProxAval (input af-item-contr-estab-form.dt-ult-aval,
                                      input 3,
                                      output da-prox-aval).
    
            when 4 then  /*semestral*/
                run piSetaDtProxAval (input af-item-contr-estab-form.dt-ult-aval,
                                      input 6,
                                      output da-prox-aval).

            when 5 then 
                run piSetaDtProxAval (input af-item-contr-estab-form.dt-ult-aval,
                                      input 12,
                                      output da-prox-aval).
        end case.

        assign af-item-contr-estab-form.dt-prox-aval = da-prox-aval.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaIndice DBOProgram 
PROCEDURE piCriaIndice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER i-nr-versao           LIKE af-item-contr-estab.nr-versao NO-UNDO.
    def var l-indice-ja-digitado as logical initial no  no-undo.
    def var da-dt-indice         as date                no-undo.
    def var c-usuario            as char                no-undo.
    def var de-percentual        as dec                 no-undo.
    def var de-indice            as dec                 no-undo.
    def var de-nota              as dec                 no-undo.
    def var de-tot-fornec        as integer             no-undo.
    DEF VAR l-fechado            AS LOGICAL             NO-UNDO.

    /*
    verificar se  af-item-contr-estab ≤ p/ o periodo DO memento
    tt-dt-periodo-aval contra tt criada na procedure
    */
    if  not avail estabelec
        or  estabelec.cod-estabel <> af-item-contr-estab-form.cod-estabel then
            for first estabelec fields (cod-estabel nome)
                where estabelec.cod-estabel = af-item-contr-estab-form.cod-estabel no-lock: end.

        if  not avail af-grp-avaliacao
        or (avail af-grp-avaliacao and  af-grp-avaliacao.cod-grp-avaliacao <> af-item-contr-estab.cod-grp-avaliacao) then
            for first af-grp-avaliacao fields (cod-grp-avaliacao des-grp-avaliacao)
                where af-grp-avaliacao.cod-grp-avaliacao = af-item-contr-estab.cod-grp-avaliacao no-lock: end.        

    find first af-grp-responsavel 
         where af-grp-responsavel.ep-codigo = i-ep-codigo-usuario 
           and af-grp-responsavel.cod-grp-resp = af-item-contr-estab-form.cod-grp-resp no-lock no-error.

    /* Verifica se a nota j† foi digitada, pois neste caso o registro 
       ser† criado com as informaá‰es j† cadastradas, e permitir† alteraá∆o */
    
    
    if not tt-filtro.indice-por-item then do:


        assign de-percentual = 0
               de-indice     = 0
               de-nota       = 0
               de-tot-fornec = 0.

        for each  af-contr-indice 
            where af-contr-indice.ep-codigo    = af-item-contr-estab-form.ep-codigo   
            and   af-contr-indice.cod-emitente = af-item-contr-estab-form.cod-emitente
            and   af-contr-indice.it-codigo    = af-item-contr-estab-form.it-codigo
            and   af-contr-indice.cod-estabel  = af-item-contr-estab-form.cod-estabel 
            and   af-contr-indice.nr-controle  = af-item-contr-estab-form.nr-controle 
            and   af-contr-indice.dt-indice   >= tt-dt-periodo-aval.dt-periodo-ini
            and   af-contr-indice.dt-indice   <= tt-dt-periodo-aval.dt-periodo-fim no-lock
            break by af-contr-indice.ep-codigo   
                  by af-contr-indice.cod-emitente
                  by af-contr-indice.cod-estabel 
                  by af-contr-indice.nr-controle 
                  by af-contr-indice.dt-indice:

             assign l-indice-ja-digitado = yes.
        
            if tt-filtro.indice-digitado-calculado then do:

                assign de-percentual  = de-percentual + af-contr-indice.percentual 
                       de-indice      = de-indice     + af-contr-indice.indice
                       de-nota        = de-nota       + af-contr-indice.nota
                       de-tot-fornec  = de-tot-fornec + 1.

                if last-of(af-contr-indice.ep-codigo)    or 
                   last-of(af-contr-indice.cod-emitente) or 
                   last-of(af-contr-indice.cod-estabel)  or
                   last-of(af-contr-indice.nr-controle)  or 
                   last-of(af-contr-indice.dt-indice)    then do:
                
                    find first tt-af-contr-indice-aux 
                         where tt-af-contr-indice-aux.ep-codigo    = af-contr-indice.ep-codigo    
                           and tt-af-contr-indice-aux.cod-emitente = af-contr-indice.cod-emitente 
                           and tt-af-contr-indice-aux.it-codigo    = ""                           
                           and tt-af-contr-indice-aux.cod-estabel  = af-contr-indice.cod-estabel  
                           and tt-af-contr-indice-aux.dt-indice    = af-contr-indice.dt-indice
                           and tt-af-contr-indice-aux.nr-controle  = af-contr-indice.nr-controle  no-error.

                    if not avail tt-af-contr-indice-aux then do:
                        create tt-af-contr-indice-aux.
                        buffer-copy af-contr-indice except it-codigo to tt-af-contr-indice-aux .
                        assign tt-af-contr-indice-aux.it-codigo = "".
                    end. 
            
                    assign tt-af-contr-indice-aux.nome-controle    = af-controle.descricao                 
                           tt-af-contr-indice-aux.nome-emit        = emitente.nome-emit
                           tt-af-contr-indice-aux.nome-estabel     = estabelec.nome                        
                           tt-af-contr-indice-aux.nr-versao        = i-nr-versao /*af-contr-indice.nr-versao*/
                           tt-af-contr-indice-aux.desc-item        = ""                   
                           tt-af-contr-indice-aux.cod-grp-aval     = af-item-contr-estab.cod-grp-avaliacao 
                           tt-af-contr-indice-aux.nome-grp-aval    = af-grp-avaliacao.des-grp-avaliacao when avail af-grp-avaliacao   
                           tt-af-contr-indice-aux.cod-grp-resp     = af-item-contr-estab-form.cod-grp-resp 
                           tt-af-contr-indice-aux.nome-grp-resp    = af-grp-responsavel.des-grp-resp when avail af-grp-responsavel
                           tt-af-contr-indice-aux.log-per-variavel = af-item-contr-estab-form.log-per-variavel
                           tt-af-contr-indice-aux.percentual       = af-item-contr-estab-form.percentual 
                           tt-af-contr-indice-aux.ind-tipo         = 1 /* alteracao */ 
                           tt-af-contr-indice-aux.r-rowid          = rowid(af-contr-indice)
                           tt-af-contr-indice-aux.percentual       = round(de-percentual / de-tot-fornec, 2)
                           tt-af-contr-indice-aux.nota             = round(de-indice / de-tot-fornec, 2)   
                           tt-af-contr-indice-aux.indice           = round(de-nota / de-tot-fornec, 2).
                end.
            end.
        end.
     end.
     else do:

        for each af-contr-indice 
           where af-contr-indice.ep-codigo    = af-item-contr-estab-form.ep-codigo   
            and  af-contr-indice.cod-emitente = af-item-contr-estab-form.cod-emitente
            and  af-contr-indice.it-codigo    = af-item-contr-estab-form.it-codigo
            and  af-contr-indice.cod-estabel  = af-item-contr-estab-form.cod-estabel 
            and  af-contr-indice.nr-controle  = af-item-contr-estab-form.nr-controle 
            and  af-contr-indice.dt-indice   >= tt-dt-periodo-aval.dt-periodo-ini
            and  af-contr-indice.dt-indice   <= tt-dt-periodo-aval.dt-periodo-fim no-lock:

            assign l-indice-ja-digitado = yes.
                
            if tt-filtro.indice-digitado-calculado then do:
                                                                         
                create tt-af-contr-indice-aux.
                buffer-copy af-contr-indice to tt-af-contr-indice-aux.
            
                assign tt-af-contr-indice-aux.nome-controle    = af-controle.descricao                 
                       tt-af-contr-indice-aux.nome-emit        = emitente.nome-emit
                       tt-af-contr-indice-aux.nome-estabel     = estabelec.nome                        
                       tt-af-contr-indice-aux.nr-versao        = i-nr-versao /*af-contr-indice.nr-versao*/
                       tt-af-contr-indice-aux.desc-item        = item.desc-item                        
                       tt-af-contr-indice-aux.cod-grp-aval     = af-item-contr-estab.cod-grp-avaliacao 
                       tt-af-contr-indice-aux.nome-grp-aval    = af-grp-avaliacao.des-grp-avaliacao when avail af-grp-avaliacao   
                       tt-af-contr-indice-aux.cod-grp-resp     = af-item-contr-estab-form.cod-grp-resp 
                       tt-af-contr-indice-aux.nome-grp-resp    = af-grp-responsavel.des-grp-resp when avail af-grp-responsavel
                       tt-af-contr-indice-aux.log-per-variavel = af-item-contr-estab-form.log-per-variavel
                       tt-af-contr-indice-aux.percentual       = af-item-contr-estab-form.percentual 
                       tt-af-contr-indice-aux.ind-tipo         = 1 /* alteracao */ 
                       tt-af-contr-indice-aux.it-codigo        = af-item-contr-estab-form.it-codigo
                       tt-af-contr-indice-aux.r-rowid          = rowid(af-contr-indice).
            end.
        end.
     end.
            
     if af-item-contr-estab-form.log-per-variavel then do:
        if af-item-contr-estab-form.dt-prox-aval = ? then 
            assign da-dt-indice = today.
        else
            assign da-dt-indice = af-item-contr-estab-form.dt-prox-aval.
        end. 
     else
        assign da-dt-indice = date(month(tt-dt-periodo-aval.dt-periodo-fim),01,year(tt-dt-periodo-aval.dt-periodo-fim)).

    /* Se ainda n∆o houve a digitaá∆o e est† parametrizado para 
       apresentar os °ndices n∆o digitados */
    if not l-indice-ja-digitado and 
       tt-filtro.indice-nao-digitado and
       af-item-contr-estab.ativo  then do:
           
        EMPTY TEMP-TABLE tt-dt-periodo-aval2.
        RUN validaPeriodoFechado IN h-boaf016 (INPUT da-dt-indice,
                                               INPUT TABLE tt-dt-periodo-aval2,
                                               OUTPUT l-fechado).
        IF l-fechado THEN DO:
            LEAVE.
        END.

        if  not can-find (first af-contr-indice 
                          where af-contr-indice.ep-codigo         = af-item-contr-estab-form.ep-codigo   
                          and   af-contr-indice.cod-emitente      = af-item-contr-estab-form.cod-emitente
                          and   af-contr-indice.it-codigo         = af-item-contr-estab-form.it-codigo   
                          and   af-contr-indice.cod-estabel       = af-item-contr-estab-form.cod-estabel 
                          and   af-contr-indice.nr-controle       = af-item-contr-estab-form.nr-controle 
                          and   af-contr-indice.dt-indice         >= tt-dt-periodo-aval.dt-periodo-ini
                          and   af-contr-indice.dt-indice         <= tt-dt-periodo-aval.dt-periodo-fim) then do:

            find first tt-af-contr-indice-aux 
                 where tt-af-contr-indice-aux.ep-codigo    = af-item-contr-estab-form.ep-codigo
                   and tt-af-contr-indice-aux.nr-controle  = af-item-contr-estab-form.nr-controle
                   and tt-af-contr-indice-aux.dt-indice    = da-dt-indice
                   and tt-af-contr-indice-aux.it-codigo    = af-item-contr-estab-form.it-codigo
                   and tt-af-contr-indice-aux.cod-emitente = af-item-contr-estab-form.cod-emitente      
                   and tt-af-contr-indice-aux.cod-estabel  = af-item-contr-estab-form.cod-estabel no-error.
            if not avail tt-af-contr-indice-aux then do:
                create tt-af-contr-indice-aux.
                assign tt-af-contr-indice-aux.ep-codigo        = af-item-contr-estab-form.ep-codigo
                       tt-af-contr-indice-aux.cod-emitente     = af-item-contr-estab-form.cod-emitente
                       tt-af-contr-indice-aux.nome-emit        = emitente.nome-emit
                       tt-af-contr-indice-aux.nr-versao        = i-nr-versao /*af-item-contr-estab-form.nr-versao*/
                       tt-af-contr-indice-aux.it-codigo        = af-item-contr-estab-form.it-codigo
                       tt-af-contr-indice-aux.desc-item        = item.desc-item
                       tt-af-contr-indice-aux.cod-estabel      = af-item-contr-estab-form.cod-estabel
                       tt-af-contr-indice-aux.nome-estabel     = estabelec.nome
                       tt-af-contr-indice-aux.nr-controle      = af-item-contr-estab-form.nr-controle
                       tt-af-contr-indice-aux.nome-controle    = af-controle.descricao                 
                       tt-af-contr-indice-aux.cod-grp-aval     = af-item-contr-estab.cod-grp-avaliacao
                       tt-af-contr-indice-aux.nome-grp-aval    = af-grp-avaliacao.des-grp-avaliacao when avail af-grp-avaliacao
                       tt-af-contr-indice-aux.cod-grp-resp     = af-item-contr-estab-form.cod-grp-resp 
                       tt-af-contr-indice-aux.nome-grp-resp    = af-grp-responsavel.des-grp-resp when avail af-grp-responsavel
                       tt-af-contr-indice-aux.log-per-variavel = af-item-contr-estab-form.log-per-variavel
                       tt-af-contr-indice-aux.ind-tipo         = 2 /* inclusao */ 
                       tt-af-contr-indice-aux.r-rowid          = ?
                       tt-af-contr-indice-aux.dt-indice        = da-dt-indice
                       tt-af-contr-indice-aux.percentual       = af-item-contr-estab-form.percentual .
            END.               
        end.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTTnotas DBOProgram 
PROCEDURE piCriaTTnotas :
/*------------------------------------------------------------------------------
  Purpose: Criar temp-table de notas conforme pontos de controle e grupo responsˇvel    
  Parameters: i-nr-controle-ini: Número do ponto de controle inicial
              i-nr-controle-fim: Número do ponto de controle final
              c-cod-grp-resp-ini: CΩdigo do grupo responsˇvel inicial
              c-cod-grp-resp-fim: CΩdigo do grupo responsˇvel final
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM i-nr-controle-ini  LIKE af-contr-indice.nr-controle           NO-UNDO.
    DEF INPUT PARAM i-nr-controle-fim  LIKE af-contr-indice.nr-controle           NO-UNDO.
    DEF INPUT PARAM c-cod-grp-resp-ini LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
    DEF INPUT PARAM c-cod-grp-resp-fim LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO.
    
  


  IF af-item-contr-estab.it-codigo <> "" THEN DO:
    for each af-contr-indice USE-INDEX ep-forn-dt                                                           
       where af-contr-indice.ep-codigo    = i-ep-codigo-usuario 
         and af-contr-indice.cod-emitente = af-item-contr-estab.cod-emitente
         AND af-contr-indice.nr-versao    = af-item-contr-estab.nr-versao
         and af-contr-indice.it-codigo    = af-item-contr-estab.it-codigo
         and af-contr-indice.cod-estabel  = af-item-contr-estab.cod-estabel
         and af-contr-indice.dt-indice    >= tt-dt-periodo-aval.dt-periodo-ini
         and af-contr-indice.dt-indice    <= tt-dt-periodo-aval.dt-periodo-fim
         and af-contr-indice.nr-controle  >= i-nr-controle-ini
         and af-contr-indice.nr-controle  <= i-nr-controle-fim no-lock:

         for first af-item-contr-estab-form fields(percentual cod-grp-resp)
             where af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario 
               and af-item-contr-estab-form.cod-estabel  = af-contr-indice.cod-estabel 
               and af-item-contr-estab-form.cod-emitente = af-contr-indice.cod-emitente
               AND af-item-contr-estab-form.nr-versao    = af-contr-indice.nr-versao
               and af-item-contr-estab-form.it-codigo    = af-contr-indice.it-codigo 
               and af-item-contr-estab-form.nr-controle  = af-contr-indice.nr-controle 
               AND af-item-contr-estab-form.cod-grp-resp >= c-cod-grp-resp-ini 
               AND af-item-contr-estab-form.cod-grp-resp <= c-cod-grp-resp-fim no-lock: end.
         if not avail af-item-contr-estab-form then next.
    
         for first af-controle 
             where af-controle.ep-codigo   = i-ep-codigo-usuario 
               and af-controle.nr-controle = af-contr-indice.nr-controle no-lock: end.
    
         create tt-notas.
         assign tt-notas.cod-estabel   = af-contr-indice.cod-estabel
                tt-notas.cod-emitente  = af-contr-indice.cod-emitente
                tt-notas.it-codigo     = af-contr-indice.it-codigo
                tt-notas.nr-controle   = af-contr-indice.nr-controle
                tt-notas.des-periodo-aval = tt-dt-periodo-aval.des-periodo-aval
                tt-notas.cod-grp-resp  = af-item-contr-estab-form.cod-grp-resp
                tt-notas.ano-avaliacao = tt-dt-periodo-aval.ano-avaliacao
                tt-notas.dt-indice-ini = tt-dt-periodo-aval.dt-periodo-ini
                tt-notas.dt-indice-fim = tt-dt-periodo-aval.dt-periodo-fim
                tt-notas.dt-indice     = af-contr-indice.dt-indice
                tt-notas.indice        = af-contr-indice.indice
                tt-notas.nota          = af-contr-indice.nota
                tt-notas.usuar-alter   = af-contr-indice.usuar-alter
                tt-notas.tipo          = "DE"
                tt-notas.desc-item     = item.desc-item
                tt-notas.nome-abrev    = emitente.nome-abrev
                tt-notas.nome-emit     = emitente.nome-emit
                tt-notas.descricao     = af-controle.descricao
                tt-notas.narrativa     = af-contr-indice.narrativa
                tt-notas.percentual    = af-item-contr-estab-form.percentual
                tt-notas.movimento     = af-contr-indice.movimento.
    
         IF tt-notas.nota = ? THEN ASSIGN tt-notas.nota = 0.
         IF tt-notas.indice = ? THEN ASSIGN tt-notas.indice = 0.
         IF tt-notas.percentual = ? THEN ASSIGN tt-notas.percentual = 0.
     END.
   
  END.
   
  ELSE DO:

     for each af-contr-indice USE-INDEX ep-forn-dt                                                           
       where af-contr-indice.ep-codigo    = i-ep-codigo-usuario 
         and af-contr-indice.cod-emitente = af-item-contr-estab.cod-emitente
         AND af-contr-indice.nr-versao    = af-item-contr-estab.nr-versao
         and af-contr-indice.it-codigo    = ""
         and af-contr-indice.cod-estabel  = af-item-contr-estab.cod-estabel
         and af-contr-indice.dt-indice    >= tt-dt-periodo-aval.dt-periodo-ini
         and af-contr-indice.dt-indice    <= tt-dt-periodo-aval.dt-periodo-fim
         and af-contr-indice.nr-controle  >= i-nr-controle-ini
         and af-contr-indice.nr-controle  <= i-nr-controle-fim no-lock:

         for first af-item-contr-estab-form fields(percentual cod-grp-resp)
             where af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario 
               and af-item-contr-estab-form.cod-estabel  = af-contr-indice.cod-estabel 
               and af-item-contr-estab-form.cod-emitente = af-contr-indice.cod-emitente
               AND af-item-contr-estab-form.nr-versao    = af-contr-indice.nr-versao
               /*and af-item-contr-estab-form.it-codigo    = af-contr-indice.it-codigo*/
               and af-item-contr-estab-form.nr-controle  = af-contr-indice.nr-controle 
               AND af-item-contr-estab-form.cod-grp-resp >= c-cod-grp-resp-ini 
               AND af-item-contr-estab-form.cod-grp-resp <= c-cod-grp-resp-fim no-lock: end.
         if not avail af-item-contr-estab-form then next.
    
         for first af-controle 
             where af-controle.ep-codigo   = i-ep-codigo-usuario 
               and af-controle.nr-controle = af-contr-indice.nr-controle no-lock: end.

         create tt-notas.
         assign tt-notas.cod-estabel   = af-contr-indice.cod-estabel
                tt-notas.cod-emitente  = af-contr-indice.cod-emitente
                tt-notas.it-codigo     = ""
                tt-notas.nr-controle   = af-contr-indice.nr-controle
                tt-notas.des-periodo-aval = tt-dt-periodo-aval.des-periodo-aval
                tt-notas.cod-grp-resp  = af-item-contr-estab-form.cod-grp-resp
                tt-notas.ano-avaliacao = tt-dt-periodo-aval.ano-avaliacao
                tt-notas.dt-indice-ini = tt-dt-periodo-aval.dt-periodo-ini
                tt-notas.dt-indice-fim = tt-dt-periodo-aval.dt-periodo-fim
                tt-notas.dt-indice     = af-contr-indice.dt-indice
                tt-notas.indice        = af-contr-indice.indice
                tt-notas.nota          = af-contr-indice.nota
                tt-notas.usuar-alter   = af-contr-indice.usuar-alter
                tt-notas.tipo          = "DE"
                tt-notas.desc-item     = item.desc-item
                tt-notas.nome-abrev    = emitente.nome-abrev
                tt-notas.nome-emit     = emitente.nome-emit
                tt-notas.descricao     = af-controle.descricao
                tt-notas.narrativa     = af-contr-indice.narrativa
                tt-notas.percentual    = af-item-contr-estab-form.percentual
                tt-notas.movimento     = af-contr-indice.movimento.
    
         IF tt-notas.nota = ? THEN ASSIGN tt-notas.nota = 0.
         IF tt-notas.indice = ? THEN ASSIGN tt-notas.indice = 0.
         IF tt-notas.percentual = ? THEN ASSIGN tt-notas.percentual = 0.
     END.
  END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltraQuebraIndice DBOProgram 
PROCEDURE piFiltraQuebraIndice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 /* Quando o item for branoc o apontamento sera valido para todos os 
       itens do periodo. */
    if  not tt-filtro.indice-por-item then do:

        for each  tt-af-contr-indice-aux
            where not tt-af-contr-indice-aux.log-per-variavel
            break by tt-af-contr-indice-aux.ep-codigo    
                  by tt-af-contr-indice-aux.nr-controle  
                  by tt-af-contr-indice-aux.cod-emitente 
                  by tt-af-contr-indice-aux.cod-estabel
                  by substr(string(tt-af-contr-indice-aux.dt-indice),4,7): 

            if  last-of (tt-af-contr-indice-aux.ep-codigo)
            or  last-of (tt-af-contr-indice-aux.nr-controle)
            or  last-of (substr(string(tt-af-contr-indice-aux.dt-indice),4,7))
            or  last-of (tt-af-contr-indice-aux.cod-emitente)
            or  last-of (tt-af-contr-indice-aux.cod-estabel) then do:

                assign tt-af-contr-indice-aux.it-codigo = ""
                       tt-af-contr-indice-aux.ind-tipo  = 2.

                  FOR EACH bf2-af-contr-indice NO-LOCK
                     WHERE bf2-af-contr-indice.ep-codigo    = tt-af-contr-indice-aux.ep-codigo
                       AND bf2-af-contr-indice.cod-emitente = tt-af-contr-indice-aux.cod-emitente 
                       AND bf2-af-contr-indice.it-codigo    = ""
                       AND bf2-af-contr-indice.cod-estabel  = tt-af-contr-indice-aux.cod-estabel
                       AND bf2-af-contr-indice.nr-controle  = tt-af-contr-indice-aux.nr-controle :

                      IF trim(SUBSTRING(STRING(bf2-af-contr-indice.dt-indice),4,7)) = trim(SUBSTRING(STRING(tt-af-contr-indice-aux.dt-indice),4,7)) THEN DO:

                        IF  tt-filtro.indice-nao-digitado       = YES
                        AND tt-filtro.indice-digitado-calculado = NO THEN DO:
    
                            DELETE tt-af-contr-indice-aux.
                        END.
                        ELSE DO:
                            ASSIGN tt-af-contr-indice-aux.ind-tipo   = 1
                                   tt-af-contr-indice-aux.percentual = bf2-af-contr-indice.percentual
                                   tt-af-contr-indice-aux.nota       = bf2-af-contr-indice.nota      
                                   tt-af-contr-indice-aux.indice     = bf2-af-contr-indice.indice.
                        END.                                          
                      END.
                  END.
            END.
            else
                delete tt-af-contr-indice-aux.
        end.
    end.
    ELSE DO:
        /**ALTERACAO - Quando o item for branco o apontamento sera valido para todos os itens do periodo. */
        FOR EACH tt-af-contr-indice-aux
           WHERE tt-af-contr-indice-aux.it-codigo <> "" :

             FOR EACH af-contr-indice NO-LOCK 
                WHERE af-contr-indice.ep-codigo    = tt-af-contr-indice-aux.ep-codigo
                  AND af-contr-indice.cod-emitente = tt-af-contr-indice-aux.cod-emitente                           
                  AND af-contr-indice.it-codigo    = ""                                                            
                  AND af-contr-indice.cod-estabel  = tt-af-contr-indice-aux.cod-estabel
                  AND af-contr-indice.nr-controle  = tt-af-contr-indice-aux.nr-controle :

                 IF TRIM(SUBSTRING(STRING(af-contr-indice.dt-indice),4,7)) = TRIM(SUBSTRING(STRING(tt-af-contr-indice-aux.dt-indice),4,7)) THEN 
                     DELETE tt-af-contr-indice-aux.
             END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFiltro DBOProgram 
PROCEDURE piFiltro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-filtro           as   int                              no-undo.
def input param p-melhor-pior      as   int                              no-undo.

DEF VAR i-count            AS INT    NO-UNDO.
DEF VAR de-ultima-nota     AS DEC    NO-UNDO.
DEF VAR de-ultima-nota-aux AS DEC    NO-UNDO.
def buffer b-tt-notas for tt-notas.

/**************************************************************
   Elimina os melhores ou piores fornecedores, conforme parametrizaá∆o 
   A vari†vel de-ultima-nota controla notas iguais, exemplo:
   Forn 1: 100
   Forn 2:  80
   Forn 3:  80
   Forn 4:  70
   Selecionando os dois melhores vai listar do 1 a 3, 
   visto que 2 e 3 tem notas iguais 
****************************************************************/
if p-filtro <> 1 then do:
   if p-filtro = 2 then do:
         FOR EACH tt-notas where
                  tt-notas.tipo = "TF"
            break by tt-notas.cod-estabel
                  by tt-notas.dt-indice
                  by tt-notas.nota desc:
            if first-of(tt-notas.cod-estabel) or
               first-of(tt-notas.dt-indice) then
               assign i-count = 0
                      de-ultima-nota = 0.
                      
            assign i-count = i-count + 1.
                   
            if i-count > p-melhor-pior and 
               tt-notas.nota <> de-ultima-nota then do:
               for each b-tt-notas
                  where b-tt-notas.tipo <> "TF"
                    and b-tt-notas.cod-estabel = tt-notas.cod-estabel
                    and b-tt-notas.dt-indice = tt-notas.dt-indice
                    and b-tt-notas.cod-emitente = tt-notas.cod-emitente:
                  delete b-tt-notas.
               end.
            end.
            else 
               assign de-ultima-nota-aux =  tt-notas.nota.
               
            if i-count > p-melhor-pior and 
               tt-notas.nota <> de-ultima-nota then
               delete tt-notas.
            assign de-ultima-nota = de-ultima-nota-aux.
         end.
   end.
   else if p-filtro = 3 then do:
         escopo:
         FOR EACH tt-notas where
                  tt-notas.tipo = "TF"
            break by tt-notas.cod-estabel
                  by tt-notas.dt-indice
                  by tt-notas.nota:
            if first-of(tt-notas.cod-estabel) or
               first-of(tt-notas.dt-indice) then
               assign i-count = 0
                      de-ultima-nota = 0.
                      
            assign i-count = i-count + 1.
                   
            if i-count > p-melhor-pior and 
               tt-notas.nota <> de-ultima-nota then do:
               for each b-tt-notas
                  where b-tt-notas.tipo <> "TF"
                    and b-tt-notas.cod-estabel = tt-notas.cod-estabel
                    and b-tt-notas.dt-indice = tt-notas.dt-indice
                    and b-tt-notas.cod-emitente = tt-notas.cod-emitente:
                  delete b-tt-notas.
               end.
            end.
            else 
               assign de-ultima-nota-aux =  tt-notas.nota.
            if i-count > p-melhor-pior and 
               tt-notas.nota <> de-ultima-nota then
               delete tt-notas.
            assign de-ultima-nota = de-ultima-nota-aux.
         end.
   end.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMedia DBOProgram 
PROCEDURE piMedia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-media  as int no-undo.
def input param p-dt-ini as date no-undo.
def input param p-dt-fim as date no-undo.

if p-media < 2 then return.

DEF VAR de-tot-for AS DEC NO-UNDO.
def var i-tot-for  as int no-undo.
def var de-tot-ind  as dec no-undo.

DEF BUFFER b-tt-notas FOR tt-notas.

assign de-tot-for = 0.
for each tt-notas where
         tt-notas.tipo = "TF"
   break by tt-notas.cod-estabel
         by tt-notas.cod-emitente:

   assign de-tot-for = de-tot-for + tt-notas.nota
          i-tot-for  = i-tot-for + 1.

    if last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) then do:
       create b-tt-notas.
       assign b-tt-notas.cod-estabel  = tt-notas.cod-estabel
              b-tt-notas.cod-emitente = tt-notas.cod-emitente
              b-tt-notas.dt-indice    = tt-notas.dt-indice-fim
              b-tt-notas.des-periodo-aval = " -*- MÇdia -*-"
              b-tt-notas.ano-avaliacao    = tt-notas.ano-avaliacao
              b-tt-notas.dt-indice-ini    = date(month(p-dt-ini),25,year(p-dt-ini)) /* Diferencia da chave dos registros padr‰es TF*/
              b-tt-notas.dt-indice-fim    = p-dt-fim
              b-tt-notas.nota         = round(de-tot-for / i-tot-for,2)
              b-tt-notas.tipo         = "TF"
              b-tt-notas.nome-abrev   = tt-notas.nome-abrev
              b-tt-notas.nome-emit    = tt-notas.nome-emit.
       IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
       IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
       IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.
       assign de-tot-for = 0
              i-tot-for  = 0.
    end.
end.


assign de-tot-for = 0
       i-tot-for  = 0.

for each tt-notas where
         tt-notas.tipo = "DF"
   break by tt-notas.cod-estabel
         by tt-notas.cod-emitente
         by tt-notas.nr-controle:

   assign de-tot-for = de-tot-for + tt-notas.nota
          de-tot-ind = de-tot-ind + tt-notas.indice
          i-tot-for  = i-tot-for + 1.

    if last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) or
       last-of(tt-notas.nr-controle) then do:
       create b-tt-notas.
       assign b-tt-notas.cod-estabel  = tt-notas.cod-estabel
              b-tt-notas.cod-emitente = tt-notas.cod-emitente
              b-tt-notas.dt-indice    = tt-notas.dt-indice-fim
              b-tt-notas.nr-controle  = tt-notas.nr-controle
              b-tt-notas.descricao    = tt-notas.descricao
              b-tt-notas.des-periodo-aval = " -*- MÇdia -*-"
              b-tt-notas.ano-avaliacao    = tt-notas.ano-avaliacao
              b-tt-notas.dt-indice-ini    = date(month(p-dt-ini),25,year(p-dt-ini)) /* Diferencia da chave dos registros padr‰es TF*/
              b-tt-notas.dt-indice-fim    = p-dt-fim
              b-tt-notas.nota         = round(de-tot-for / i-tot-for,2)
              b-tt-notas.percentual   = tt-notas.percentual
              b-tt-notas.indice       = round(de-tot-ind / i-tot-for,2)
              b-tt-notas.tipo         = "DF"
              b-tt-notas.nome-abrev   = tt-notas.nome-abrev
              b-tt-notas.nome-emit    = tt-notas.nome-emit.

       IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
       IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
       IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.
       assign de-tot-for = 0
              i-tot-for  = 0
              de-tot-ind = 0.
    end.
end.

if p-media = 3 then do:
    for each tt-notas
       where tt-notas.des-periodo-aval <> " -*- MÇdia -*-":
        delete tt-notas.
    end.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecalculaPercentualFornecedor DBOProgram 
PROCEDURE piRecalculaPercentualFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR de-tot-perc AS DEC NO-UNDO.

DEFINE VARIABLE de-soma-perc-pc AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-soma-nota-pc AS DECIMAL     NO-UNDO.

def buffer b-tt-notas for tt-notas.

FOR EACH tt-notas 
    WHERE tt-notas.tipo = "DF"
       break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente:

    ASSIGN de-tot-perc = de-tot-perc + tt-notas.percentual
           de-soma-perc-pc = 0
           de-soma-nota-pc = 0.

    if last-of(tt-notas.dt-indice-fim) or
       last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) then do:
    
       FOR EACH b-tt-notas
           WHERE b-tt-notas.tipo          = tt-notas.tipo
           AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim
           AND   b-tt-notas.cod-estabel   = tt-notas.cod-estabel
           AND   b-tt-notas.cod-emitente  = tt-notas.cod-emitente:

           ASSIGN b-tt-notas.percentual   = ROUND(((b-tt-notas.percentual * 100) / de-tot-perc), 2)
                  b-tt-notas.nota         = round(b-tt-notas.indice * b-tt-notas.percentual / 100,2)
                  de-soma-perc-pc         = ROUND(de-soma-perc-pc + b-tt-notas.percentual, 2)
                  de-soma-nota-pc         = ROUND(de-soma-nota-pc + b-tt-notas.nota, 2).

           IF de-soma-perc-pc > 100 THEN DO:
               ASSIGN b-tt-notas.percentual = b-tt-notas.percentual - (de-soma-perc-pc - 100). 
           END.

           IF de-soma-nota-pc > 100 THEN DO:
               ASSIGN b-tt-notas.nota = b-tt-notas.nota - (de-soma-nota-pc - 100). 
           END.
           IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
           IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
           IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.
       END.
       ASSIGN de-tot-perc = 0.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecalculaPercentualItem DBOProgram 
PROCEDURE piRecalculaPercentualItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR de-tot-perc   AS DEC NO-UNDO.
DEF BUFFER b-tt-notas FOR tt-notas.
DEF VAR i-cont        AS INT NO-UNDO.
DEF VAR de-indice     AS DEC NO-UNDO.
DEF VAR c-narrativa   LIKE tt-notas.narrativa NO-UNDO.

DEFINE VARIABLE de-soma-perc-pc AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-soma-nota-pc AS DECIMAL     NO-UNDO.

FOR EACH tt-notas 
    WHERE tt-notas.tipo = "DE"
       break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente
         BY tt-notas.it-codigo
         BY tt-notas.nr-controle
         BY tt-notas.dt-indice:
    ASSIGN i-cont    = i-cont + 1
           de-indice = de-indice + tt-notas.indice.
    if last-of(tt-notas.dt-indice-fim) or
       last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) OR 
       last-of(tt-notas.it-codigo) OR 
       LAST-OF(tt-notas.nr-controle) then do:
       IF i-cont > 1 THEN DO:
           ASSIGN tt-notas.indice = de-indice / i-cont
                  tt-notas.nota   = round(tt-notas.indice * tt-notas.percentual / 100,2).
           FOR EACH b-tt-notas
               WHERE b-tt-notas.tipo          = tt-notas.tipo
               AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim
               AND   b-tt-notas.cod-estabel   = tt-notas.cod-estabel
               AND   b-tt-notas.cod-emitente  = tt-notas.cod-emitente 
               AND   b-tt-notas.it-codigo     = tt-notas.it-codigo
               AND   b-tt-notas.nr-controle   = tt-notas.nr-controle
               AND   b-tt-notas.dt-indice    <> tt-notas.dt-indice
               BY b-tt-notas.dt-indice:
               
               ASSIGN c-narrativa = "Per°odo: " + string(b-tt-notas.dt-indice) + "~r~n" +
                                     b-tt-notas.narrativa + "~r~n" + c-narrativa  + "~r~n".
    
               DELETE b-tt-notas.
    
           END.
           ASSIGN tt-notas.narrativa = c-narrativa + "Per°odo: " + string(tt-notas.dt-indice) + "~r~n" + tt-notas.narrativa
                  c-narrativa = "".
       END.
       ASSIGN de-indice = 0
              i-cont    = 0.
    END.
END.

ASSIGN de-tot-perc = 0.

FOR EACH tt-notas 
    WHERE tt-notas.tipo = "DE"
       break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente
         BY tt-notas.it-codigo:

    ASSIGN de-tot-perc = de-tot-perc + tt-notas.percentual
           de-soma-perc-pc = 0
           de-soma-nota-pc = 0.

    if last-of(tt-notas.dt-indice-fim) or
       last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) OR 
       last-of(tt-notas.it-codigo) then do:
       FOR EACH b-tt-notas
           WHERE b-tt-notas.tipo          = tt-notas.tipo
           AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim
           AND   b-tt-notas.cod-estabel   = tt-notas.cod-estabel
           AND   b-tt-notas.cod-emitente  = tt-notas.cod-emitente 
           AND   b-tt-notas.it-codigo     = tt-notas.it-codigo:

           ASSIGN b-tt-notas.percentual = ROUND(((b-tt-notas.percentual * 100) / de-tot-perc), 2)
                  b-tt-notas.nota       = round(b-tt-notas.indice * b-tt-notas.percentual / 100,2)
                  de-soma-perc-pc       = ROUND(de-soma-perc-pc + b-tt-notas.percentual, 2)
                  de-soma-nota-pc       = ROUND(de-soma-nota-pc + b-tt-notas.nota, 2).

           IF de-soma-perc-pc > 100 THEN DO:
               ASSIGN b-tt-notas.percentual = b-tt-notas.percentual - (de-soma-perc-pc - 100). 
           END.

           IF de-soma-nota-pc > 100 THEN DO:
               ASSIGN b-tt-notas.nota = b-tt-notas.nota - (de-soma-nota-pc - 100). 
           END.

           IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
           IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
           IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.
       END.
       ASSIGN de-tot-perc = 0.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaGrupoAvaliacao DBOProgram 
PROCEDURE piRetornaGrupoAvaliacao :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos cod-grp-resp e nr-versao 
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-emitente
               recebe valor do campo nr-versao
               recebe valor do campo it-codigo
               retorna valor do campo cod-grp-resp
               retorna valor do vampo nr-versao (do grupo de avaliacao)
  Notes:          
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel    LIKE af-contr-indice.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente   LIKE af-contr-indice.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnr-versao      LIKE af-contr-indice.nr-versao    NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo      LIKE af-contr-indice.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pgrupo-avaliac LIKE af-grp-avaliacao-form.cod-grp-resp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-versao-grp-avaliac LIKE af-grp-avaliacao-form.nr-versao NO-UNDO.

    FIND FIRST af-item-contr-estab WHERE 
          af-item-contr-estab.ep-codigo    = i-ep-codigo-usuario AND
          af-item-contr-estab.cod-estabel  = pcod-estabel AND
          af-item-contr-estab.cod-emitente = pcod-emitente AND
          af-item-contr-estab.nr-versao    = pnr-versao AND
          af-item-contr-estab.it-codigo    = pit-codigo NO-LOCK NO-ERROR.
    IF AVAIL af-item-contr-estab THEN DO:
       FIND FIRST af-grp-avaliacao NO-LOCK
            WHERE af-grp-avaliacao.ep-codigo = i-ep-codigo-usuario
            AND   af-grp-avaliacao.cod-grp-avaliacao = af-item-contr-estab.cod-grp-avaliacao
            AND   af-grp-avaliacao.nr-versao         = af-item-contr-estab.nr-versao-grp-avaliacao NO-ERROR.
       ASSIGN pgrupo-avaliac         = af-item-contr-estab.cod-grp-avaliacao
              pnr-versao-grp-avaliac = af-grp-avaliacao.nr-versao WHEN AVAIL af-grp-avaliacao.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaGrupoResponsavel DBOProgram 
PROCEDURE piRetornaGrupoResponsavel :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-ind
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo cod-estabel
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-estabel  LIKE af-contr-indice.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente LIKE af-contr-indice.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo    LIKE af-contr-indice.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-controle  LIKE af-contr-indice.nr-controle  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-grp-resp LIKE af-item-contr-estab-form.cod-grp-resp NO-UNDO. 

    FIND FIRST af-item-contr-estab-form WHERE 
          af-item-contr-estab-form.ep-codigo    = i-ep-codigo-usuario AND
          af-item-contr-estab-form.cod-estabel  = pcod-estabel AND
          af-item-contr-estab-form.cod-emitente = pcod-emitente  AND
          af-item-contr-estab-form.it-codigo    = pit-codigo    AND
          af-item-contr-estab-form.nr-controle  = pnr-controle NO-LOCK NO-ERROR.
    IF AVAIL af-item-contr-estab-form THEN
       ASSIGN pcod-grp-resp = af-item-contr-estab-form.cod-grp-resp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaNarrativa DBOProgram 
PROCEDURE piRetornaNarrativa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piEpcodigo    LIKE af-item-contr-estab.ep-codigo NO-UNDO.
DEFINE INPUT  PARAMETER pcItcodigo    LIKE af-item-contr-estab.it-codigo NO-UNDO.
DEFINE INPUT  PARAMETER piCodemitente LIKE af-item-contr-estab.cod-emitente NO-UNDO.
DEFINE INPUT  PARAMETER pcCodestabel  LIKE af-item-contr-estab.cod-estabel NO-UNDO.
DEFINE INPUT  PARAMETER piNrcontrole  LIKE af-controle.nr-controle NO-UNDO.
DEFINE OUTPUT PARAMETER pcNarrativa1  LIKE af-controle.narrativa NO-UNDO.             
DEFINE OUTPUT PARAMETER pcNarrativa2  LIKE af-item-contr-estab.narrativa NO-UNDO.     
DEFINE OUTPUT PARAMETER pcNarrativa3  LIKE af-item-contr-estab-form.narrativa NO-UNDO.
DEFINE OUTPUT PARAMETER pcNarrativa4  LIKE ITEM.narrativa NO-UNDO.    

    FIND FIRST af-controle WHERE
         af-controle.nr-controle = piNrcontrole NO-LOCK NO-ERROR.
    IF AVAIL af-controle THEN
        ASSIGN pcNarrativa1 = af-controle.narrativa.
    ELSE
        ASSIGN pcNarrativa1 = "".

    FIND FIRST af-item-contr-estab WHERE
         af-item-contr-estab.ep-codigo    = piEpcodigo AND
         af-item-contr-estab.it-codigo    = pcItcodigo AND
         af-item-contr-estab.cod-emitente = piCodemitente AND
         af-item-contr-estab.cod-estabel  = pcCodestabel NO-LOCK NO-ERROR.
    IF AVAIL af-item-contr-estab THEN DO:
        ASSIGN pcNarrativa2 = af-item-contr-estab.narrativa.
        FIND FIRST af-item-contr-estab-form WHERE
             af-item-contr-estab-form.ep-codigo    = af-item-contr-estab.ep-codigo AND  
             af-item-contr-estab-form.it-codigo    = af-item-contr-estab.it-codigo AND  
             af-item-contr-estab-form.cod-emitente = af-item-contr-estab.cod-emitente AND
             af-item-contr-estab-form.cod-estabel  = af-item-contr-estab.cod-estabel AND
             af-item-contr-estab-form.nr-controle  = piNrcontrole NO-LOCK NO-ERROR.
        IF AVAIL af-item-contr-estab-form THEN
            ASSIGN pcNarrativa3 = af-item-contr-estab-form.narrativa.
        ELSE
            ASSIGN pcNarrativa3 = "".
    END.
    ELSE
        ASSIGN pcNarrativa3 = "".

    FIND ITEM WHERE 
         ITEM.it-codigo = pcItcodigo NO-LOCK NO-ERROR.
    IF AVAIL ITEM THEN
        ASSIGN pcNarrativa4 = ITEM.narrativa.
    ELSE
        ASSIGN pcNarrativa4 = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaData DBOProgram 
PROCEDURE piSetaData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-dt-indice like {&TableName}.dt-indice    no-undo.


ASSIGN rowObject.dt-indice = p-dt-indice
       dt-data-indice = p-dt-indice.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaDtProxAval DBOProgram 
PROCEDURE piSetaDtProxAval :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter p-dt-ult-aval  as date format 99/99/9999 no-undo.
    define input  parameter p-num-meses    as integer                no-undo.
    define output parameter p-dt-prox-aval as date format 99/99/9999 no-undo.

    define variable ultimo-dia-mes        as date format 99/99/9999 no-undo.
    
    if p-dt-ult-aval > today then 
       assign p-dt-ult-aval = today.

    if  month(p-dt-ult-aval) + p-num-meses > 12 then do:

        assign p-dt-prox-aval = date(month(p-dt-ult-aval) + p-num-meses - 12,
                                   day  (p-dt-ult-aval),
                                   year (p-dt-ult-aval) + 1) no-error.
        if  error-status:error then
            assign p-dt-prox-aval   = date(month(p-dt-ult-aval) + p-num-meses - 12,
                                         1,
                                         year(p-dt-ult-aval))
                   ultimo-dia-mes = p-dt-prox-aval - day(p-dt-prox-aval) + 33
                   ultimo-dia-mes = ultimo-dia-mes - day(ultimo-dia-mes)
                   p-dt-prox-aval   = ultimo-dia-mes.
    end.
    else do:

        assign p-dt-prox-aval = date(month(p-dt-ult-aval) + p-num-meses,
                                   day  (p-dt-ult-aval),
                                   year (p-dt-ult-aval)) no-error.

        if  error-status:error then do:
            assign p-dt-prox-aval   = date(month(p-dt-ult-aval) + p-num-meses,
                                         1,
                                         year(p-dt-ult-aval))
                   ultimo-dia-mes = p-dt-prox-aval - day(p-dt-prox-aval) + 33
                   ultimo-dia-mes = ultimo-dia-mes - day(ultimo-dia-mes).
                   p-dt-prox-aval   = ultimo-dia-mes.
        end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTotalizaFornecedor DBOProgram 
PROCEDURE piTotalizaFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR de-tot-for AS DEC NO-UNDO.
DEF BUFFER b-tt-notas FOR tt-notas.

assign de-tot-for = 0.
for each tt-notas where
         tt-notas.tipo = "DF"
   break by tt-notas.dt-indice-fim
         by tt-notas.cod-estabel
         by tt-notas.cod-emitente:

   assign de-tot-for = de-tot-for + tt-notas.nota.

    if last-of(tt-notas.dt-indice-fim) or
       last-of(tt-notas.cod-estabel) or
       last-of(tt-notas.cod-emitente) then do:
       create b-tt-notas.
       assign b-tt-notas.cod-estabel  = tt-notas.cod-estabel
              b-tt-notas.cod-emitente = tt-notas.cod-emitente
              b-tt-notas.dt-indice    = tt-notas.dt-indice-fim
              b-tt-notas.des-periodo-aval = tt-notas.des-periodo-aval
              b-tt-notas.ano-avaliacao    = tt-notas.ano-avaliacao
              b-tt-notas.dt-indice-ini    = tt-notas.dt-indice-ini
              b-tt-notas.dt-indice-fim    = tt-notas.dt-indice-fim
              b-tt-notas.nota         = de-tot-for
              b-tt-notas.tipo         = "TF"   
              b-tt-notas.nome-abrev   = tt-notas.nome-abrev
              b-tt-notas.nome-emit    = tt-notas.nome-emit.
       IF b-tt-notas.nota = ? THEN ASSIGN b-tt-notas.nota = 0.
       IF b-tt-notas.indice = ? THEN ASSIGN b-tt-notas.indice = 0.
       IF b-tt-notas.percentual = ? THEN ASSIGN b-tt-notas.percentual = 0.
       assign de-tot-for = 0.
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaVersao DBOProgram 
PROCEDURE piValidaVersao :
/*------------------------------------------------------------------------------
  Purpose: Valida vers∆o sugerida e vers∆o do per°odo se est∆o de acordo     
  Parameters:
              p-estabel  : C¢digo do estabelecimento
              p-emitente : C¢digo do emitente
              p-item     : C¢digo do item
              p-versao   : C¢digo da vers∆o
              p-data     : Data de °ndice
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-estabel    LIKE RowObject.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER p-emitente   LIKE RowObject.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER p-item       LIKE RowObject.it-codigo NO-UNDO.
DEFINE INPUT PARAMETER p-versao     LIKE RowObject.nr-versao NO-UNDO.
DEFINE INPUT PARAMETER p-data       LIKE RowObject.dt-indice NO-UNDO.


FOR EACH tt-item-data EXCLUSIVE-LOCK:
    DELETE tt-item-data.
END.

FIND FIRST param-af NO-LOCK
    WHERE param-af.ep-codigo = i-ep-codigo-usuario NO-ERROR.

IF param-af.log-usa-versao THEN DO:
    IF NOT VALID-HANDLE(h-boaf023) THEN
        RUN afbo/boaf023.p PERSISTENT SET h-boaf023.

    IF NOT CAN-FIND(FIRST tt-versao-data) THEN DO:   
        RUN piRetornaVersoesData IN h-boaf023(INPUT i-ep-codigo-usuario,
                                              OUTPUT TABLE tt-versao-data).
    END.

    IF param-af.i-tipo-validade-versao = 1 THEN DO: /* controle de validade conforme utilizacao de versoes */

        IF NOT VALID-HANDLE(h-boaf006) THEN
            RUN afbo/boaf006.p PERSISTENT SET h-boaf006.

        RUN piRetornaVersoesData IN h-boaf006(INPUT i-ep-codigo-usuario,
                                              INPUT p-item,
                                              INPUT p-emitente,
                                              INPUT p-estabel,
                                              INPUT TABLE tt-versao-data,
                                              OUTPUT TABLE tt-item-data).
        FOR EACH tt-item-data NO-LOCK
            WHERE p-versao = tt-item-data.nr-versao:

            IF p-data >= tt-item-data.data-ini AND
               p-data <= tt-item-data.data-fim THEN DO:
                RETURN "OK":U.
            END.
        END.
    END.
    ELSE DO: /* controle de validade conforme cadastro de versoes */
        FOR EACH tt-versao-data NO-LOCK
            WHERE p-versao = tt-versao-data.nr-versao:

            IF p-data >= tt-versao-data.data-ini AND
               p-data <= tt-versao-data.data-fim THEN DO:
                RETURN "OK":U.
            END.
        END.
    END.
END.
ELSE DO:
    RETURN "OK":U.
END.

RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ResultadoPontoControle DBOProgram 
PROCEDURE ResultadoPontoControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEstabel   LIKE af-contr-indice.cod-estabel  NO-UNDO.
DEFINE INPUT PARAMETER pCodEmitente  LIKE af-contr-indice.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER pItCodigo     LIKE af-contr-indice.it-codigo    NO-UNDO.
DEFINE INPUT PARAMETER pNrControle   LIKE af-contr-indice.nr-controle  NO-UNDO.
DEFINE INPUT PARAMETER pDtIndice     LIKE af-contr-indice.dt-indice    NO-UNDO.
DEFINE INPUT PARAMETER ptipomovto    as   int                          no-undo. /* 1 - Inclus∆o / 2 - Alteraá∆o */
DEFINE OUTPUT PARAMETER l-habilita   AS LOGICAL                        NO-UNDO.
DEFINE OUTPUT PARAMETER c-resultados AS CHARACTER                      NO-UNDO.
DEFINE OUTPUT PARAMETER c-valor      AS CHARACTER                      NO-UNDO.

if pNrControle = 0 then do:
    ASSIGN l-habilita = NO
           c-valor    = "".
end.


DEFINE VARIABLE c-result     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-resultados AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-inicial    AS CHARACTER  NO-UNDO.

def buffer b-af-contr-indice for af-contr-indice.

DEFINE VARIABLE c-resultado-atual AS CHARACTER  NO-UNDO.

IF NOT VALID-HANDLE(h-boaf021) THEN 
    RUN afbo/boaf021.p persistent set h-boaf021.

RUN listaResultadoPontoControle IN h-boaf021 (INPUT pNrControle,
                                              OUTPUT c-result,
                                              OUTPUT l-resultados).
ASSIGN c-resultados = c-result.

IF l-resultados = NO THEN DO:
    ASSIGN l-habilita = NO
           c-valor    = "".
    DELETE PROCEDURE h-boaf021.
    RETURN "OK":U.
END.

if ptipomovto = 2 then do:
    FIND FIRST b-af-contr-indice 
         WHERE b-af-contr-indice.ep-codigo    = i-ep-codigo-usuario AND
               b-af-contr-indice.cod-estabel  = pCodEstabel AND
               b-af-contr-indice.cod-emitente = pCodEmitente AND
               b-af-contr-indice.it-codigo    = pItCodigo AND
               b-af-contr-indice.nr-controle  = pNrControle AND
               b-af-contr-indice.dt-indice    = pDtIndice NO-LOCK NO-ERROR.
    IF AVAIL b-af-contr-indice THEN DO:
        if b-af-contr-indice.seq-resultado <> 0 THEN do:
            RUN retornaResultadoPontoControle IN h-boaf021 (INPUT b-af-contr-indice.nr-controle,
                                                            INPUT b-af-contr-indice.seq-resultado,
                                                            OUTPUT c-resultado-atual).
             ASSIGN l-habilita = YES
                    c-valor    = c-resultado-atual.
        end.
        else 
            ASSIGN l-habilita = NO
               c-valor    = "".
    
        DELETE PROCEDURE h-boaf021.
        RETURN "OK":U.
    END.
end.
ELSE DO:
    ASSIGN l-habilita = YES
           c-valor    = "".
end.

DELETE PROCEDURE h-boaf021.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintChave DBOProgram 
PROCEDURE setConstraintChave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-cod-estabel-ini  like {&TableName}.cod-estabel  no-undo.
    def input param p-cod-estabel-fim  like {&TableName}.cod-estabel  no-undo.
    def input param p-cod-emitente-ini like {&TableName}.cod-emitente no-undo.
    def input param p-cod-emitente-fim like {&TableName}.cod-emitente no-undo.
    def input param p-it-codigo-ini    like {&tablename}.it-codigo    no-undo.
    def input param p-it-codigo-fim    like {&tablename}.it-codigo    no-undo.
    def input param p-nr-controle-ini  like {&TableName}.nr-controle  no-undo.
    def input param p-nr-controle-fim  like {&TableName}.nr-controle  no-undo.
    def input param p-dt-indice-ini    like {&TableName}.dt-indice    no-undo.
    def input param p-dt-indice-fim    like {&TableName}.dt-indice    no-undo.
    
    assign c-cod-estabel-ini   = p-cod-estabel-ini.
    assign c-cod-estabel-fim   = p-cod-estabel-fim.
    assign i-cod-emitente-ini  = p-cod-emitente-ini.
    assign i-cod-emitente-fim  = p-cod-emitente-fim.
    assign c-it-codigo-ini     = p-it-codigo-ini.
    assign c-it-codigo-fim     = p-it-codigo-fim.
    assign i-nr-controle-ini   = p-nr-controle-ini.
    assign i-nr-controle-fim   = p-nr-controle-fim.
    assign da-dt-indice-ini    = p-dt-indice-ini.
    assign da-dt-indice-fim    = p-dt-indice-fim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataIndice DBOProgram 
PROCEDURE setDataIndice :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ep-form
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo cod-estabel
               retorna valor do campo nr controle
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-estabel  LIKE af-contr-indice.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-emitente LIKE af-contr-indice.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo    LIKE af-contr-indice.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-controle  LIKE af-contr-indice.nr-controle  NO-UNDO.
    DEFINE OUTPUT PARAMETER pdata-indice  LIKE af-contr-indice.dt-indice    NO-UNDO.

    FIND FIRST af-contr-indice WHERE 
           af-contr-indice.ep-codigo    = i-ep-codigo-usuario AND
           af-contr-indice.cod-estabel  = pcod-estabel  AND
           af-contr-indice.cod-emitente = pcod-emitente AND
           af-contr-indice.it-codigo    = pit-codigo    AND
           af-contr-indice.nr-controle  = pnr-controle NO-LOCK NO-ERROR.
    IF AVAIL af-contr-indice THEN 
        ASSIGN pdata-indice = af-contr-indice.dt-indice.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataPeriodo DBOProgram 
PROCEDURE setDataPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-dt-indice as date.

assign da-dt-indice = p-dt-indice.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetDefaults DBOProgram 
PROCEDURE SetDefaults :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-ep-codigo like af-contr-indice.ep-codigo no-undo.
def output param p-dt-indice as date no-undo.
def output param p-cod-estabel like estabelec.cod-estabel no-undo.

if not avail param-estoq then
   find first param-estoq no-lock no-error.

assign p-ep-codigo   = i-ep-codigo-usuario
       p-dt-indice   = today
       p-cod-estabel = param-estoq.estabel-pad.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPeriodo DBOProgram 
PROCEDURE setPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-periodo as char.

assign c-periodo = p-periodo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEF VAR h-boaf016 AS HANDLE NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "CREATE" THEN DO:
       IF rowObject.dt-indice = ? THEN
           run getDataPeriodo (output rowObject.dt-indice).

       IF rowObject.dt-indice <> ? THEN DO:
           ASSIGN l-erro-periodo = YES.
           DO i-cont = 1 TO 12:
               IF CAN-FIND(FIRST af-periodo-aval
                           WHERE af-periodo-aval.ep-codigo = i-ep-codigo-usuario AND
                                 af-periodo-aval.ano-avaliacao = INT(YEAR(rowObject.dt-indice)) AND
                                 af-periodo-aval.dt-periodo-ini[i-cont] <= rowObject.dt-indice AND
                                 af-periodo-aval.dt-periodo-fim[i-cont] >= rowObject.dt-indice) THEN DO:
                   ASSIGN l-erro-periodo = NO.
                   LEAVE.
               END.
           END.
           IF l-erro-periodo THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-periodo AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Per°odo" *}
               ASSIGN c-lbl-liter-periodo = RETURN-VALUE.
               DEFINE VARIABLE c-lbl-liter-periodo-de-avaliacao-af0110 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Per°odo_de_Avaliaá∆o_(AF0110)" *}
               ASSIGN c-lbl-liter-periodo-de-avaliacao-af0110 = RETURN-VALUE.
               {method/svc/errors/inserr.i
                               &ErrorNumber="52861"
                               &ErrorType="EMS"
                               &ErrorSubType="Error"
                               &ErrorParameters="c-lbl-liter-periodo + '~~~~' + c-lbl-liter-periodo-de-avaliacao-af0110"}
           END.
       END.
       ELSE DO:
           if int(substr(c-periodo,1,2)) < 1 or
              int(substr(c-periodo,1,2)) > 12 then do:
              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-mes-do-periodo-deve-ser-entre AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Màs_do_per°odo_deve_ser_entre_1_e_12" *}
              ASSIGN c-lbl-liter-mes-do-periodo-deve-ser-entre = RETURN-VALUE.
              {method/svc/errors/inserr.i
                   &ErrorNumber="17006"
                   &ErrorType="EMS"
                   &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-mes-do-periodo-deve-ser-entre"}  
           end.
       end.

       FIND FIRST bf{&TableName}
            WHERE bf{&TableName}.ep-codigo = rowObject.ep-codigo and
                  bf{&TableName}.cod-estabel = rowObject.cod-estabel and
                  bf{&TableName}.cod-emitente = rowObject.cod-emitente and
                  bf{&tablename}.it-codigo = rowObject.it-codigo and
                  bf{&TableName}.nr-controle = rowObject.nr-controle and
                  bf{&TableName}.dt-indice = rowObject.dt-indice NO-LOCK NO-ERROR.


       IF AVAIL bf{&TableName} THEN
           /* Inicio -- Projeto Internacional */
           DO:
           DEFINE VARIABLE c-lbl-liter-indice-do-ponto-de-controle AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "÷ndice_do_Ponto_de_Controle" *}
           ASSIGN c-lbl-liter-indice-do-ponto-de-controle = RETURN-VALUE.
           {method/svc/errors/inserr.i
           &ErrorNumber="1"
           &ErrorType="EMS"
           &ErrorSubType="Error"
           &ErrorParameters="c-lbl-liter-indice-do-ponto-de-controle"}
           END.   

        IF rowObject.it-codigo = "" THEN
            FIND FIRST af-item-contr-estab-form
            WHERE af-item-contr-estab-form.ep-codigo    = rowObject.ep-codigo and
                  af-item-contr-estab-form.cod-estabel  = rowObject.cod-estabel and
                  af-item-contr-estab-form.cod-emitente = rowObject.cod-emitente AND
                  af-item-contr-estab-form.nr-controle  = rowObject.nr-controle AND
                  af-item-contr-estab-form.nr-versao    = rowObject.nr-versao NO-LOCK NO-ERROR.
        ELSE
            FIND FIRST af-item-contr-estab-form
            WHERE af-item-contr-estab-form.ep-codigo    = rowObject.ep-codigo and
                  af-item-contr-estab-form.cod-estabel  = rowObject.cod-estabel and
                  af-item-contr-estab-form.cod-emitente = rowObject.cod-emitente and
                  af-item-contr-estab-form.it-codigo    = rowObject.it-codigo and
                  af-item-contr-estab-form.nr-controle  = rowObject.nr-controle AND
                  af-item-contr-estab-form.nr-versao    = rowObject.nr-versao NO-LOCK NO-ERROR.
        IF AVAIL af-item-contr-estab-form THEN DO:
            IF af-item-contr-estab-form.ativo = NO THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ponto-de-controle AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ponto_de_Controle" *}
                ASSIGN c-lbl-liter-ponto-de-controle = RETURN-VALUE.
                DEFINE VARIABLE c-lbl-liter-item-e-fornecedor AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item_e_Fornecedor" *}
                ASSIGN c-lbl-liter-item-e-fornecedor = RETURN-VALUE.

                {method/svc/errors/inserr.i
                &ErrorNumber="52862"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-ponto-de-controle + '~~~~' + c-lbl-liter-item-e-fornecedor"}
            END.

            /*Valida a data para a vers∆o*/
            RUN piValidaVersao (INPUT RowObject.cod-estabel,
                                INPUT RowObject.cod-emitente,
                                INPUT RowObject.it-codigo,
                                INPUT RowObject.nr-versao,
                                INPUT RowObject.dt-indice).
    
            IF RETURN-VALUE = "NOK":U THEN DO:
                DEFINE VARIABLE c-lbl-liter-ponto-controle-item-x-estabele-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ponto_Controle_Item_X_Estabelecimento_X_Fornecedor" *}
                ASSIGN c-lbl-liter-ponto-controle-item-x-estabele-2 = RETURN-VALUE.
                {method/svc/errors/inserr.i                        
                            &ErrorNumber="2"                                   
                            &ErrorType="EMS"                                   
                            &ErrorSubType="Error"                              
                            &ErrorParameters="c-lbl-liter-ponto-controle-item-x-estabele-2"} 
            END.
        END.
        ELSE DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ponto-controle-item-x-estabele AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ponto_Controle_Item_X_Estabelecimento_X_Fornecedor" *}
            ASSIGN c-lbl-liter-ponto-controle-item-x-estabele = RETURN-VALUE.
            {method/svc/errors/inserr.i                        
                        &ErrorNumber="2"                                   
                        &ErrorType="EMS"                                   
                        &ErrorSubType="Error"                              
                        &ErrorParameters="c-lbl-liter-ponto-controle-item-x-estabele"}
       END.               
    end.

    if pType <> "Delete" then do:

       FIND af-controle
           WHERE af-controle.ep-codigo = RowObject.ep-codigo
           AND   af-controle.nr-controle = rowObject.nr-controle
           NO-LOCK NO-ERROR.
       if AVAIL af-controle AND af-controle.padrao then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-pontos-de-controle-padroes AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Pontos_de_Controle_Padr‰es" *}
           ASSIGN c-lbl-liter-pontos-de-controle-padroes = RETURN-VALUE.
           DEFINE VARIABLE c-lbl-liter-notas-manuais AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "notas_manuais" *}
           ASSIGN c-lbl-liter-notas-manuais = RETURN-VALUE.
           {method/svc/errors/inserr.i
                  &ErrorNumber="52863"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                  &ErrorParameters="c-lbl-liter-pontos-de-controle-padroes + '~~~~' + c-lbl-liter-notas-manuais"}
       end.
       if AVAIL af-controle AND af-controle.log-formula AND af-controle.cod-formula <> 0 then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-ponto-de-controle-calculados-p AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Ponto_de_Controle_calculados_por_f¢rmulas" *}
           ASSIGN c-lbl-liter-ponto-de-controle-calculados-p = RETURN-VALUE.
           DEFINE VARIABLE c-lbl-liter-notas-manuais-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "notas_manuais" *}
           ASSIGN c-lbl-liter-notas-manuais-2 = RETURN-VALUE.
           {method/svc/errors/inserr.i
                   &ErrorNumber="52863"
                   &ErrorType="EMS"
                   &ErrorSubType="Error"
                   &ErrorParameters="c-lbl-liter-ponto-de-controle-calculados-p + '~~~~' + c-lbl-liter-notas-manuais-2"}
       end.


       if rowObject.indice > 100 then do:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-indice AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "÷ndice" *}
          ASSIGN c-lbl-liter-indice = RETURN-VALUE.
          {method/svc/errors/inserr.i
                 &ErrorNumber="16445"
                 &ErrorType="EMS"
                 &ErrorSubType="Error"
                 &ErrorParameters="c-lbl-liter-indice + '~~~~' + '100%'"}
       end.

       FIND FIRST estabelec
            WHERE estabelec.cod-estabel = rowObject.cod-estabel no-lock no-error. 
    
       IF NOT AVAIL estabelec THEN
         /* Inicio -- Projeto Internacional */
         DO:
         DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Estabelecimento" *}
         ASSIGN c-lbl-liter-estabelecimento = RETURN-VALUE.
         {method/svc/errors/inserr.i
                 &ErrorNumber="2"
                 &ErrorType="EMS"
                 &ErrorSubType="Error"
                 &ErrorParameters="c-lbl-liter-estabelecimento"}
         END. 
                 
       FIND FIRST item
            WHERE item.it-codigo = rowObject.it-codigo no-lock no-error. 
    
       IF NOT AVAIL item THEN
         /* Inicio -- Projeto Internacional */
         DO:
         DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Item" *}
         ASSIGN c-lbl-liter-item = RETURN-VALUE.
         {method/svc/errors/inserr.i
                 &ErrorNumber="2"
                 &ErrorType="EMS"
                 &ErrorSubType="Error"
                 &ErrorParameters="c-lbl-liter-item"}
         END. 
                 
       FIND FIRST emitente
            WHERE emitente.cod-emitente = rowObject.cod-emitente no-lock no-error. 
    
       IF NOT AVAIL emitente THEN
         /* Inicio -- Projeto Internacional */
         DO:
         DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Emitente" *}
         ASSIGN c-lbl-liter-emitente = RETURN-VALUE.
         {method/svc/errors/inserr.i
                 &ErrorNumber="2"
                 &ErrorType="EMS"
                 &ErrorSubType="Error"
                 &ErrorParameters="c-lbl-liter-emitente"}
         END. 
                 
       FIND FIRST af-controle
            WHERE af-controle.nr-controle = rowObject.nr-controle no-lock no-error. 
    
       IF NOT AVAIL af-controle THEN
         /* Inicio -- Projeto Internacional */
         DO:
         DEFINE VARIABLE c-lbl-liter-ponto-de-controle-2 AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Ponto_de_Controle" *}
         ASSIGN c-lbl-liter-ponto-de-controle-2 = RETURN-VALUE.
         {method/svc/errors/inserr.i
                 &ErrorNumber="2"
                 &ErrorType="EMS"
                 &ErrorSubType="Error"
                 &ErrorParameters="c-lbl-liter-ponto-de-controle-2"}
         END. 
                 
/*        if rowObject.it-codigo <> "" and                                                                                                  */
/*           not can-find (first af-item-contr-estab-form where                                                                             */
/*                               af-item-contr-estab-form.ep-codigo = i-ep-codigo-usuario and                                               */
/*                               af-item-contr-estab-form.cod-estabel = rowObject.cod-estabel and                                           */
/*                               af-item-contr-estab-form.cod-emitente = rowObject.cod-emitente and                                         */
/*                               af-item-contr-estab-form.it-codigo = rowObject.it-codigo and                                               */
/*                               af-item-contr-estab-form.nr-controle = rowObject.nr-controle) then do:                                     */
/*           {method/svc/errors/inserr.i                                                                                                    */
/*                  &ErrorNumber="15825"                                                                                                    */
/*                  &ErrorType="EMS"                                                                                                        */
/*                  &ErrorSubType="Error"                                                                                                   */
/*                  &ErrorParameters="'Ponto de controle n∆o pertence a f¢rmula da chave informada ~~~~' +                                  */
/*                                    'O °ndice informado n∆o ter† influància na avaliaá∆o do fornecedor, ' +                               */
/*                                    'pois n∆o consta na f¢rmula da chave informada (estabelecimento/fornecedor/item/ponto de controle)'"} */
/*                                                                                                                                          */
/*        end.                                                                                                                              */
        
       DEF VAR l-fechado AS LOG NO-UNDO.
       RUN afbo/boaf016.p persistent set h-boaf016.
       EMPTY TEMP-TABLE tt-dt-periodo-aval.
       RUN validaPeriodoFechado IN h-boaf016 (INPUT rowObject.dt-indice,
                                              INPUT TABLE tt-dt-periodo-aval,
                                              OUTPUT l-fechado).
       DELETE PROCEDURE h-boaf016.
       IF l-fechado THEN DO:
           {method/svc/errors/inserr.i
                   &ErrorNumber="52864"
                   &ErrorType="EMS"
                   &ErrorSubType="Error"
                   &ErrorParameters=STRING(MONTH(rowObject.dt-indice),'99') + '/' 
                                                + STRING(YEAR(rowObject.dt-indice),'9999')}
       END.

       /* valida justificafica da nota */
       IF rowObject.narrativa = "" THEN DO:
          FIND FIRST af-controle-result 
               WHERE af-controle-result.ep-codigo = i-ep-codigo-usuario
               AND   af-controle-result.nr-controle = rowObject.Nr-Controle 
               AND   af-controle-result.seq-resultado  = rowObject.seq-resultado NO-LOCK NO-ERROR.
          IF AVAIL af-controle-result AND af-controle-result.log-justificativa THEN DO:
             {method/svc/errors/inserr.i
                      &ErrorNumber="52865"
                      &ErrorType="EMS"
                      &ErrorSubType="Error"
                      &ErrorParameters="''"}

          END.
       END.



    end.
    ELSE DO:

        FIND af-controle
            WHERE af-controle.ep-codigo = RowObject.ep-codigo
            AND   af-controle.nr-controle = rowObject.nr-controle
            NO-LOCK NO-ERROR.
        if AVAIL af-controle AND af-controle.padrao then do:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-indice-de-ponto-de-controle-pa AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "÷ndice_de_Ponto_de_Controle_Padr∆o" *}
           ASSIGN c-lbl-liter-indice-de-ponto-de-controle-pa = RETURN-VALUE.
           {method/svc/errors/inserr.i
                  &ErrorNumber="28673"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                  &ErrorParameters="c-lbl-liter-indice-de-ponto-de-controle-pa"}
        end.


    END.

    if can-find (first af-controle-result 
                 where af-controle-result.nr-controle = rowObject.nr-controle) then do:

        if (pType = "Create" and rowObject.seq-resultado = 0) or
           (pType = "Update" and af-contr-indice.seq-resultado <> 0 and rowObject.seq-resultado = 0) then do:
             {method/svc/errors/inserr.i
                  &ErrorNumber="52866"
                  &ErrorType="EMS"
                  &ErrorSubType="Error"
                  &ErrorParameters="''"}
        end.
    end.

    if pType <> "Delete" then
       run beforeUpdateRecord.



    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


