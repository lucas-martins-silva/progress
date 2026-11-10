/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBODI317 2.00.00.004 } /*** 010004 ***/

/*****************************************************************/
/* UPC-BODI317                                                   */
/*****************************************************************/
{utp/ut-glob.i}
{include/i-epc200.i "bodi317":U}

def input        param p-ind-event as char no-undo.
def input-output param table for tt-epc.
def var hDBOwt-Docto       as handle no-undo.
def var hDBOwt-Nota-fiscal as handle no-undo.

DEF NEW GLOBAL SHARED VAR c-Contrato-ft4003          LIKE gg-contrato.cod-contrato.

def temp-table tt-erro-retorno no-undo       
    field i-sequen  as int                   
    field cd-erro   as int                   
    field desc-erro as char format "x(255)". 

def temp-table RowErrors no-undo
    field ErrorSequence    as int
    field ErrorNumber      as int
    field ErrorDescription as char
    field ErrorParameters  as char
    field ErrorType        as char
    field ErrorHelp        as char
    field ErrorSubType     as char.
    
def VAR p-row-ped-venda as rowid no-undo.
/**************************************************/

/**** Encontra o evento correto *****/
if  p-ind-event = 'AfterupdateRecord':U then do:

    /**** encontra o registro wt-docto **
    IF  c-seg-usuario = "datasul" THEN
        FOR EACH tt-epc NO-LOCK:
            MESSAGE "Para:  " tt-epc.cod-parameter  SKIP
                    "Valor: " tt-epc.val-parameter .
    END. **/

    FIND FIRST tt-epc NO-LOCK
        WHERE tt-epc.cod-parameter = "Object-Handle":U NO-ERROR.
    IF  AVAIL tt-epc THEN
        ASSIGN hDBOwt-Docto = widget-handle(tt-epc.val-parameter).
             
    FIND FIRST tt-epc 
        WHERE tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.
    
    IF  AVAIL tt-epc THEN DO:
        
        FIND FIRST wt-docto
             WHERE ROWID(wt-docto) = TO-ROWID(tt-epc.val-parameter) NO-LOCK NO-ERROR.
        IF  AVAIL wt-docto THEN DO:
            
            
            FIND FIRST gg-contrato NO-LOCK 
                WHERE gg-contrato.ep-codigo    = i-ep-codigo-usuario
                  AND gg-contrato.cod-contrato = c-Contrato-ft4003 NO-ERROR.
            /*
            find first gg-ext-nota-fiscal EXCLUSIVE-LOCK USE-INDEX ch-nota
                WHERE gg-ext-nota-fiscal.cod-estabel = wt-docto.cod-estabel 
                  AND gg-ext-nota-fiscal.serie       = wt-docto.serie      
                  AND gg-ext-nota-fiscal.nr-nota-fis = wt-docto.nr-nota NO-ERROR.          
            IF  NOT AVAIL gg-ext-nota-fiscal THEN DO:
                CREATE gg-ext-nota-fiscal.
                ASSIGN gg-ext-nota-fiscal.cod-estabel    = wt-docto.cod-estabel
                       gg-ext-nota-fiscal.serie          = wt-docto.serie      
                       gg-ext-nota-fiscal.nr-nota-fis    = wt-docto.nr-nota
                       gg-ext-nota-fiscal.cod_unid_negoc = IF AVAIL gg-contrato THEN gg-contrato.cod-contrato ELSE ""
                       gg-ext-nota-fiscal.cod-contrato   = c-Contrato-ft4003.   
            END.
            ELSE
                ASSIGN gg-ext-nota-fiscal.cod_unid_negoc = IF AVAIL gg-contrato THEN gg-contrato.cod-contrato ELSE ""
                       gg-ext-nota-fiscal.cod-contrato   = c-Contrato-ft4003.    
            */
            
            /* Gera‡Æo Ficha de CQ */
            
            FIND FIRST nota-fiscal NO-LOCK 
                WHERE nota-fiscal.cod-estabel = wt-docto.cod-estabel
                  AND nota-fiscal.serie       = wt-docto.serie
                  AND nota-fiscal.nr-nota-fis = wt-docto.nr-nota      NO-ERROR.           
            IF  AVAIL nota-fiscal THEN DO:
            
                /*RUN ggp/ggapi007b.p (INPUT ROWID(wt-docto), 
                                     INPUT "Saida",
                                     INPUT-OUTPUT TABLE tt-erro-retorno).
                */
                /* Classifica‡Æo wt-docto para nota-fiscal */
                
                FOR each gg-classifica EXCLUSIVE-LOCK                        
                   WHERE gg-classifica.des-tipo-docto  = "wt-docto":U 
                     AND gg-classifica.num-docto       = STRING(wt-docto.seq-wt-docto):
                     
                     ASSIGN  gg-classifica.des-tipo-docto = "nota-fiscal":U 
                             gg-classifica.cod-estabel    = wt-docto.cod-estabel  
                             gg-classifica.num-docto      = wt-docto.nr-nota
                             gg-classifica.serie          = wt-docto.serie. 
                END.
            END.
        END.
    END.
END.  

