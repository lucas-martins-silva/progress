/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE1001C2 2.00.00.003 } /*** 010003 ***/


/**************************************************************************
**    Programa.:  GGRE1001c2 
**    Objetivo.:  UPC para altera o valor do imposto da duplicata 
**    Data.....:  Setembro/2003
***************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
define input parameter p-ind-event               as character      no-undo.
define input parameter p-ind-object              as character      no-undo.
define input parameter p-wgh-object              as handle         no-undo.
define input parameter p-wgh-frame               as widget-handle  no-undo.
define input parameter p-cod-table               as character      no-undo.
define input parameter p-row-table               as rowid          no-undo.

/******************** Defini‡Æo de Vari veis Locais **********************/
Define var  c-char                                     as char           no-undo.
DEFINE VAR  h-ggapi118                                 AS HANDLE         NO-UNDO.
DEFINE VAR  p-impto-por-peso                           AS LOG                        NO-UNDO.
DEFINE VAR  p-data-ini                                 LIKE gg-tipo-tax.dat-fim-val  no-undo.
DEFINE VAR  p-data-fim                                 LIKE gg-tipo-tax.dat-ini-val  no-undo.
DEFINE VAR  p-val-impto                                LIKE gg-tipo-tax.val-imposto  NO-UNDO.
/******************** Vari veis para aumentar a window *******************/
{utp/ut-glob.i}


DEF BUFFER b-docum-est    FOR docum-est.
DEF BUFFER b-item-doc-est FOR item-doc-est.

DEF VAR  total-peso-nota AS DECIMAL.
/************************** TempTables ************************************/
{ggp/ggapi118.i}

/************************** In¡cio do Programa ***************************/
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/":U), p-wgh-object:file-name,"~/":U) NO-ERROR.

/*Start Api*/
IF NOT VALID-HANDLE(h-ggapi118) THEN
   RUN ggp/ggapi118.p PERSISTENT SET h-ggapi118.   


/***
 MESSAGE "GGRE1001C2" SKIP
         "Evento ...:"   p-ind-event   SKIP
         "Objeto ...:"   p-ind-object  SKIP
         "HObjeto...:"   p-wgh-object  SKIP
         "hFrame ...:"   p-wgh-frame   SKIP
         "Tabela ...:"   p-cod-table   SKIP
         "Rowid  ...:"   string(p-row-table)   SKIP
         "NomeObjeto:"   c-char        VIEW-AS ALERT-BOX.
   ***/   

IF p-ind-event  = "after-assign":U THEN DO:

   FIND FIRST dupli-imp NO-LOCK 
        WHERE ROWID(dupli-imp) = p-row-table NO-ERROR.
   
   IF AVAIL dupli-imp THEN DO:
   
      FIND FIRST b-docum-est NO-LOCK
           WHERE b-docum-est.serie-docto  = dupli-imp.serie-docto 
             AND b-docum-est.nro-docto    = dupli-imp.nro-docto   
             AND b-docum-est.cod-emitente = dupli-imp.cod-emitente
             AND b-docum-est.nat-operacao = dupli-imp.nat-operacao NO-ERROR.
      
      IF  AVAIL b-docum-est THEN DO:
        
        FIND FIRST b-item-doc-est OF b-docum-est NO-LOCK NO-ERROR.
          
        /* nao precise mais ler a tipo-tax */
        IF AVAIL b-item-doc-est THEN DO:
        
            RUN pi-ler-gg-tipo-tax IN h-ggapi118 (INPUT 2 , 
                                                  INPUT b-docum-est.cod-estabel,
                                                  INPUT b-docum-est.pais,
                                                  INPUT ' ',
                                                  INPUT b-docum-est.uf, 
                                                  INPUT dupli-imp.int-1, 
                                                  INPUT b-item-doc-est.it-codigo,
                                                  INPUT b-docum-est.dt-emissao  ,
                                                  OUTPUT p-impto-por-peso ,
                                                  OUTPUT p-data-ini       ,
                                                  OUTPUT p-data-fim       ,
                                                  OUTPUT p-val-impto ).
            IF p-val-impto > 0 THEN DO:  

                ASSIGN total-peso-nota = 0.
                
                FOR EACH item-doc-est NO-LOCK
                    WHERE item-doc-est.serie-docto  = dupli-imp.serie-docto 
                    AND item-doc-est.nro-docto    = dupli-imp.nro-docto   
                    AND item-doc-est.cod-emitente = dupli-imp.cod-emitente
                    AND item-doc-est.nat-operacao = dupli-imp.nat-operacao:
                    
                    ASSIGN total-peso-nota = total-peso-nota + item-doc-est.peso-liquido.
                
                END.
    
                FIND FIRST dupli-apagar NO-LOCK
                     WHERE dupli-apagar.serie-docto  = dupli-imp.serie-docto 
                     AND dupli-apagar.nro-docto    = dupli-imp.nro-docto   
                     AND dupli-apagar.cod-emitente = dupli-imp.cod-emitente
                     AND dupli-apagar.nat-operacao = dupli-imp.nat-operacao 
                     AND dupli-apagar.parcela      = dupli-imp.parcela NO-ERROR.

                IF AVAIL dupli-apagar THEN DO:

                    FIND current dupli-imp EXCLUSIVE-LOCK NO-ERROR. 
    
                    ASSIGN dupli-imp.vl-imposto = (total-peso-nota / 1000) * p-val-impto.
                           dupli-imp.aliquota   = (dupli-imp.vl-imposto * 100) / dupli-apagar.vl-a-pagar.
    
                    FIND CURRENT dupli-imp NO-LOCK NO-ERROR.
                END.
            END.
        END.
      END.
   END.
END.

/*delete handle*/
IF VALID-HANDLE(h-ggapi118) THEN DO:
       DELETE PROCEDURE h-ggapi118.
END.
               
 
