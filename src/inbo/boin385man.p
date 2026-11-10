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
{include/i-prgvrs.i BOIN385MAN 2.00.00.014 } /*** "010014" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin385man MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName requisicao
&GLOBAL-DEFINE TableLabel requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin385.i RowObject}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER b-it-requisicao FOR it-requisicao.

{cdp/cdcfgmat.i}
{cdp/cd0669.i}

def var laberta            as logical no-undo initial yes.
def var lfechada           as logical no-undo initial yes.
def var lpendente          as logical no-undo initial yes.
def var lcomordem          as logical no-undo initial yes.
def var ifiltro1           as int     no-undo initial 0.
def var ifiltro2           as int     no-undo initial 99.
def var ifiltro3           as int     no-undo initial 99.
def var inr-requisicao-ini LIKE requisicao.nr-requisicao     no-undo initial 0.
def var inr-requisicao-fin LIKE requisicao.nr-requisicao     no-undo initial 999999999.
def var i-tipo-doc         as int     no-undo.
def var c-estab            as char    no-undo.
def var l-val-item         as log     no-undo.
def var de-preco-unit      as dec     no-undo.
def var c-cod-estabel      as char    no-undo.
def var i-tipo-requis      as int     no-undo.
def var i-tipo-requis-old  as int     no-undo.
def var l-retorno-aprov    as log     no-undo.
def var cType               as char    no-undo.
def var i-tipo-trans        as int     no-undo.
def var l-pendente          as log     no-undo.
def var c-usuario-aux       as char    no-undo.
def var i-seq               as int     no-undo.
def var i-moeda-lim         as int     no-undo.
def var i-tipo-moeda        as int     no-undo.
def var de-valor-doc        as dec     no-undo.
def var de-valor-lim        as dec     no-undo.
def var c-tipo-moeda        as char    no-undo.
def var c-moeda-lim         as char    no-undo.
def var r-rowid             as rowid   no-undo.
def var h-boin168           as handle  no-undo.
DEF VAR de-valor-item       AS DEC     NO-UNDO.
DEF VAR de-valor-total      AS DEC     NO-UNDO.

/******** Vari vel setada a partir da interface WEB que indica a modifica‡Æo 
               de Requisi‡äes/Solicita‡äes j  aprovadas  ****************/

def var c-modif-aprovadas as char no-undo.                                             

/***********************************************************************/

    def new global shared var gl-proxima-aprovacao  as logical no-undo.
    def new global shared var gi-proxima-prioridade as integer no-undo.
    def new global shared var c-seg-usuario as char format "x(12)" no-undo.

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
         HEIGHT             = 23
         WIDTH              = 56.43.
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


{method/svc/autentic/autentic.i         
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    run aprovacaoEletronicaRequisicao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovacaoEletronicaRequisicao DBOProgram 
PROCEDURE aprovacaoEletronicaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:   if  pType = "DELETE":U OR pType = "UPDATE":U then do:
       IF  c-seg-usuario NE RowObject.nome-abrev THEN DO:
           {method/svc/errors/inserr.i &ErrorNumber="27706"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U} 
       END.
   END.
------------------------------------------------------------------------------*/

    if avail requisicao then do:
        assign requisicao.cod-estabel = c-cod-estabel
               requisicao.tp-requis   = i-tipo-requis
               requisicao.situacao    = RowObject.situacao.
        for each it-requisicao fields(nr-requisicao cod-estabel nome-abrev situacao) where
            it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK:
            assign it-requisicao.cod-estabel = c-cod-estabel
                   it-requisicao.nome-abrev  = requisicao.nome-abrev.
            if RowObject.situacao = 2 then 
                assign it-requisicao.situacao = requisicao.situacao.
        end.
        if cType = "Create"
        then
            run ccp/ccapi642.p (2, rowid(requisicao), 1).
        else if cType = "Update"
             then
                 run ccp/ccapi642.p (2, rowid(requisicao), 2).
            
        /* Aprova‡Æo Eletr“nica, caso seja alterado o tipo da requisica */
               
        if cType = "Update" and param-compra.log-1 and
           i-tipo-requis-old <> i-tipo-requis then do:
           run aprovEletrModificadoTipoRequisicao.
        end.  
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovEletrModificadoTipoRequisicao DBOProgram 
PROCEDURE aprovEletrModificadoTipoRequisicao :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

  find usuar-mater where
       usuar-mater.cod-usuario = requisicao.nome-abrev
       no-lock no-error.
       
  if  i-tipo-requis-old = 1  and substr(param-estoq.char-1,4,1) = "Y" and 
      param-compra.log-1  then
      assign i-tipo-doc = 2.
  else if  i-tipo-requis-old = 2 then
      assign i-tipo-doc = 1.
  
  /* Elimina Pendˆncias Aprova‡Æo, com base no tipo de requisi‡Æo anterior */
  if i-tipo-doc > 0 then do:
     for each it-requisicao 
         where it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK:    
         run cdp/cdapi171.p (i-tipo-doc, 3, rowid(it-requisicao)).   
     end.
  end.
  
  
  /* Aprova Documento **************************************/   
  assign i-tipo-trans =  2
         i-tipo-doc = 0. 
         
  if  requisicao.tp-requis = 1 /*Se for Requisicao e Aprova Requisicao*/
      and substr(param-estoq.char-1,4,1) = "Y"
      and param-compra.log-1  then
      assign i-tipo-doc = 2.
  else if  requisicao.tp-requis = 2 /*SenÆo, Se for Solicita‡Æo e utiliza aprova‡Æo eletr“nica*/
       and param-compra.log-1 then
       assign i-tipo-doc = 1.          
  
  for each it-requisicao 
       where it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK:   
      if  i-tipo-doc > 0 then do:       
          run cdp/cdapi171.p (i-tipo-doc, i-tipo-trans, rowid(it-requisicao)).
      end.
      
      assign requisicao.estado = 1
             requisicao.nome-aprov = requisicao.nome-abrev.
      
      /**  Melhorias
      **/
      &if defined(bf_mat_aprova_eletronica) &then
          assign it-requisicao.estado = 1
                 it-requisicao.nome-aprov = requisicao.nome-abrev.
      &endif
      
      if  i-tipo-doc > 0 then do:
          assign l-pendente = no.
          run cdp/cdapi172.p (i-tipo-doc,rowid(it-requisicao), output l-pendente).
          if  l-pendente then do:
              assign requisicao.estado = 2
                     requisicao.nome-aprov = "":U.
                     
              /**  Melhorias
              **/
              &if defined(bf_mat_aprova_eletronica) &then
                  assign it-requisicao.estado = 2
                         it-requisicao.nome-aprov = "":U.
              &endif
          end.                   
      end.    
     
      /********* INVESTIMENTOS ********/
      if connected("mginv")     and
         param-global.modulo-in and it-requisicao.num-ord-inv <> 0 then do:   
         if cType = "Create" then   
               run inp/in2101.p(input rowid(requisicao), input rowid(it-requisicao) , "Inclui").
         else if cType = "Update" then   
               run inp/in2101.p(input rowid(requisicao), input rowid(it-requisicao) , "Modifica").
      end.
      /********************************/
                  
      if it-requisicao.num-ord-inv <> 0 and
         it-requisicao.num-ord-inv <> ? and
         requisicao.situacao = 3 and param-global.modulo-in = yes then do:
         assign requisicao.situacao = 1.           
      end.     
      
  end.    

  run mensagemAprovEletrRequisicao.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /** L¢gica transferida da TRIGGER de DELETE da requisicao **/

        DISABLE TRIGGERS FOR DUMP OF requisicao.

        /*** Se o comando acima nÆo funcionar, usar esse que est  em coment rio ****
            /* Ignora as Triggers */
            ON WRITE OF requisicao OVERRIDE DO:
            END.
        ***/

    /** NÆo elimine a linha abaixo, ‚ a chamada EPC **/
    {include/i-epc102.i requisicao}
     
    /** Inicio da elimina‡Æo em cascata **/

        run inbo/boin168.p persistent set h-boin168.
        for each it-requisicao where 
            it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
            /* {cdp/cd8120.i "mgcd1406" "E" "cd1406" ", c-reg"} */
            /* delete it-requisicao. */
            assign r-rowid = rowid(it-requisicao).
            run openQueryStatic in h-boin168 ("Main":U).
            RUN repositionRecord in h-boin168 (input r-rowid).                      
            RUN deleteRecord     in h-boin168 .    
             if return-value = "NOK" then do: 
                RUN getRowErrors  in h-boin168 (OUTPUT TABLE RowErrors) .                                                                                                
             end.
        end.
        delete procedure h-boin168.

    /** fim da trigger - x:/desenv/database/tgin/tdp/tdin385.p **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEstab_req DBOProgram 
PROCEDURE findEstab_req :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /*
  **  Procura pelo indice, caso nao ache,
  **  retorna mensagem de erro padrao do EMS.
  */
    def input parameter pccod-estabel as char no-undo.
    def input parameter pinr-requisicao LIKE requisicao.nr-requisicao no-undo.
    def output parameter pcreturn as char no-undo.

    RUN openQueryStatic (input "main":U).
        
     run goToKey (pccod-estabel, pinr-requisicao).

    if return-value = "OK" then assign pcreturn = "".
     if return-value = "NOK" then do:
     {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign pcreturn = return-value.
     end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRequisicao DBOProgram 
PROCEDURE findRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*
  **  Procura pelo indice, caso nao ache,
  **  retorna mensagem de erro padrao do EMS.
  */
     def input parameter pinr-requisicao LIKE requisicao.nr-requisicao no-undo.
     def output parameter pcreturn as char no-undo.
     
          run goToKeyRequisicao (pinr-requisicao).
   
     if return-value = "OK" then assign pcreturn = "".  /* esse ‚ o valor esperado nas interfaces 1.1 */
        if return-value = "NOK" then do:
      {utp/ut-table.i movind {&TABLENAME} 1}
      run utp/ut-msgs.p (input "msg",
                         input 2,
                         input return-value).
      assign pcreturn = return-value.
     end.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "loc-entrega":U THEN ASSIGN pFieldValue = RowObject.loc-entrega.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nome-aprov":U THEN ASSIGN pFieldValue = RowObject.nome-aprov.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-devol":U THEN ASSIGN pFieldValue = RowObject.dt-devol.
        WHEN "dt-requisicao":U THEN ASSIGN pFieldValue = RowObject.dt-requisicao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "impressa":U THEN ASSIGN pFieldValue = RowObject.impressa.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tp-requis":U THEN ASSIGN pFieldValue = RowObject.tp-requis.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ESTAB-REQ
  Parameters:
               retorna valor dos campos do ¡ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-requisicao = RowObject.nr-requisicao.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidRequisicao DBOProgram 
PROCEDURE getRowidRequisicao :
/*------------------------------------------------------------------------------
  Purpose:   Procura o rowid de uma requisicao de acordo com o n£mero da mesma.
  Parameters:  
             ipar1 : prItRequisicao : rowid do item da requisicao
             opar2 : prRequisicao   : rowid da requisicao
  Notes:
------------------------------------------------------------------------------*/
    def input  param prItRequisicao as rowid no-undo.
    def output param prRequisicao   as rowid no-undo.
    
    find it-requisicao where
         rowid(it-requisicao) = prItRequisicao
         no-lock no-error.
         
    find first requisicao where
               requisicao.nr-requisicao = it-requisicao.nr-requisicao
               no-lock no-error.
    if avail requisicao then do:
        assign prRequisicao = rowid(requisicao).
    end.    
                              
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice ESTAB-REQ
  Parameters:
               recebe valor dos campos do ¡ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    FIND FIRST bfrequisicao WHERE
        bfrequisicao.cod-estabel = pcod-estabel AND
        bfrequisicao.nr-requisicao = pnr-requisicao
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrequisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrequisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRequisicao DBOProgram 
PROCEDURE goToKeyRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:
               
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.
   
    
    FIND FIRST bfrequisicao WHERE
        bfrequisicao.nr-requisicao = pnr-requisicao 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrequisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrequisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE indicaModificRequisAprovadas DBOProgram 
PROCEDURE indicaModificRequisAprovadas :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input  param pcModifAprovadas as char  no-undo.
    def input  param pcUsuario        as char  no-undo.    
    def input  param prRequisicao     as rowid no-undo.
    
    find requisicao where 
         rowid(requisicao) = prRequisicao 
         no-lock no-error.
         
    assign c-modif-aprovadas = pcModifAprovadas
           c-usuario-aux = pcUsuario.
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mensagemAprovEletrRequisicao DBOProgram 
PROCEDURE mensagemAprovEletrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    
    find first param-compra no-lock no-error.

    /**
    ***   Mensagem de Aprova‡Æo
    **/
    if i-tipo-doc = 0 then do:
        {method/svc/errors/inserr.i &ErrorNumber="16760"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="''"}         
        return "NOK"  .             
    end.  
    assign i-seq = 1.    
    for each it-requisicao 
        where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:
        run cdp/cdapi174.p (i-tipo-doc,
                            rowid(it-requisicao),
                            output i-moeda-lim,
                            output i-tipo-moeda,
                            output de-valor-doc,
                            output de-valor-lim).
        find moeda where
            moeda.mo-codigo = i-moeda-lim
            no-lock no-error.
        assign c-moeda-lim  = string(i-moeda-lim,"9") + " - ":U + moeda.descricao.
        case i-tipo-moeda:
            when 1 then do:
                {utp/ut-liter.i (Usu rio) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 2 then do:
                {utp/ut-liter.i (Aprovador) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 3 then do:
                {utp/ut-liter.i (Fam¡lia) * r}
                assign c-tipo-moeda = return-value.
            end.
            when 4 then do:
                {utp/ut-liter.i (Mestre) * r}
                assign c-tipo-moeda = return-value.
            end.
        end case.
        
        if  avail param-compra and 
            param-compra.log-1 and
            ((i-tipo-doc = 1 and substring(param-compra.char-2, 1, 3) = "nao") or
             (i-tipo-doc = 2 and substring(param-compra.char-2, 4, 3) = "nao") or
              i-tipo-doc > 2 ) then do:
              
            if requisicao.tp-requis = 1 then 
               {utp/ut-liter.i Requisi‡Æo}
            else 
               {utp/ut-liter.i Solicita‡Æo}

               if  not l-pendente then do:
                    {method/svc/errors/inserr.i &ErrorNumber="18346"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters="trim(return-value) + ' ' 
                                                                 + string(requisicao.nr-requisicao) + '~~~~'
                                                                 + c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}                     

               end.
               else do:
                    {method/svc/errors/inserr.i &ErrorNumber="18347"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="INFORMATION":U
                                                &ErrorParameters="trim(return-value) + ' ' 
                                                                 + string(requisicao.nr-requisicao) + '~~~~'
                                                                 + c-moeda-lim + '~~~~' 
                                                                 + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                                 + c-tipo-moeda + '~~~~' 
                                                                 + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}                 
               end.
        end.
        else do:               
            if  l-pendente = no then do:
                {method/svc/errors/inserr.i &ErrorNumber="16725"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             
            end.
            else do:
                {method/svc/errors/inserr.i &ErrorNumber="16724"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="INFORMATION":U
                                            &ErrorParameters="c-moeda-lim + '~~~~' 
                                                             + string(de-valor-lim,'zzz,zzz,zzz,zzz,zz9.99') 
                                                             + c-tipo-moeda + '~~~~' 
                                                             + string(de-valor-doc,'zzz,zzz,zzz,zzz,zz9.99')"}             

            end.
            leave.
        end.   
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then
           run openQueryStatic ("ByNrRequisicao").   
        when 3 then
           run openQueryStatic ("ByRequisicao").
        when 4 then
           run openQueryStatic ("ByRequisicao").        
    end. /*end case*/
   RETURN "OK":U.      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNrRequisicao DBOProgram 
PROCEDURE openQueryByNrRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH requisicao NO-LOCK 
               use-index requisicao INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByRequisicao DBOProgram 
PROCEDURE openQueryByRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
       /* Se as trˆs vari veis abaixo forem iguais o tipo da requisicao pode ser 
          igualada sem utilizar a cl usula 'OR' que causava muitos acessos a base */
       IF  ifiltro1 = ifiltro2
       AND ifiltro1 = ifiltro3 THEN DO:
           IF  laberta
           AND lfechada
           AND lpendente
           AND lcomordem THEN
               /* Quando for parametrizado para mostrar todas as situa‡äes 
                  de requisicao nÆo ser  restringido o campo situa‡Æo */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND {&TABLENAME}.tp-requis      = ifiltro1 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
           ELSE
           IF laberta
           AND NOT lfechada
           AND NOT lpendente
           AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as abertas 
                  ser  restringido o campo situacao = 1 */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND {&TABLENAME}.tp-requis      = ifiltro1            
                          AND {&TABLENAME}.situacao       = 1 NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
            IF  NOT laberta
            AND lfechada
            AND NOT lpendente
            AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as fechadas 
                  ser  restringido o campo situacao = 2 */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND {&TABLENAME}.tp-requis      = ifiltro1            
                           AND {&TABLENAME}.situacao       = 2 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND lpendente
             AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as pendentes 
                  ser  restringido o campo situacao = 3 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND {&TABLENAME}.tp-requis      = ifiltro1            
                            AND {&TABLENAME}.situacao       = 3 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.

             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND NOT lpendente
             AND lcomordem THEN
               /* Quando for parametrizado para mostrar somente as com Ordem 
                  ser  restringido o campo situacao = 4 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND {&TABLENAME}.tp-requis      = ifiltro1            
                            AND {&TABLENAME}.situacao       = 4 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
               /* Quando for qualquer outra combina‡Æo, ser  obrigat¢rio
                  a utiliza‡Æo da cl usula 'OR' no campo situacao */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND {&TABLENAME}.tp-requis      = ifiltro1            
                           AND (   (laberta   AND {&TABLENAME}.situacao = 1) 
                                OR (lfechada  AND {&TABLENAME}.situacao = 2) 
                                OR (lpendente AND {&TABLENAME}.situacao = 3) 
                                OR (lcomordem AND {&TABLENAME}.situacao = 4)) NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.

       END.
       ELSE DO:
           IF  laberta
           AND lfechada
           AND lpendente
           AND lcomordem THEN
               /* Quando for parametrizado para mostrar todas as situa‡äes 
                  de requisicao nÆo ser  restringido o campo situa‡Æo */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
           ELSE
           IF laberta
           AND NOT lfechada
           AND NOT lpendente
           AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as abertas 
                  ser  restringido o campo situacao = 1 */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                          AND {&TABLENAME}.situacao       = 1 NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
            IF  NOT laberta
            AND lfechada
            AND NOT lpendente
            AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as fechadas 
                  ser  restringido o campo situacao = 2 */
                OPEN QUERY {&QUERYNAME} 
                     FOR EACH  {&TABLENAME} 
                         WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                           AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                           AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                           AND {&TABLENAME}.situacao       = 2 NO-LOCK 
                           BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND lpendente
             AND NOT lcomordem THEN
               /* Quando for parametrizado para mostrar somente as pendentes 
                  ser  restringido o campo situacao = 3 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                            AND {&TABLENAME}.situacao       = 3 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
             ELSE
             IF  NOT laberta
             AND NOT lfechada
             AND NOT lpendente
             AND lcomordem THEN
               /* Quando for parametrizado para mostrar somente as com Ordem 
                  ser  restringido o campo situacao = 4 */
                 OPEN QUERY {&QUERYNAME} 
                      FOR EACH  {&TABLENAME} 
                          WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                            AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                            AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro2) 
                                 OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                            AND {&TABLENAME}.situacao       = 4 NO-LOCK 
                            BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
            ELSE
               /* Quando for qualquer outra combina‡Æo, ser  obrigat¢rio
                  a utiliza‡Æo da cl usula 'OR' no campo situacao */
               OPEN QUERY {&QUERYNAME} 
                    FOR EACH  {&TABLENAME} 
                        WHERE {&TABLENAME}.nr-requisicao >= inr-requisicao-ini 
                          AND {&TABLENAME}.nr-requisicao <= inr-requisicao-fin 
                          AND (   ({&TABLENAME}.tp-requis = ifiltro1) 
                               OR ({&TABLENAME}.tp-requis = ifiltro2) 
                               OR ({&TABLENAME}.tp-requis = ifiltro3)) 
                          AND (   (laberta   AND {&TABLENAME}.situacao = 1) 
                               OR (lfechada  AND {&TABLENAME}.situacao = 2) 
                               OR (lpendente AND {&TABLENAME}.situacao = 3) 
                               OR (lcomordem AND {&TABLENAME}.situacao = 4)) NO-LOCK 
                          BY {&TABLENAME}.nr-requisicao INDEXED-REPOSITION.
       END.

       RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH requisicao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proximaRequisicao DBOProgram 
PROCEDURE proximaRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a pr¢xima requisi‡Æo livre
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao.

    DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

    DISABLE TRIGGERS FOR DUMP OF requisicao.
    DISABLE TRIGGERS FOR DUMP OF param-compra.

    FIND FIRST param-compra NO-LOCK NO-ERROR.
    
    FIND LAST requisicao WHERE
        requisicao.nr-requisicao >= param-compra.prim-solic-man AND
        requisicao.nr-requisicao <= param-compra.ult-solic-man NO-LOCK NO-ERROR.
    
    IF  AVAIL requisicao THEN DO:
        IF  requisicao.nr-requisicao >= 999999999 OR requisicao.nr-requisicao = param-compra.ult-solic-man THEN DO:
            ASSIGN i-cont = param-compra.prim-solic-man.
            REPEAT:
                IF  CAN-FIND(requisicao WHERE requisicao.nr-requisicao = i-cont) THEN DO:
                    ASSIGN  i-cont = i-cont + 1.
                    NEXT.
                END.
                ASSIGN pnr-requisicao = i-cont.
                LEAVE.    
            END. 
        END.
        ELSE
            ASSIGN pnr-requisicao = requisicao.nr-requisicao + 1.
    END.
    ELSE
        ASSIGN pnr-requisicao = param-compra.prim-solic-man.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnHabilitNrRequis DBOProgram 
PROCEDURE returnHabilitNrRequis :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    define output parameter plHabRequis as logical no-undo.

    assign plHabRequis = yes.
    
    find first param-compra no-lock no-error.
    if avail param-compra then do:
        if substring(param-compra.char-2,15,1,"character") <> "Y" then
            assign plHabRequis = no.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRequisicao DBOProgram 
PROCEDURE setConstraintRequisicao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter pcnr-requisicao-ini LIKE requisicao.nr-requisicao no-undo.
    def input parameter pcnr-requisicao-fin LIKE requisicao.nr-requisicao no-undo.
    def input parameter pl-aberta           as logical no-undo.
    def input parameter pl-fechada          as logical no-undo.
    def input parameter pl-pendente         as logical no-undo.
    def input parameter pl-comordem         as logical no-undo.
    def input parameter pifiltro1           as integer no-undo.
    def input parameter pifiltro2           as integer no-undo.
    def input parameter pifiltro3           as integer no-undo.
    
    assign inr-requisicao-ini = pcnr-requisicao-ini
           inr-requisicao-fin = pcnr-requisicao-fin
           laberta            = pl-aberta 
           lfechada           = pl-fechada
           lpendente          = pl-pendente
           lcomordem          = pl-comordem
           ifiltro1           = pifiltro1
           ifiltro2           = pifiltro2
           ifiltro3           = pifiltro3. 
           
                
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateLocalEntrega DBOProgram 
PROCEDURE updateLocalEntrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel   NO-UNDO.
DEFINE INPUT PARAMETER num-req      LIKE requisicao.nr-requisicao NO-UNDO.
DEFINE INPUT PARAMETER loc-entrega  LIKE requisicao.loc-entrega   NO-UNDO.

FOR EACH  {&TABLENAME} 
    WHERE {&TABLENAME}.nr-requisicao = num-req 
    AND   {&TABLENAME}.cod-estabel   = pcod-estabel EXCLUSIVE-LOCK:
    ASSIGN {&TABLENAME}.loc-entrega  = loc-entrega.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    assign cType = pType.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/

    if avail requisicao then
        assign i-tipo-requis-old = requisicao.tp-requis
               c-cod-estabel = RowObject.cod-estabel
               i-tipo-requis = RowObject.tp-requis.

    find first param-global no-lock no-error.
    find first param-compra no-lock no-error.
    find first param-estoq  no-lock no-error.

    if pType = "Create" then do:
        if can-find (requisicao where 
                     requisicao.nr-requisicao = RowObject.nr-requisicao) then do:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i movind requisicao 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters=TRIM(RETURN-VALUE)}
            RETURN "NOK".                            
        end.        
        
        if param-global.modulo-bh and
           can-find (first his-requisicao where
                           his-requisicao.nr-requisicao = RowObject.nr-requisicao) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-historico-requisicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Hist¢rico_Requisi‡Æo" *}
            ASSIGN c-lbl-liter-historico-requisicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4521"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-historico-requisicao"} 
            RETURN "NOK".                                        
        end.
        
        if RowObject.nr-requisicao = 0 then do:
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-requisicaosolicitacao AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Requisi‡Æo/Solicita‡Æo" *}
             ASSIGN c-lbl-liter-requisicaosolicitacao = TRIM(RETURN-VALUE).
             {method/svc/errors/inserr.i &ErrorNumber="2333"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U
                                         &ErrorParameters="c-lbl-liter-requisicaosolicitacao"}           
            RETURN "NOK".                                         
        end.         

        if RowObject.nr-requisicao < param-compra.prim-solic-man or
           RowObject.nr-requisicao > param-compra.ult-solic-man then do:
             {method/svc/errors/inserr.i &ErrorNumber="863"
                                         &ErrorType="EMS":U
                                         &ErrorSubType="ERROR":U
                                         &ErrorParameters="''"}           
            RETURN "NOK".                                         
        end.
    end.
    if pType = "Update" then do:
        if avail requisicao then do:
            if RowObject.tp-requis <> 1 then do:
               for each it-requisicao fields(nr-requisicao it-codigo) where
                   it-requisicao.nr-requisicao = RowObject.nr-requisicao
                   no-lock:
                   for first item fields(it-codigo cod-comprado char-2) where
                      item.it-codigo = it-requisicao.it-codigo 
                      no-lock: end.
                   if avail item and param-compra.int-2 = 2 then do:
                            if can-find(estabelec where 
                                        estabelec.cod-estabel = Rowobject.cod-estabel
                                        no-lock) then
                                 for first item-uni-estab fields(it-codigo cod-estabel cod-comprado ) where
                                      item-uni-estab.it-codigo   = item.it-codigo and
                                      item-uni-estab.cod-estabel = requisicao.cod-estabel 
                                      no-lock: end.
                            if avail item-uni-estab then do:
                                 if not can-find(comprador where 
                                    comprador.cod-comprado = item-uni-estab.cod-comprado 
                                    no-lock) then do:
                                    {method/svc/errors/inserr.i &ErrorNumber="17074"
                                                                &ErrorType="EMS":U
                                                                &ErrorSubType="ERROR":U
                                                                &ErrorParameters="''"}                                 
                                 end.
                            end.
                            else do:
                                 if not can-find(comprador where 
                                    comprador.cod-comprado = item.cod-comprado
                                    no-lock) then do:
                                    {method/svc/errors/inserr.i &ErrorNumber="17074"
                                                                &ErrorType="EMS":U
                                                                &ErrorSubType="ERROR":U
                                                                &ErrorParameters="''"}                                 
                                 end.
                            end.         
                   end.
                   else if avail item and param-compra.int-2 = 1 then do:
                           if can-find(estabelec where 
                              estabelec.cod-estabel = Rowobject.cod-estabel
                              no-lock) then
                           for first item-uni-estab fields(it-codigo cod-estabel cod-grp-compra) where
                                     item-uni-estab.it-codigo   = item.it-codigo                 and
                                     item-uni-estab.cod-estabel = requisicao.cod-estabel
                                     no-lock: end.
                           if avail item-uni-estab then do:
                               for first grupo-compra fields(cod-grp-compra) where
                                         grupo-compra.cod-grp-compra = item-uni-estab.cod-grp-compra
                                         no-lock: end.
                           end.

                           if avail grupo-compra then 
                              for first gr-cmp-comprad fields(cod-grp-compra) where 
                                        gr-cmp-comprad.cod-grp-compra = grupo-compra.cod-grp-compra
                                        no-lock: end.                                                
                          
                           if not avail grupo-compra or not avail gr-cmp-comprad then do:
                                {method/svc/errors/inserr.i &ErrorNumber="16419"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U
                                                            &ErrorParameters="''"}                        
                           end.                          
                      end.        
                   end.
             end.     
            
            if RowObject.tp-requis <> 2 then do:
               if can-find(first it-requisicao where 
                      it-requisicao.nr-requisicao = requisicao.nr-requisicao
                      no-lock) then do:
                  for each it-requisicao fields(nr-requisicao it-codigo) where 
                      it-requisicao.nr-requisicao = requisicao.nr-requisicao
                      no-lock:
                      for first item fields(it-codigo cod-obsoleto) where 
                                item.it-codigo = it-requisicao.it-codigo
                                no-lock: end.
                      if avail item then do:
                            if can-find(estabelec where 
                                        estabelec.cod-estabel = RowObject.cod-estabel
                                        no-lock) then
                            for first item-uni-estab fields(it-codigo cod-estabel cod-obsoleto ) where
                                  item-uni-estab.it-codigo   = item.it-codigo and
                                  item-uni-estab.cod-estabel = requisicao.cod-estabel
                                  no-lock: end.
                            if avail item-uni-estab then do:
                                if item-uni-estab.cod-obsoleto = 3 then do:
                                   {method/svc/errors/inserr.i &ErrorNumber="15834"
                                                               &ErrorType="EMS":U
                                                               &ErrorSubType="ERROR":U
                                                               &ErrorParameters="''"}    
                                 end.
                            end.
                      end.
                  end.
               end.
            end.    
     
            if c-modif-aprovadas = "no" then do: 
                if requisicao.estado = 1 then do:
                   if RowObject.tp-requis = 1 then do:
                     {method/svc/errors/inserr.i &ErrorNumber="19214"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                   end.
                end.
                if requisicao.estado = 1 then do:
                   if RowObject.tp-requis = 2 then do:
                     {method/svc/errors/inserr.i &ErrorNumber="19214"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                   end.
                end.        
            end.
            run validateUpdateRecordRequisicao.
            
                
            run ccp/ccapi642.p (2, rowid(requisicao), 3).
        
           /***  Aprova‡Æo Eletr“nica **************************************************/
        
            if i-tipo-requis <> requisicao.tp-requis then do:       
             
                if  i-tipo-requis = 1 and
                   substr(param-estoq.char-1,4,1) = "Y" and param-compra.log-1  then
                   assign i-tipo-doc = 2.
                else if  i-tipo-requis = 2 and param-compra.log-1 then
                   assign i-tipo-doc = 1.
                else 
                   assign i-tipo-doc = 0.                    
                  
                if i-tipo-doc > 0 then do:
                    for each it-requisicao 
                        where it-requisicao.nr-requisicao = requisicao.nr-requisicao no-lock:
                        run cdp/cdapi173.p (input  i-tipo-doc,
                                            input  it-requisicao.it-codigo,
                                            input  RowObject.nome-abrev,
                                            output l-retorno-aprov).
                        if can-find(funcao where
                             funcao.cd-funcao = "Integra_AED_EMS" and
                             funcao.ativo     = yes) then do:
                             ASSIGN de-valor-item = it-requisicao.val-item
                                    de-valor-total = 0.
              
                             FOR EACH b-it-requisicao WHERE 
                                      b-it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                                    ASSIGN de-valor-total = de-valor-total + b-it-requisicao.val-item.
                             END. 
                             run aedp/aedapi173.p (input i-tipo-doc,
                                                   input it-requisicao.it-codigo,
                                                   input RowObject.nome-abrev,
                                                   input it-requisicao.ct-codigo,
                                                   input RowObject.cod-estabel,
                                                   input it-requisicao.sc-codigo,
                                                   input de-valor-item,
                                                   input de-valor-total,
                                                   input RowObject.cod-estabel,
                                                   output table tt-erro).

                             if  return-value = "NOK":U then do:
                                 find first tt-erro no-error.
                                 if  avail tt-erro then do:
                                     {method/svc/errors/inserr.i
                                                 &ErrorNumber="tt-erro.cd-erro"
                                                 &ErrorType="EMS":U
                                                 &ErrorSubType="ERROR":U
                                                 &ErrorParameters="tt-erro.c-param"}
                                                 
                                       return "nok":U.
                                 end.
                             end.
                        end.
                        RUN lap/mlaapi099.p (INPUT i-tipo-doc).

                        if can-find(funcao where
                             funcao.cd-funcao = "Integra_MLA_EMS" and
                             funcao.ativo     = yes) AND RETURN-VALUE <> "NOK":U then do:
                             ASSIGN de-valor-item = it-requisicao.val-item
                                    de-valor-total = 0.
              
                             FOR EACH b-it-requisicao WHERE 
                                      b-it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                                    ASSIGN de-valor-total = de-valor-total + b-it-requisicao.val-item.
                             END. 
                             run lap/mlaapi173.p (input i-tipo-doc,
                                                   input it-requisicao.it-codigo,
                                                   input RowObject.nome-abrev,
                                                   input it-requisicao.ct-codigo,
                                                   input RowObject.cod-estabel,
                                                   input it-requisicao.sc-codigo,
                                                   input de-valor-item,
                                                   input de-valor-total,
                                                   input RowObject.cod-estabel,
                                                   output table tt-erro).

                             if  return-value = "NOK":U then do:
                                 find first tt-erro no-error.
                                 if  avail tt-erro then do:
                                     {method/svc/errors/inserr.i
                                                 &ErrorNumber="tt-erro.cd-erro"
                                                 &ErrorType="EMS":U
                                                 &ErrorSubType="ERROR":U
                                                 &ErrorParameters="tt-erro.c-param"}
                                                 
                                       return "nok":U.
                                 end.
                             end.
                        end.
                        if not l-retorno-aprov then do:
                             {method/svc/errors/inserr.i &ErrorNumber="15661"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="ERROR":U
                                                        &ErrorParameters="''"}                    
                             return "NOK".                           
                        end.
                    end.    
                end.           
            end.
           /*** Fim  Aprova‡Æo Eletr“nica **************************************************/
        end.
    end.
    IF  pType = "Update":U OR pType = "Delete" THEN DO:
        IF  c-seg-usuario NE RowObject.nome-abrev THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="27706"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U} 
        END.
    END.

    if pType = "Create" or pType = "Update" then do:
        if RowObject.dt-requisicao = ? then do:
            {method/svc/errors/inserr.i &ErrorNumber="173"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}   
           return "NOK".                              
        end.  
        
        find first estabelec where 
             estabelec.cod-estabel = RowObject.cod-estabel
             no-lock no-error. 
        if not avail estabelec then do:
            {method/svc/errors/inserr.i &ErrorNumber="13"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}    
            return "NOK".                            
        end.   
         
        for first usuar-mater fields(cod-usuario usuar-requis usuar-solic tp-preco) where
            usuar-mater.cod-usuario = RowObject.nome-abrev
            no-lock: end.
         
        if not avail usuar-mater then do:
        /* Usu rio de Materiais nÆo cadastrado */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-requisitante AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Requisitante" *}
        ASSIGN c-lbl-liter-requisitante = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter-requisitante"}  
            return "NOK".                         
        end.
        else do:

            if RowObject.tp-requis = 1 and
                not usuar-mater.usuar-requis then do:
                {method/svc/errors/inserr.i &ErrorNumber="15424"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="RowObject.nome-abrev"}
               return "NOK".                             
            end.
            else if RowObject.tp-requis > 1 and
                not usuar-mater.usuar-solic then do:
                {method/svc/errors/inserr.i &ErrorNumber="1083"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}        
                return "NOK".                                            
            end.
        end.
         
        if RowObject.situacao <> 0 then do:  
            if (RowObject.situacao < 1) or 
               (RowObject.situacao > 3) or 
               (RowObject.tp-requis = 1 and 
               RowObject.situacao = 3) then do:
                {method/svc/errors/inserr.i &ErrorNumber="4681"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}   
               return "NOK".                             
           end.
        end.
        
        find first param-compra
            no-lock no-error.
        if not param-compra.log-1 and
            RowObject.tp-requis = 3 then do:
            /** Mensagem: Solicita‡Æo de Cota‡Æo s¢ esta dispon¡vel para aprova‡Æo eletr“nica **/
            {method/svc/errors/inserr.i &ErrorNumber="15563"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}             
            return "NOK".                            
        end.
          
        if  RowObject.tp-requis = 3 and
            param-compra.log-1 and
            substring(param-compra.char-2, 1, 3) = "sim" then do:
          /** Mensagem: Solicita‡Æo de Cota‡Æo nÆo est  dispon¡vel para aprova‡Æo total de documentos **/
            {method/svc/errors/inserr.i &ErrorNumber="17532"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}  
            return "NOK".                            
       end. 
    end.
    
    if pType = "Delete" then do:
        if avail requisicao then do:
           
            find first it-requisicao where 
                 it-requisicao.nr-requisicao = requisicao.nr-requisicao 
                 no-lock no-error.

            /* gera RowErrors */
            run verificaUsuarioMateriais (input rowid(requisicao),
                                          input c-usuario-aux).

            if can-find (first it-requisicao where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                                             and   it-requisicao.qt-atendida <> 0) then do:
                {method/svc/errors/inserr.i &ErrorNumber="17698"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}
                return "NOK".                            
            end.
    
            /**
            ***   Aprova‡Æo Eletr“nica
            **/
            if requisicao.tp-requis = 1 then
                assign i-tipo-doc = 2.
            if requisicao.tp-requis = 2 then do:
                assign i-tipo-doc = 1.
                run ccp/ccapi642.p (2, rowid(requisicao), 3).
            end.
            if requisicao.tp-requis = 3 then
                assign i-tipo-doc = 5.
            find first param-compra
                no-lock no-error.
            for each it-requisicao where
                it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK:
                /*** aprova‡Æo eletr“nica ***/
                if param-compra.log-1 then do:
                    run cdp/cdapi171.p (i-tipo-doc, 3, rowid(it-requisicao)).
                end.
                /***** INVESTIMENTOS *****/
                if  param-global.modulo-in 
                and it-requisicao.num-ord-inv <> 0 then do:
                    run inp/in2101.p(rowid(requisicao), rowid(it-requisicao), "Elimina").
                end.    
                /*************************/
            end.
            find first it-requisicao where
                it-requisicao.nr-requisicao = requisicao.nr-requisicao and
                it-requisicao.qt-atendida > 0
                no-lock no-error.
            if available it-requisicao then do:
                /* mensagem: Item ja possui quantidade atendida, nao pode ser eliminado. */
                {method/svc/errors/inserr.i &ErrorNumber="7542"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U} 
            end.                           
    
            find first ordem-compra where ordem-compra.nr-requisicao = requisicao.nr-requisicao no-lock no-error.
            if avail ordem-compra then do:
                {method/svc/errors/inserr.i &ErrorNumber="8131"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U} 
            end.
    
            find first it-requisicao where 
                it-requisicao.nr-requisicao = requisicao.nr-requisicao and
                it-requisicao.situacao = 4
                no-lock no-error.
            if available it-requisicao then do:
                /* mensagem: Requisicao nao pode ser eliminada. */
                {method/svc/errors/inserr.i &ErrorNumber="6702"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}
            end.
            /** Fim das valida‡„es de elimina‡Æo **/
        end.     
    end.
    IF pType = "Update":U OR pType = "Delete" THEN DO:

        IF  c-seg-usuario NE it-requisicao.nome-abrev THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="27706"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U} 
        END.

    END.
    
    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateUpdateRecordRequisicao DBOProgram 
PROCEDURE validateUpdateRecordRequisicao :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/

    assign c-estab    = ""
           l-val-item = no.           
 
    assign c-estab = requisicao.cod-estabel.
    /* ----- c¢digo da include  cd1406.i1 ---- */  
 
    if RowObject.cod-estabel <> c-estab then do:
        for each it-requisicao fields(nr-requisicao qt-atendida) where 
            it-requisicao.nr-requisicao = requisicao.nr-requisicao
            no-lock:
            if it-requisicao.qt-atendida <> 0 then do:
                {method/svc/errors/inserr.i &ErrorNumber="872"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}  
            end.
        end.
        if requisicao.estado = 1 then do:
            assign requisicao.estado = 2.
            assign l-val-item = yes.
        end.
    end.
 
    if l-val-item = yes then do:
        assign l-val-item = no.
        for each it-requisicao fields(nr-requisicao it-codigo val-item preco-unit qt-a-atender)
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao EXCLUSIVE-LOCK:
            for first item fields(it-codigo tipo-contr preco-ul-ent preco-repos preco-base)
                where item.it-codigo = it-requisicao.it-codigo no-lock: end.
            assign de-preco-unit = 0.
            if item.tipo-contr <> 1 then do:
                assign l-val-item = no.
                for first item-estab fields(it-codigo cod-estabel val-unit-mat-m[1] val-unit-mob-m[1])
                     where item-estab.it-codigo = it-requisicao.it-codigo and
                           item-estab.cod-estabel = requisicao.cod-estabel no-lock: end.
                if not avail item-estab then do:
                   create item-estab.
                   assign item-estab.it-codigo = it-requisicao.it-codigo
                          item-estab.cod-estabel = requisicao.cod-estabel.
                end.
 
                if avail usuar-mater and usuar-mater.tp-preco = 1 then do:
                   assign de-preco-unit = (item-estab.val-unit-mat-m [1] + item-estab.val-unit-mob-m [1]).
                   if de-preco-unit = 0 then do:
                      assign de-preco-unit = item.preco-ul-ent.

                        for first item-uni-estab fields(it-codigo cod-estabel preco-ul-ent) where 
                            item-uni-estab.it-codigo   = item.it-codigo and
                            item-uni-estab.cod-estabel = RowObject.cod-estabel no-lock: end.
                        if avail item-uni-estab then    
                           assign de-preco-unit = item-uni-estab.preco-ul-ent.

                      if de-preco-unit <> 0 then do:
                          assign l-val-item = yes.
                      end.
                      else do:
                          assign de-preco-unit = item.preco-repos.

                            for first item-uni-estab fields(it-codigo cod-estabel preco-repos) where 
                                item-uni-estab.it-codigo   = item.it-codigo and
                                item-uni-estab.cod-estabel = RowObject.cod-estabel no-lock: end.
                            if avail item-uni-estab then    
                               assign de-preco-unit = item-uni-estab.preco-repos.

                          if de-preco-unit <> 0 then do:
                             assign l-val-item = yes.
                          end.
                          else do:
                              assign de-preco-unit = item.preco-base.

                                for first item-uni-estab fields(it-codigo cod-estabel preco-base) where 
                                    item-uni-estab.it-codigo   = item.it-codigo and
                                    item-uni-estab.cod-estabel = RowObject.cod-estabel no-lock: end.
                                if avail item-uni-estab then    
                                   assign de-preco-unit = item-uni-estab.preco-base.

                              if de-preco-unit <> 0 then do:
                                 assign l-val-item = yes.
                              end.
                          end.
                      end.
                   end.
                   assign it-requisicao.val-item = de-preco-unit * it-requisicao.qt-a-atender
                          it-requisicao.preco-unit   = de-preco-unit.                         
 
                end.
            end.
        end.
    end.
 
 
    if RowObject.tp-requis = 2 then do:
        if can-find(first it-requisicao 
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao 
            and   it-requisicao.situacao = 2 no-lock)
        then do:
            {method/svc/errors/inserr.i &ErrorNumber="875"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}  
        end.
    end.
    else 
        if RowObject.tp-requis = 1 then do:
            if can-find(first it-requisicao
                where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                and  (it-requisicao.situacao = 3 or it-requisicao.situacao = 4) no-lock)
            then do:
                {method/svc/errors/inserr.i &ErrorNumber="876"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}  
            end.
        /* Solicita‡Æo de compras com itens sem conta cont bil, d  erro */
 
            for each  it-requisicao fields(nr-requisicao ct-codigo it-codigo)
                 where it-requisicao.nr-requisicao = requisicao.nr-requisicao
                 no-lock:
                if it-requisicao.ct-codigo = " " then do:
                    {method/svc/errors/inserr.i &ErrorNumber="15435"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}  
                end.
                for first item fields(it-codigo tipo-contr)
                    where item.it-codigo = it-requisicao.it-codigo no-lock: end.
                if avail item and item.tipo-contr = 4 then do:
                    {method/svc/errors/inserr.i &ErrorNumber="15483"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}  
                end.
            end.
        end.
 
   /* ******************* c¢digo de depois da include **************** */
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaUsuarioMateriais DBOProgram 
PROCEDURE verificaUsuarioMateriais :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:
------------------------------------------------------------------------------*/
    def input param prRequisicao as rowid no-undo.
    def input param pcUsuario    as char  no-undo.
    
    find requisicao where
         rowid(requisicao) = prRequisicao
         no-lock no-error.
         
    if avail requisicao then do:
        find usuar-mater where 
             usuar-mater.cod-usuario = pcUsuario
             no-lock no-error.

        if requisicao.nome-abrev <> pcUsuario   
        &if defined(bf_mat_aprova_eletronica) &then
        and avail usuar-mater 
        and substring(usuar-mater.char-1,10,01) <> "Y" &endif
        then do:
            {method/svc/errors/inserr.i &ErrorNumber="1514"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="''"}  
             return "NOK".                            
        end.                                            
        else do:
            if avail it-requisicao then do:
                if it-requisicao.situacao = 2 or it-requisicao.situacao = 4 then do:         
                    {method/svc/errors/inserr.i &ErrorNumber="1514"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}  
                    return "NOK".                            
                end.  
            end. 
        end.
    end.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

