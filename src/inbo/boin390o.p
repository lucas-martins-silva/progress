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
{include/i-prgvrs.i BOIN390O 2.00.00.028 } /*** "010028" 27/10/2023 17:03:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin390o MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

{utp/ut-glob.i}
{btb/btb008za.i0}
{cdp/cdcfgmnt.i}
/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN390o
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName reservas
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE NewRecordOffQuery YES

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin390o.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define var iNrOrdProdu  like {&TableName}.nr-ord-produ             no-undo.
define var iOpCodigo    like {&TableName}.op-codigo    init 0      no-undo.
define var iOpCodigoIni like {&TableName}.op-codigo    init 0      no-undo.
define var iOpCodigoFim like {&TableName}.op-codigo    init 99999  no-undo.

define var hDBOAlocReserva as handle no-undo.

/* Tabela para Integraá∆o com o MAGNUS */
def temp-table tt-reservas NO-UNDO
     field nr-ord-produ    as integer         format ">>>,>>>,>>9"
     field it-codigo       as character       format "x(16)"
     field dt-reserva      as date            format "99/99/9999"
     field quant-orig      as decimal         format "->>>>>,>>9.9999"
     field un              as character       format "xx"
     field quant-atend     as decimal         format "->>>>>,>>9.9999"
     field quant-requis    as decimal         format ">>>>>,>>9.9999"
     field tp-atualiza     as integer         format "99"
     field lote-serie      as character       format "x(10)"
     field op-codigo       as integer         format ">>>>9"
     field cod-depos       as character       format "x(3)"
     field emite-requis    as logical         format "Sim/Nao"
     field estado          as integer         format ">9"
     field quant-aloc      as decimal         format "->>>>>,>>9.9999"
     field item-pai        as character       format "x(16)"
     field quant-terc      as decimal         format ">>>>>,>>>9.9999"
     field origem          as integer         format ">9"
     field cod-roteiro     as character       format "x(16)"
     field tipo-sobra      as integer         format ">9"
     field cod-refer       as character       format "x(8)"
     field cd-lubr         as character       format "x(8)"
     field nr-ord-refer    as integer         format ">>>,>>>,>>9"
     field nr-req-sum      as integer         format ">>>,>>>,>>9"
     field cod-localiz     as character       format "x(10)"
     field quant-aplic     as decimal         format ">>>>>,>>9.9999"
     field cons-mrp        as logical         format "Sim/Nao"
     field char-1          as character       format "x(100)"
     field char-2          as character       format "x(100)"
     field dec-1           as decimal         format "->>>>>>>>>>>9.99999999"
     field dec-2           as decimal         format "->>>>>>>>>>>9.99999999"
     field int-1           as integer         format "->>>>>>>>>9"
     field int-2           as integer         format "->>>>>>>>>9"
     field log-1           as logical         format "Sim/Nao"
     field log-2           as logical         format "Sim/Nao"
     field data-1          as date            format "99/99/9999"
     field data-2          as date            format "99/99/9999"
     field check-sum       as character       format "x(20)"
     field cod-lista-compon as character      format "X(16)"
     field num-id-reservas as integer         format ">>>,>>>,>>9".

DEFINE TEMP-TABLE ttReservas NO-UNDO LIKE reservas
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE RowErrorsReserva NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.



{mip/miapi004.i} /** Definiá∆o da temp-table tt-ord-manut-api **/
{mip/integra-mobile.i}

DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

DEFINE BUFFER bf-item-reserva FOR ITEM.

/*DefiniØ o de temp-table para campo extra*/
DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid AS ROWID
    FIELD des-item AS CHAR
    FIELD dtReservaStr AS CHAR.

DEFINE VARIABLE hBoSincroniz        AS HANDLE      NO-UNDO.
DEFINE VARIABLE lTemAlteracao       AS LOGICAL     NO-UNDO.

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
         HEIGHT             = 14.13
         WIDTH              = 40.
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

    if v_log_eai_habilit then do:
       /** Preparaá∆o para adapter de integraá∆o EAI **/
       for each tt-ord-manut-api exclusive-lock:
           delete tt-ord-manut-api.
       end.

       for first ord-manut
           where ord-manut.nr-ord-produ = RowObject.nr-ord-produ no-lock:
       end.

       if avail ord-manut then do:
           create tt-ord-manut-api.
           buffer-copy ord-manut to tt-ord-manut-api.
       end.

       run adapters/xml/mn2/axsmn009.p(input "UPD":U,
                                      input "BOIN390o":U,
                                      input "2.00.00.008":U,
                                      input table tt-ord-manut-api,
                                      output table RowErrors).
    end.

    IF l-mobile THEN DO:
        RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.           
        RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                                INPUT STRING(RowObject.nr-ord-produ),
                                                INPUT 2, /* Update */
                                                INPUT c-seg-usuario).
        DELETE OBJECT hBoSincroniz.
    END.

   return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     for first tt-ord-manut-api no-lock:
     end.

     if avail tt-ord-manut-api then do:
         if v_log_eai_habilit then do:
             run adapters/xml/mn2/axsmn009.p(input "UPD":U,
                                             input "BOIN390o":U,
                                             input "2.00.00.008":U,
                                             input table tt-ord-manut-api,
                                             output table RowErrors).
         end.
     end.

    if not valid-handle (hDBOAlocReserva) then
       run inbo/boin007.p persist set hDBOAlocReserva.
       
    run eliminaAlocReservaReserva in hDBOAlocReserva (input rowObject.nr-ord-produ,
                                                      input rowObject.item-pai,
                                                      input rowObject.cod-roteiro,
                                                      input rowObject.op-codigo,
                                                      input rowObject.it-codigo,
                                                      input rowObject.cod-refer).


    if v_log_eai_habilit and can-find(first tt-ord-manut-api no-lock) then do:
       run adapters/xml/mn2/axsmn009.p(input "DEL":U,
                                       input "BOIN390o":U,
                                       input "2.00.00.008":U,
                                       input table tt-ord-manut-api,
                                       output table RowErrors).

    end.

    IF l-mobile THEN DO:
        RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
        RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                                INPUT STRING(rowObject.nr-ord-produ),
                                                INPUT 2, /* Update */
                                                INPUT c-seg-usuario).
        DELETE OBJECT hBoSincroniz.
    END.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if v_log_eai_habilit then do:
       /** Preparaá∆o para adapter de integraá∆o EAI **/
       for each tt-ord-manut-api exclusive-lock:
           delete tt-ord-manut-api.
       end.

       for first ord-manut
           where ord-manut.nr-ord-produ = RowObject.nr-ord-produ no-lock:
       end.

       if avail ord-manut then do:
           create tt-ord-manut-api.
           buffer-copy ord-manut to tt-ord-manut-api.
       end.

       run adapters/xml/mn2/axsmn009.p(input "UPD":U,
                                      input "BOIN390o":U,
                                      input "2.00.00.008":U,
                                      input table tt-ord-manut-api,
                                      output table RowErrors).
    end.

    IF lTemAlteracao THEN DO:
        RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
        RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                                INPUT STRING(RowObject.nr-ord-produ),
                                                INPUT 2, /* Update */
                                                INPUT c-seg-usuario).
        DELETE OBJECT hBoSincroniz.
    
        ASSIGN lTemAlteracao = NO.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDtReserva DBOProgram 
PROCEDURE atualizaDtReserva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNrOrdem  LIKE reservas.nr-ord-produ.
DEFINE INPUT PARAMETER pDtManut LIKE reservas.dt-reserva.
DEFINE VAR hDBOMiPlItem AS HANDLE NO-UNDO.
DEFINE VAR hDBOPlItCalc AS HANDLE NO-UNDO.


    find first param-global no-lock no-error.

    RUN mnbo/bomn116.p PERSISTENT SET hDBOMiPlItem.
    RUN inbo/boin308o.p PERSISTENT SET hDBOPlItCalc.    
    for each reservas
        where reservas.nr-ord-produ = pNrOrdem
        EXCLUSIVE-LOCK:
       
        assign reservas.dt-reserva = pDtManut.
        if  (param-global.modulo-pl = yes
        or  param-global.modulo-pi = yes)
        and (reservas.estado = 1) then do:
            find first item where
                       item.it-codigo = reservas.it-codigo no-lock no-error.
             if avail item and item.tipo-contr <> 4 then 
             do:
                 RUN atualizaReplaneja IN hDBOMiPlItem(input reservas.it-Codigo).
                 RUN atualizaReplaneja IN hDBOPlItCalc(input reservas.it-Codigo).                 
             end.
        end.
    end.
    RUN destroy IN hDBOMiPlItem.
    RUN destroy IN hDBOPlItCalc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaEstadoReservasOrdem DBOProgram 
PROCEDURE atualizaEstadoReservasOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
DEFINE INPUT PARAMETER pop-codigo LIKE reservas.op-codigo NO-UNDO.
DEFINE INPUT PARAMETER pestado LIKE reservas.estado NO-UNDO.
            
    for each bf{&tableName} where bf{&tableName}.nr-ord-produ = pnr-ord-produ
                            and   bf{&tableName}.op-codigo    = pop-codigo
                            exclusive-lock:
        assign bf{&tableName}.estado = pEstado.
    end.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaReservasSum DBOProgram 
PROCEDURE atualizaReservasSum :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNrOrdSum AS INTEGER NO-UNDO.

DEFINE VARIABLE c-compare AS CHARACTER NO-UNDO.

&if defined (bf_mnt_ems204) &then
    if cQueryUseded = "" then /* Abrir Query para n∆o dar erro ap¢s criaá∆o*/
       RUN OpenQueryStatic IN THIS-PROCEDURE (INPUT "Default":U).
       
     for each agrup-reservas 
              where agrup-reservas.nr-ord-sum = pNrOrdSum EXCLUSIVE-LOCK:
              
       find first agrup-ord-taref 
            where agrup-ord-taref.nr-ord-sum   = pNrOrdSum
              and agrup-ord-taref.nr-ord-produ = agrup-reservas.nr-ord-produ
              and agrup-ord-taref.cd-tarefa    = agrup-reservas.op-codigo 
              no-lock no-error.
       if avail agrup-ord-taref and agrup-ord-taref.nr-ord-princ <> 0             
            and (agrup-ord-taref.cd-tarefa-princ <> agrup-ord-taref.cd-tarefa
             or  agrup-ord-taref.nr-ord-princ    <> agrup-ord-taref.nr-ord-produ)
       then do:
            find first bf{&tableName} where bf{&tableName}.nr-ord-produ = agrup-reservas.nr-ord-produ
                                      and   bf{&tableName}.op-codigo    = agrup-reservas.op-codigo
                                      and   bf{&tablename}.it-codigo    = agrup-reservas.it-codigo
                                      EXCLUSIVE-LOCK no-error.
            if avail bf{&tableName} then 
               assign bf{&tableName}.estado = 2.
            NEXT.   
       end. 
       
       if agrup-reservas.log-1 = no 
          then NEXT.  /* A Reserva n∆o foi alterada */

       RUN emptyRowErrors IN THIS-PROCEDURE.
       RUN emptyRowObject IN THIS-PROCEDURE.
       create rowObject.
       buffer-copy agrup-reservas except log-1 to rowObject.                
       find first bf{&tableName} where bf{&tableName}.nr-ord-produ = agrup-reservas.nr-ord-produ
                                 and   bf{&tableName}.op-codigo    = agrup-reservas.op-codigo
                                 and   bf{&tablename}.it-codigo    = agrup-reservas.it-codigo
                                 EXCLUSIVE-LOCK no-error.
       if avail bf{&tableName} then do:
             RUN repositionRecord IN THIS-PROCEDURE(input rowid(bf{&tableName})).
             /* A criaá∆o deve ser depois do reposition, pois este cria a rowObject com o registro posicionado */
             RUN emptyRowObject IN THIS-PROCEDURE.
             create rowObject.
             buffer-copy agrup-reservas except log-1 to rowObject.             
             RUN setRecord IN THIS-PROCEDURE(input table RowObject).
             RUN updateRecord IN THIS-PROCEDURE. 
       end.   
       else 
          RUN CreateRecord IN THIS-PROCEDURE.   
    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
        
    /*--- Eliminaá∆o dos registros -------*/        
    for each agrup-ord-manut where agrup-ord-manut.nr-ord-sum = pNrOrdSum EXCLUSIVE-LOCK:
        for each {&tableName} where {&tableName}.nr-ord-produ = agrup-ord-manut.nr-ord-produ EXCLUSIVE-LOCK:
            if not can-find(agrup-reservas where agrup-reservas.nr-ord-produ = {&tableName}.nr-ord-produ
                                             and agrup-reservas.op-codigo    = {&tableName}.op-codigo
                                             and agrup-reservas.it-codigo    = {&tablename}.it-codigo)
            then do:  
                 RUN repositionRecord IN THIS-PROCEDURE(input rowid({&tableName})).
                 RUN deleteRecord IN THIS-PROCEDURE.
            end.    
        end.                   
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.    

&endif    
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
    if v_log_eai_habilit then do:
       /** Preparaá∆o para adapter de integraá∆o EAI **/
       for each tt-ord-manut-api exclusive-lock:
           delete tt-ord-manut-api.
       end.

       for first ord-manut
           where ord-manut.nr-ord-produ = RowObject.nr-ord-produ no-lock:
       end.

       if avail ord-manut then do:
           create tt-ord-manut-api.
           buffer-copy ord-manut to tt-ord-manut-api.
       end.
    end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   if valid-handle (hDBOAlocReserva) then 
      run destroy in hDBOAlocReserva.
      
   RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaReservaTarefa DBOProgram 
PROCEDURE copiaReservaTarefa :
/*------------------------------------------------------------------------------
  Purpose: Efetua a copia das Ferramentas da Ordem da Tarefa origem para
           Tarefa destino.    
  Parameters:  Recebe N£mero Ordem de Manutená∆o
               Recebe N£mero Tarefa Origem
               Recebe N£mero Tarefa Destino
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pNrOrdProdu like ord-esp.nr-ord-produ.
define input parameter pTarOrig    like ord-esp.cd-tarefa.
define input parameter pTarDest    like ord-esp.cd-tarefa.

if cQueryUseded = "" then /* Abrir Query para n∆o dar erro ap¢s criaá∆o*/
   RUN OpenQueryStatic IN THIS-PROCEDURE (INPUT "Default":U).
for each bf{&tableName} where
    bf{&tableName}.nr-ord-produ = pNrOrdProdu and
    bf{&tableName}.op-codigo    = pTarOrig no-lock:
    for each rowObject:
       delete rowObject.
    end.
    create rowObject.
    buffer-copy bf{&tableName} except bf{&tableName}.op-codigo to rowObject.
    assign rowObject.op-codigo    = pTarDest
           rowObject.estado       = 1
           rowObject.quant-atend  = 0
           rowObject.quant-aloc   = 0
           rowObject.quant-aplic  = 0
           rowObject.quant-requis = 0
           rowObject.quant-terc   = 0.
    run createRecord in This-procedure.       
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaReservasOperacao DBOProgram 
PROCEDURE eliminaReservasOperacao :
/*------------------------------------------------------------------------------
  Purpose: Elimina todas as reservas da operaá∆o/tarefa informada. Usado quando
           da eliminiá∆o da operaá∆o/tarefa, por isso n∆o verifica quantidade
           antendida.     
  Parameters:  Recebe Ordem
               Recebe Operaá∆o
  Notes:       
------------------------------------------------------------------------------*/
define input parameter iNrOrdProdu  like {&tableName}.nr-ord-produ.
define input parameter iOpCodigo    like {&tableName}.op-codigo.

if not valid-handle (hDBOAlocReserva) then
   run inbo/boin007.p persist set hDBOAlocReserva.

for each bf{&tableName} exclusive-lock
    where bf{&tableName}.nr-ord-produ = iNrOrdProdu
    and   bf{&tableName}.op-codigo    = iOpCodigo :
    run eliminaAlocReservaReserva in hDBOAlocReserva (input bf{&tableName}.nr-ord-produ,
                                                      input bf{&tablename}.item-pai,
                                                      input bf{&tableName}.cod-roteiro,
                                                      input bf{&tableName}.op-codigo,
                                                      input bf{&tablename}.it-codigo,
                                                      input bf{&tableName}.cod-refer).
    delete bf{&tableName}.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaReservasZeradasOrdem DBOProgram 
PROCEDURE eliminaReservasZeradasOrdem :
/*------------------------------------------------------------------------------
  Purpose: Elimina todas as reservas da Ordem informada sem quantidade atendida.
  Parameters:  Recebe Ordem
  Notes:       
------------------------------------------------------------------------------*/
define input parameter iNrOrdProdu  like {&tableName}.nr-ord-produ.

if not valid-handle (hDBOAlocReserva) then
   run inbo/boin007.p persist set hDBOAlocReserva.

for each bf{&tableName} exclusive-lock
    where bf{&tableName}.nr-ord-produ = iNrOrdProdu
    and   bf{&tableName}.quant-atend  <= 0:
    &if defined (bf_mnt_ems204) &then
      /* Se a Tarefa da Ordem for agrupada e n∆o principal n∆o permite eliminaá∆o */
      if can-find (first ord-taref where 
         ord-taref.nr-ord-produ   = bf{&tableName}.nr-ord-produ and
         ord-taref.cd-tarefa      = bf{&tableName}.op-codigo   and
         ord-taref.nr-ord-sum    <> 0 and
         (ord-taref.nr-ord-princ <> 0 or ord-taref.cd-tarefa-princ <> 0) and
         (ord-taref.nr-ord-produ <> ord-taref.nr-ord-princ or
          ord-taref.cd-tarefa    <> ord-taref.cd-tarefa-princ)) then 
         next.
    &endif     
    
    run eliminaAlocReservaReserva in hDBOAlocReserva (input bf{&tableName}.nr-ord-produ,
                                                      input bf{&tablename}.item-pai,
                                                      input bf{&tableName}.cod-roteiro,
                                                      input bf{&tableName}.op-codigo,
                                                      input bf{&tablename}.it-codigo,
                                                      input bf{&tableName}.cod-refer).
  
    delete bf{&tableName}.
end.

RETURN "OK":U.

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
        WHEN "cd-lubr":U THEN ASSIGN pFieldValue = RowObject.cd-lubr.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-lista-compon":U THEN ASSIGN pFieldValue = RowObject.cod-lista-compon.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
          
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-reserva":U THEN ASSIGN pFieldValue = RowObject.dt-reserva.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "quant-aloc":U THEN ASSIGN pFieldValue = RowObject.quant-aloc.
        WHEN "quant-aplic":U THEN ASSIGN pFieldValue = RowObject.quant-aplic.
        WHEN "quant-atend":U THEN ASSIGN pFieldValue = RowObject.quant-atend.
        WHEN "quant-orig":U THEN ASSIGN pFieldValue = RowObject.quant-orig.
        WHEN "quant-requis":U THEN ASSIGN pFieldValue = RowObject.quant-requis.
        WHEN "quant-terc":U THEN ASSIGN pFieldValue = RowObject.quant-terc.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFK DBOProgram 
PROCEDURE getDescFK :
/*------------------------------------------------------------------------------
  Purpose:     Retorna descriá∆o das chaves estrangeiras
  Parameters:  recebe nome da tabela
               recebe chave(s) 
               retorna descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pTableName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pForeignKey AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFKDesc     AS CHARACTER NO-UNDO.
    
    define variable cReturn    as char init "NOK":U no-undo.

    case pTableName:
        when "ord-manut":U then do:
           find first ord-manut where ord-manut.nr-ord-produ = int(pForeignKey)
                no-lock no-error.
           if avail ord-manut then
              assign pFKDesc = ord-manut.des-man-corr
                     cReturn = "OK":U.     
        end.
        
        when "ord-taref":U then do:
           find first ord-taref where 
                ord-taref.nr-ord-produ = int(entry(1, pForeignKey, chr(10))) and
                ord-taref.cd-tarefa    = int(entry(2, pForeignKey, chr(10))) no-lock no-error.
           if avail ord-taref then
              assign pFKDesc = ord-taref.descricao
                     cReturn = "OK":U.     
        end.        

        when "item":U then do:
           find first item where item.it-codigo = pForeignKey
                no-lock no-error.
           if avail item then
              assign pFKDesc = item.desc-item
                     cReturn = "OK":U.     
        end.        
        
        when "deposito":U then do:
           find first deposito where deposito.cod-depos = pForeignKey
                no-lock no-error.
           if avail deposito then
              assign pFKDesc = deposito.nome
                     cReturn = "OK":U.     
        end.        

        when "ref-item":U then do:
           find first item where item.it-codigo = entry(1, pForeignKey, chr(10))
                no-lock no-error.
           if avail item then do: 
              find first ref-item where ref-item.it-codigo = item.it-codigo 
                                  and   ref-item.cod-refer = entry(2, pForeignKey, chr(10)) no-lock no-error.
              if avail ref-item and item.tipo-con-est = 4 then do:
                 find first referencia where referencia.cod-refer = entry(2, pForeignKey, chr(10))
                      no-lock no-error.
                 if avail referencia then
                    assign pFKDesc = referencia.descricao
                           cReturn = "OK":U.
              end.      
           end.        
        end.        

        when "form-lubrif":U then do:
           find first form-lubrif where form-lubrif.cd-lubr = pForeignKey
                no-lock no-error.
           if avail form-lubrif then
              assign pFKDesc = form-lubrif.descricao
                     cReturn = "OK":U.     
        end.        

        when "localizacao":U then do:
           find first localizacao where 
                localizacao.cod-estabel = entry(1, pForeignKey, chr(10)) and
                localizacao.cod-depos   = entry(2, pForeignKey, chr(10)) and
                localizacao.cod-localiz = entry(3, pForeignKey, chr(10))
                no-lock no-error.
           if avail localizacao then
              assign pFKDesc = localizacao.descricao
                     cReturn = "OK":U.     
        end.        

    END CASE.

    RETURN cReturn.
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
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "num-id-reservas":U THEN ASSIGN pFieldValue = RowObject.num-id-reservas.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "tipo-sobra":U THEN ASSIGN pFieldValue = RowObject.tipo-sobra.
        WHEN "tp-atualiza":U THEN ASSIGN pFieldValue = RowObject.tp-atualiza.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice operacao
  Parameters:  
               retorna valor do campo nr-ord-produ
               retorna valor do campo item-pai
               retorna valor do campo cod-roteiro
               retorna valor do campo op-codigo
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pitem-pai LIKE reservas.item-pai NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-roteiro LIKE reservas.cod-roteiro NO-UNDO.
    DEFINE OUTPUT PARAMETER pop-codigo LIKE reservas.op-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE reservas.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE reservas.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ
           pitem-pai = RowObject.item-pai
           pcod-roteiro = RowObject.cod-roteiro
           pop-codigo = RowObject.op-codigo
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer.

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
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
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
  Purpose:     Reposiciona registro com base no °ndice operacao
  Parameters:  
               recebe valor do campo nr-ord-produ
               recebe valor do campo item-pai
               recebe valor do campo cod-roteiro
               recebe valor do campo op-codigo
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pitem-pai LIKE reservas.item-pai NO-UNDO.
    DEFINE INPUT PARAMETER pcod-roteiro LIKE reservas.cod-roteiro NO-UNDO.
    DEFINE INPUT PARAMETER pop-codigo LIKE reservas.op-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE reservas.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE reservas.cod-refer NO-UNDO.

    FIND FIRST bfreservas WHERE 
        bfreservas.nr-ord-produ = pnr-ord-produ AND 
        bfreservas.item-pai = pitem-pai AND 
        bfreservas.cod-roteiro = pcod-roteiro AND 
        bfreservas.op-codigo = pop-codigo AND 
        bfreservas.it-codigo = pit-codigo AND 
        bfreservas.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreservas THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreservas)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdProd DBOProgram 
PROCEDURE linkToOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT iNrOrdProdu).
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdTaref DBOProgram 
PROCEDURE linkToOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT iNrOrdProdu, OUTPUT iOpCodigo).
   
   RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&tableName} NO-LOCK.
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdManut DBOProgram 
PROCEDURE openQueryOrdManut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} 
       FOR EACH {&tableName} NO-LOCK
           WHERE {&tableName}.nr-ord-produ  = iNrOrdProdu
           AND   {&tableName}.op-codigo    >= iOpCodigoIni
           AND   {&tableName}.op-codigo    <= iOpCodigoFim 
       BY {&tableName}.op-codigo
       BY {&tablename}.it-codigo.
           
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdTaref DBOProgram 
PROCEDURE openQueryOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} 
         FOR EACH {&tableName} 
             WHERE {&tableName}.nr-ord-produ = iNrOrdProdu
             AND   {&tableName}.op-codigo    = iOpCodigo   NO-LOCK.
             
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE piSetaDados:
    DEFINE INPUT PARAM pNrOrdProdu AS INTEGER NO-UNDO.

    ASSIGN iNrOrdProdu = pNrOrdProdu.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaReserva DBOProgram 
PROCEDURE piCriaReserva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hDBOReservas AS HANDLE NO-UNDO.

    DEFINE INPUT  PARAMETER TABLE FOR ttReservas.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrorsReserva.


    IF NOT VALID-HANDLE(hDBOReservas) OR
        hDBOReservas:TYPE <> "PROCEDURE":U OR
        hDBOReservas:FILE-NAME <> "inbo/boin390o.p":U THEN DO:
        RUN inbo/boin390o.p PERSISTENT SET hDBOReservas.
    END.

    RUN openQueryStatic IN hDBOReservas (INPUT "OrdManut":U).
    EMPTY TEMP-TABLE RowErrorsReserva.

    FOR EACH ttReservas NO-LOCK:

        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN hDBOReservas.
        /*--- Transfere temp-table tt-requisicao para o DBO ---*/
        RUN setRecord IN hDBOReservas (INPUT TABLE ttReservas).
        /*--- Altera o registro corrente do DBO ---*/
        RUN createRecord IN hDBOReservas.
        /*--- Verifica ocorrencia de erros durante a transacao ---*/
        IF RETURN-VALUE = "NOK":U THEN DO:
            /*--- Retorna temp-table RowErrors do DBO ---*/
            RUN getRowErrors IN hDBOReservas (OUTPUT TABLE RowErrorsReserva).
            /** Elimina todos os erros intrnos da BO (NavegaØ o) **/
            FOR EACH  RowErrorsReserva
                WHERE RowErrorsReserva.ErrorSubType = "INTERNAL":U EXCLUSIVE-LOCK:
                DELETE RowErrorsReserva.
            END.
        END.

    END.
    IF VALID-HANDLE(hDBOReservas) THEN
        RUN destroy IN hDBOReservas.

    /*  Se possui Erro Retorna NOK */
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOperacoes DBOProgram 
PROCEDURE setConstraintOperacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pOpCodigoIni like {&tableName}.op-codigo no-undo.
define input parameter pOpCodigoFim like {&tableName}.op-codigo no-undo.

assign iOpCodigoIni = pOpCodigoIni
       iOpCodigoFim = pOpCodigoFim.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdProd DBOProgram 
PROCEDURE setConstraintOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pNrOrdProdu like {&tableName}.nr-ord-produ no-undo.

assign iNrOrdProdu = pNrOrdProdu.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdTaref DBOProgram 
PROCEDURE setConstraintOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter pNrOrdProdu like {&tableName}.nr-ord-produ no-undo.
define input parameter pOpCodigo   like {&tableName}.op-codigo    no-undo.

assign iNrOrdProdu = pNrOrdProdu
       iOpCodigo   = pOpCodigo.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
   
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-reservas AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Reservas" *}
    ASSIGN c-lbl-liter-reservas = TRIM(RETURN-VALUE).

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-ordem-de-manutencao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Ordem_de_Manutenªío" *}
    ASSIGN c-lbl-liter-ordem-de-manutencao = TRIM(RETURN-VALUE).

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-forma-lubrificacao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Forma_Lubrificaªío" *}
    ASSIGN c-lbl-liter-forma-lubrificacao = TRIM(RETURN-VALUE).

    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Item" *}
    ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).

  &if defined (bf_mnt_ems204) &then
    /* Se a Tarefa da Ordem for agrupada e n∆o principal n∆o permite manutená∆o */
    define var cType as char no-undo.
    find first ord-taref where ord-taref.nr-ord-produ = rowObject.nr-ord-produ and
         ord-taref.cd-tarefa = rowObject.op-codigo no-lock no-error.
    if avail ord-taref then 
       if ord-taref.nr-ord-sum <> 0 and
          (ord-taref.nr-ord-princ <> 0 or ord-taref.cd-tarefa-princ <> 0) and
          (ord-taref.nr-ord-produ <> ord-taref.nr-ord-princ or
           ord-taref.cd-tarefa    <> ord-taref.cd-tarefa-princ)           then do:

           IF pType = "Create":U THEN DO:
                {utp/ut-liter.i "Inclus∆o" *}
                ASSIGN cType = TRIM(RETURN-VALUE).
           END.
           ELSE DO:
               IF pType = "Update":U THEN DO:
                   {utp/ut-liter.i "Alteraá∆o" *}
                   ASSIGN cType = TRIM(RETURN-VALUE).
               END.
               ELSE DO:
                   IF pType = "Delete":U THEN DO:
                       {utp/ut-liter.i "Eliminaá∆o" *}
                       ASSIGN cType = TRIM(RETURN-VALUE).
                   END.
               END.
           END.

           {method/svc/errors/inserr.i
                    &ErrorNumber="25156"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="cType + '~~~~' + c-lbl-liter-reservas"} 

           RETURN "NOK":U.          
       end.   
  &endif

    if pType = "Create":U then do:
       if can-find (reservas where 
                    reservas.nr-ord-produ  = rowObject.nr-ord-produ and
                    reservas.op-codigo     = rowObject.op-codigo    and
                    reservas.it-codigo     = rowObject.it-codigo)   then do:

          {method/svc/errors/inserr.i
                  &ErrorNumber="1"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-reservas"}
       end.             
 
       if rowObject.op-codigo <> 0 then do:
          find first ord-taref
               where ord-taref.nr-ord-produ  = rowObject.nr-ord-produ
               and   ord-taref.cd-tarefa     = rowObject.op-codigo no-lock no-error.
          if not avail ord-taref then do:
             {method/svc/errors/inserr.i
                  &ErrorNumber="4308"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="''"}
          end.
       end.
 
       find first item
           where item.it-codigo = rowObject.it-codigo no-lock no-error.
       if not avail item then do:
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-item"}
                  
       end.
       else do:    
          if item.cod-obsoleto = 4 then do: /* Totalmente Obsoleto */

              {method/svc/errors/inserr.i
                      &ErrorNumber="2585"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="item.it-codigo + '~~~~' + c-lbl-liter-reservas"} /*erro esta aki*/
          end.
   
          if item.tipo-requis = 3 then do: /* DÇbito GGF */
             {method/svc/errors/inserr.i
                     &ErrorNumber="1675"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
          end.
    
          if item.tipo-contr = 4 then do: /* DÇbito Direto */
            {method/svc/errors/inserr.i
                     &ErrorNumber="1673"
                      &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
          end.
       end.
    end.
    
    if pType = "Create":U or pType = "Update":U then do:
       find first ord-manut where ord-manut.nr-ord-produ = rowObject.nr-ord-produ
            no-lock no-error.
       if not avail ord-manut then do: 
           {method/svc/errors/inserr.i
                  &ErrorNumber="2"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-ordem-de-manutencao"}

       end.  

       /*******  N∆o far† mais a validaá∆o da data da ordem ********
       else 
          if rowObject.dt-reserva < ord-manut.dt-manut or
             rowObject.dt-reserva > ord-manut.dt-prev  then do:
             {method/svc/errors/inserr.i
                     &ErrorNumber="1692"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="string(ord-manut.dt-manut) + '~~~~' + string(ord-manut.dt-prev)"}
          end.
       ********/
           
       if not can-find (first deposito where 
                        deposito.cod-depos = rowObject.cod-depos) then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="530"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
       end. 
       if rowObject.quant-orig = 0 then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="1570"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
       end. 
       find first item
            where item.it-codigo = rowObject.it-codigo no-lock no-error.
       if avail item and not(item.fraciona) and
          rowObject.quant-orig <> integer(rowObject.quant-orig) then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="1892"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
       end.
       if rowObject.cd-lubr <> "" and 
          not can-find (first form-lubrif where form-lubrif.cd-lubr = rowObject.cd-lubr) then do:
           {method/svc/errors/inserr.i
                  &ErrorNumber="56"
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-forma-lubrificacao"}

       end.
       if rowObject.quant-orig < rowObject.quant-atend then do:
           {method/svc/errors/inserr.i
                  &ErrorNumber="1898" /* Quantidade Atendida maior que a Quantidade Original */
                  &ErrorType="EMS"
                  &ErrorSubType="ERROR"
                  &ErrorParameters="c-lbl-liter-forma-lubrificacao"}

       end.
	   
       if avail ord-manut then
           find first item-uni-estab NO-LOCK where item-uni-estab.it-codigo = rowObject.it-codigo and item-uni-estab.cod-estabel = ord-manut.cod-estabel NO-ERROR.
       
       if ((not avail item-uni-estab and avail item and not item.loc-unica) or (avail item-uni-estab and not item-uni-estab.loc-unica)) and avail ord-manut then
          if not can-find (first localizacao
                           where localizacao.cod-localiz = rowObject.cod-localiz
                           and   localizacao.cod-depos   = rowObject.cod-depos
                           and   localizacao.cod-estabel = ord-manut.cod-estabel) then do:
             {method/svc/errors/inserr.i
                     &ErrorNumber="15811" 
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="rowObject.cod-depos + '~~~~' + ord-manut.cod-estabel + '~~~~' + rowObject.cod-localiz"}
          end.                         

 
       if avail item and item.tipo-con-est = 4 then 
          if not can-find (first ref-item use-index item
                           where ref-item.it-codigo = rowObject.it-codigo
                           and   ref-item.cod-refer = rowObject.cod-refer) then do:
             {method/svc/errors/inserr.i
                     &ErrorNumber="529" 
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
          end.
       find first param-mi no-lock no-error.
       if avail param-mi then
          assign rowObject.item-pai = param-mi.it-codigo. 
       
       if rowObject.cod-localiz = "" then do:
           if avail item-uni-estab and item-uni-estab.loc-unica = yes then
               assign rowObject.cod-localiz = item-uni-estab.cod-localiz.
           else
               if avail item and item.loc-unica = yes then
                   assign rowObject.cod-localiz = item.cod-localiz.
       end.
   end.

   if pType = "Update":U then 
       if rowObject.quant-atend + 
          rowObject.quant-aloc  +
          rowObject.quant-terc  > rowObject.quant-orig  then do:
          {method/svc/errors/inserr.i
                     &ErrorNumber="19538"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="''"}
       end.   


    if pType = "Delete":U then do:
       if rowObject.quant-atend > 0 then do:
          {method/svc/errors/inserr.i
                      &ErrorNumber="1757"
                      &ErrorType="EMS"
                      &ErrorSubType="ERROR"
                      &ErrorParameters="''"}
       end.   
    end.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE getRowObjectExtra:
    /*------------------------------------------------------------------------------
      Purpose:     getRowObjectExtra 
      Parameters:  RowObjectExtra
      Notes:       Retorna temp-table para campo extra
    ------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE afterCopyBuffer2TT:
    /*------------------------------------------------------------------------------
      Purpose:     afterCopyBuffer2TT
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName}).
    
    FOR EACH bf-item-reserva FIELDS (desc-item) NO-LOCK
        WHERE bf-item-reserva.it-codigo = {&TableName}.it-codigo:
        ASSIGN RowObjectExtra.des-item = bf-item-reserva.desc-item.
    END.

    ASSIGN RowObjectExtra.dtReservaStr = STRING({&TableName}.dt-reserva, "99/99/9999").
    
    RETURN "OK":U.
END.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    IF l-mobile THEN DO:
        FOR FIRST bf{&tableName} 
            WHERE bf{&TableName}.nr-ord-produ = RowObject.nr-ord-produ
              AND bf{&tableName}.op-codigo    = RowObject.op-codigo 
              AND bf{&tableName}.it-codigo    = RowObject.it-codigo NO-LOCK:
            
            IF  bf{&tableName}.quant-orig <> RowObject.quant-orig OR
                bf{&tableName}.cod-refer  <> RowObject.cod-refer OR
                bf{&tableName}.lote-serie <> RowObject.lote-serie THEN DO:
                ASSIGN lTemAlteracao = YES.
            END.                      
        END.
    END.
    
    RETURN "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
