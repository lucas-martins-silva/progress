&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0803 2.00.00.005 } /*** "010005" 22/01/2024 17:00:34  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0803 MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: ab0803.p
**
**       DATA....: Fevereiro de 2004
**
**       AUTOR...: Carlos Xavier  - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Criar tabela "espelho" de b-movto para Sistema de Manuten‡Æo de Frota
**
*****************************************************************************/
{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgman.i}
{include/i-epc200.i ab0803} 
/* ***************************  Definitions  ************************** */

/** Defini‡Æo de Parƒmetros -----------------**/

define param buffer b-movto  for movto-estoq.   
Define input param iTipo   as integer.



/** Defini‡Æo de Buffers --------------------**/

/** Defini‡Æo de Vari veis -----------------**/
def var data-aux as date.
def var valor-unitario1 as decimal decimals 4.
def var valor-unitario2 as decimal decimals 4.
def var valor-unitario3 as decimal decimals 4.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.83
         WIDTH              = 31.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

run piinicializacao in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piInicializacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicializacao Procedure 
PROCEDURE piInicializacao :
/*------------------------------------------------------------------------------
Purpose:     piInicializacao
Parameters:  <none>
Notes:       Cria tabela mmv-movto-mater conforme b-movto 
             (somente para registros ligados a uma ordem de produ‡Æo)
------------------------------------------------------------------------------*/
define variable lAltera as logical no-undo.

assign lAltera = no.

/* Rotina Que excluir movimento de materiais no sistema de Frotas */
if iTipo = 2  then do:  /* ExclusÆo dos Registros */

    for each  mmv-movto-mater 
        where mmv-movto-mater.nr-trans = b-movto.nr-trans exclusive-lock:
        delete mmv-movto-mater.
    end.
    return.
end.

/*-----------------------------------------------------------------------------------------------*/
/* Quando for movimento diferente de Requisi‡äes (manuais ou eletr“nicas, DIVs ou Notas Fiscais  */
/* o programa ir  ignorar o movimento, para nÆo gerar no hist¢rico de movimenta‡äes de materiais */
/* Esp‚cies do tipo "ACA", e outras geradas automaticamente pelo fechamento do m‚dio.            */
/*---------------------------------------------------------------------------------------------*/

If b-movto.esp-docto <> 05 and
   b-movto.esp-docto <> 06 and
   b-movto.esp-docto <> 07 and
   b-movto.esp-docto <> 14 and
   b-movto.esp-docto <> 20 and
   b-movto.esp-docto <> 21 and
   b-movto.esp-docto <> 22 and
   b-movto.esp-docto <> 28 and
   b-movto.esp-docto <> 30 then return.

If not can-find(first mmv-ord-manut where mmv-ord-manut.nr-ord-prod = b-movto.nr-ord-prod) then return.

for first mmv-ord-manut where mmv-ord-manut.nr-ord-prod = b-movto.nr-ord-prod exclusive-lock: 
    /* Atualiza estado da Ordem quando "NÆo Iniciada" */
    if mmv-ord-manut.estado = 1 then assign mmv-ord-manut.estado = 6.
end.


if not avail mmv-movto-mater then do:
  Create mmv-movto-mater.
  Assign mmv-movto-mater.nr-trans    = b-movto.nr-trans
         Mmv-movto-mater.nr-ord-prod = b-movto.nr-ord-prod
         Mmv-movto-mater.dat-movto   = b-movto.dt-trans.
end.
IF b-movto.esp-docto = 07 OR b-movto.esp-docto = 30 THEN DO:
  find first param-global no-lock no-error.  
  IF avail param-global AND param-global.modulo-cs THEN DO:
     FOR FIRST movto-mat
         WHERE movto-mat.nr-ord-produ = b-movto.nr-ord-produ
           and movto-mat.num-sequen   = b-movto.num-sequen  
           AND movto-mat.esp-docto    = b-movto.esp-docto   
           AND movto-mat.tipo-trans   = b-movto.tipo-trans   NO-LOCK:
          FOR FIRST req-ord-produc   
              WHERE req-ord-produc.nr-requisicao = INT(b-movto.nro-docto)
              &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
              AND req-ord-produc.sequencia = movto-mat.num-seq-req
              &ELSE     
              AND req-ord-produc.sequencia = movto-mat.int-1                                  
              &ENDIF                                      
              NO-LOCK:
              ASSIGN mmv-movto-mater.num-seq = req-ord-produc.num-tarefa.
          END.
     END.
  END.
  ELSE DO:
      FOR FIRST req-ord-produc   
          WHERE req-ord-produc.nr-requisicao = INT(b-movto.nro-docto)
            AND req-ord-produc.sequencia     = b-movto.num-sequen    NO-LOCK:
            ASSIGN mmv-movto-mater.num-seq   = req-ord-produc.num-tarefa.
      END.
  END.
END.
If avail mmv-ord-manut then do:
  Assign Mmv-movto-mater.ep-codigo   = mmv-ord-manut.ep-codigo
         Mmv-movto-mater.cod-eqpto   = mmv-ord-manut.cod-eqpto
         Mmv-movto-mater.num-seqcial = mmv-ord-manut.num-seqcial.
  /******** Inicio epc ***************************************/  
  IF  c-nom-prog-upc-mg97 <> "" THEN DO:
      /*********** SIGPACK ****/
      FOR EACH tt-epc WHERE tt-epc.cod-event = "Tarefas-ord-manut":
          DELETE tt-epc.
      END.

      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Tarefas-ord-manut"
             tt-epc.cod-parameter = "Ordem"
             tt-epc.val-parameter = STRING(mmv-ord-manut.nr-ord-produ).
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "Tarefas-ord-manut"
             tt-epc.cod-parameter = "Documento"
             tt-epc.val-parameter = STRING(b-movto.nro-docto).
      create tt-epc. 
      assign tt-epc.cod-event = "Tarefas-ord-manut" 
             tt-epc.cod-parameter = "Item"
             tt-epc.val-parameter = STRING(b-movto.it-codigo).
      create tt-epc. 
      assign tt-epc.cod-event = "Tarefas-ord-manut" 
             tt-epc.cod-parameter = "Tarefa"
             tt-epc.val-parameter = STRING(mmv-ord-manut.num-seq).
      {include/i-epc201.i "Tarefas-ord-manut"}

      FOR FIRST tt-epc WHERE tt-epc.cod-event     = "Tarefas-ord-manut"
                         AND tt-epc.cod-parameter = "TarefaRetorno":
          ASSIGN Mmv-movto-mater.num-seq = INT(tt-epc.val-parameter).
      END.

   end.
   /******** Fim epc ***************************************/  
End.

Assign mmv-movto-mater.esp-docto     = b-movto.esp-docto
      mmv-movto-mater.it-codigo     = b-movto.it-codigo
      mmv-movto-mater.qtd-item      = b-movto.quantidade
      mmv-movto-mater.cod-emitente  = b-movto.cod-emitente
      mmv-movto-mater.nro-docto     = b-movto.nro-docto
      mmv-movto-mater.serie-docto   = b-movto.serie-docto
      mmv-movto-mater.nat-operacao  = b-movto.nat-operacao
      mmv-movto-mater.sequencia     = b-movto.sequen-nf
      mmv-movto-mater.dsl-obs       = b-movto.descricao-db.

if mmv-movto-mater.esp-docto    = 28 and 
   mmv-movto-mater.cod-emitente > 0  then do:
    assign mmv-movto-mater.esp-docto = 21
           lAltera                   = yes.
end.

if mmv-movto-mater.esp-docto = 21 then assign mmv-movto-mater.idi-espec-docto = 1.
  else assign mmv-movto-mater.idi-espec-docto = 2.

If b-movto.tipo-trans = 1 then mmv-movto-mater.log-saida = false. /* Devolu‡Æo */
Else mmv-movto-mater.log-saida = true.                            /* Sa¡da     */

For first item fields (ge-codigo) where item.it-codigo = b-movto.it-codigo no-lock:
    Assign mmv-movto-mater.ge-codigo = item.ge-codigo.
End.

If (b-movto.valor-mat-m[1] + 
    b-movto.valor-mob-m[1] + 
    b-movto.valor-ggf-m[1]) > 0 then do:
   
    assign mmv-movto-mater.val-mater-1 = b-movto.valor-mat-m[1] + 
                                         b-movto.valor-mob-m[1] + 
                                         b-movto.valor-ggf-m[1] 
           mmv-movto-mater.val-mater-2 = b-movto.valor-mat-m[2] + 
                                         b-movto.valor-mob-m[2] + 
                                         b-movto.valor-ggf-m[2] 
           mmv-movto-mater.val-mater-3 = b-movto.valor-mat-m[3] + 
                                         b-movto.valor-mob-m[3] + 
                                         b-movto.valor-ggf-m[3].

end.
else do:

    if lAltera then do:
        /** Buscar NFE para pegar valor de val-mater-1 val-mater-2 val-mater3 **/
        for first movto-estoq
            where movto-estoq.it-codigo    = b-movto.it-codigo
            and   movto-estoq.cod-refer    = b-movto.cod-refer
            and   movto-estoq.cod-localiz  = b-movto.cod-localiz
            and   movto-estoq.lote         = b-movto.lote
            and   movto-estoq.nro-docto    = b-movto.nro-docto
            and   movto-estoq.serie        = b-movto.serie
            and   movto-estoq.sequen-nf    = b-movto.sequen-nf
            and   movto-estoq.cod-emitente = b-movto.cod-emitente
            and   movto-estoq.cod-estabel  = b-movto.cod-estabel
            and   movto-estoq.cod-depos    = b-movto.cod-depos
            and   (movto-estoq.esp-docto   = 21
            or     movto-estoq.esp-docto   = 22
            or     movto-estoq.esp-docto   = 23) no-lock:

            assign mmv-movto-mater.val-mater-1 = movto-estoq.valor-mat-m[1] + 
                                                 movto-estoq.valor-mob-m[1] + 
                                                 movto-estoq.valor-ggf-m[1] 
                   mmv-movto-mater.val-mater-2 = movto-estoq.valor-mat-m[2] + 
                                                 movto-estoq.valor-mob-m[2] + 
                                                 movto-estoq.valor-ggf-m[2] 
                   mmv-movto-mater.val-mater-3 = movto-estoq.valor-mat-m[3] + 
                                                 movto-estoq.valor-mob-m[3] + 
                                                 movto-estoq.valor-ggf-m[3].
        end.
    /*else continua processo padrÆo **/
    end.
    else do:
        assign data-aux = date(month(b-movto.dt-trans), 1, year(b-movto.dt-trans)) + 31.

        for last pr-it-per where pr-it-per.it-codigo    = b-movto.it-codigo
             and pr-it-per.cod-estabel  = b-movto.cod-estabel
             and pr-it-per.periodo     <= data-aux 
             AND (pr-it-per.val-unit-mat-m[1] + 
                  pr-it-per.val-unit-mob-m[1] +
                  pr-it-per.val-unit-ggf-m[1]) > 0 no-lock:
        end.

        if not avail pr-it-per then do:
            for first item-estab where item-estab.it-codigo   = b-movto.it-codigo
                  and item-estab.cod-estabel = b-movto.cod-estabel no-lock:
            end.
        end.

        for first estabelec where estabelec.cod-estabel = b-movto.cod-estabel no-lock:
        end.
        
        find first estab-mat WHERE estab-mat.cod-estabel = b-movto.cod-estabel no-lock no-error.  
        
        assign valor-unitario1 = 0
               valor-unitario2 = 0
               valor-unitario3 = 0.

        if avail pr-it-per then do:
            /* verifica se custo a ser lido ‚ o valor em BATH (di rio ou mensal)  */
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 1 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] +  
                                         pr-it-per.val-unit-ggf-m[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-m[2] + pr-it-per.val-unit-mob-m[2] +  
                                         pr-it-per.val-unit-ggf-m[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-m[3] + pr-it-per.val-unit-mob-m[3] +  
                                         pr-it-per.val-unit-ggf-m[3].
            &else
            if estabelec.custo-contab = 1 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-m[1] + pr-it-per.val-unit-mob-m[1] +  
                                         pr-it-per.val-unit-ggf-m[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-m[2] + pr-it-per.val-unit-mob-m[2] +  
                                         pr-it-per.val-unit-ggf-m[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-m[3] + pr-it-per.val-unit-mob-m[3] +  
                                         pr-it-per.val-unit-ggf-m[3].
            &endif  /*** Valor em Batch***/
            
            /*  verifica se custo a ser lido ‚ o valor em ON-LINE  */
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 2 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-p[1] + pr-it-per.val-unit-mob-p[1] +  
                                         pr-it-per.val-unit-ggf-p[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-p[2] + pr-it-per.val-unit-mob-p[2] +  
                                         pr-it-per.val-unit-ggf-p[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-p[3] + pr-it-per.val-unit-mob-p[3] +  
                                         pr-it-per.val-unit-ggf-p[3].

            &else
            if estabelec.custo-contab = 2 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-p[1] + pr-it-per.val-unit-mob-p[1] +  
                                         pr-it-per.val-unit-ggf-p[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-p[2] + pr-it-per.val-unit-mob-p[2] +  
                                         pr-it-per.val-unit-ggf-p[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-p[3] + pr-it-per.val-unit-mob-p[3] +  
                                         pr-it-per.val-unit-ggf-p[3].

            &endif /*** Valor em ON-LINE***/
            
            /* verifica se custo a ser lido ‚ o valor PADRÇO   */
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 3 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-o[1] + pr-it-per.val-unit-mob-o[1] +  
                                         pr-it-per.val-unit-ggf-o[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-o[2] + pr-it-per.val-unit-mob-o[2] +  
                                         pr-it-per.val-unit-ggf-o[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-o[3] + pr-it-per.val-unit-mob-o[3] +  
                                         pr-it-per.val-unit-ggf-o[3].

            &else
            if estabelec.custo-contab = 3 then 
                assign valor-unitario1 = pr-it-per.val-unit-mat-o[1] + pr-it-per.val-unit-mob-o[1] +  
                                         pr-it-per.val-unit-ggf-o[1].
                assign valor-unitario2 = pr-it-per.val-unit-mat-o[2] + pr-it-per.val-unit-mob-o[2] +  
                                         pr-it-per.val-unit-ggf-o[2].
                assign valor-unitario3 = pr-it-per.val-unit-mat-o[3] + pr-it-per.val-unit-mob-o[3] +  
                                         pr-it-per.val-unit-ggf-o[3].
            &endif /*** Valor em PADRÇO***/
        end.

        if not avail pr-it-per and avail item-estab then do:
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 1 then 
                assign valor-unitario1 = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] +  
                                         item-estab.val-unit-ggf-m[1].
            assign valor-unitario2 = item-estab.val-unit-mat-m[2] + item-estab.val-unit-mob-m[2] +  
                                     item-estab.val-unit-ggf-m[2].
            assign valor-unitario3 = item-estab.val-unit-mat-m[3] + item-estab.val-unit-mob-m[3] +  
                                     item-estab.val-unit-ggf-m[3].
            &else
            if estabelec.custo-contab = 1 then 
                assign valor-unitario1 = item-estab.val-unit-mat-m[1] + item-estab.val-unit-mob-m[1] +  
                                         item-estab.val-unit-ggf-m[1].
            assign valor-unitario2 = item-estab.val-unit-mat-m[2] + item-estab.val-unit-mob-m[2] +  
                                     item-estab.val-unit-ggf-m[2].
            assign valor-unitario3 = item-estab.val-unit-mat-m[3] + item-estab.val-unit-mob-m[3] +  
                                     item-estab.val-unit-ggf-m[3].
            &endif  /*** Valor em Batch***/
            
            /*  verifica se custo a ser lido ‚ o valor em ON-LINE  */
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 2 then 
                assign valor-unitario1 = item-estab.val-unit-mat-p[1] + item-estab.val-unit-mob-p[1] +  
                                         item-estab.val-unit-ggf-p[1].
            assign valor-unitario2 = item-estab.val-unit-mat-p[2] + item-estab.val-unit-mob-p[2] +  
                                     item-estab.val-unit-ggf-p[2].
            assign valor-unitario3 = item-estab.val-unit-mat-p[3] + item-estab.val-unit-mob-p[3] +  
                                     item-estab.val-unit-ggf-p[3].
            &else
            if estabelec.custo-contab = 2 then 
                assign valor-unitario1 = item-estab.val-unit-mat-p[1] + item-estab.val-unit-mob-p[1] +  
                                         item-estab.val-unit-ggf-p[1].
            assign valor-unitario2 = item-estab.val-unit-mat-p[2] + item-estab.val-unit-mob-p[2] +  
                                     item-estab.val-unit-ggf-p[2].
            assign valor-unitario3 = item-estab.val-unit-mat-p[3] + item-estab.val-unit-mob-p[3] +  
                                     item-estab.val-unit-ggf-p[3].
            &endif /*** Valor em ON-LINE***/
            
            /* verifica se custo a ser lido ‚ o valor PADRÇO   */
            &if defined (bf_man_custeio_item) &then
            if estab-mat.custo-contab = 3 then 
                assign valor-unitario1 = item-estab.val-unit-mat-o[1] + item-estab.val-unit-mob-o[1] +  
                                         item-estab.val-unit-ggf-o[1].
            assign valor-unitario2 = item-estab.val-unit-mat-o[2] + item-estab.val-unit-mob-o[2] +  
                                     item-estab.val-unit-ggf-o[2].
            assign valor-unitario3 = item-estab.val-unit-mat-o[3] + item-estab.val-unit-mob-o[3] +  
                                     item-estab.val-unit-ggf-o[3].
            &else
            if estabelec.custo-contab = 3 then 
                assign valor-unitario1 = item-estab.val-unit-mat-o[1] + item-estab.val-unit-mob-o[1] +  
                                         item-estab.val-unit-ggf-o[1].
            assign valor-unitario2 = item-estab.val-unit-mat-o[2] + item-estab.val-unit-mob-o[2] +  
                                     item-estab.val-unit-ggf-o[2].
            assign valor-unitario3 = item-estab.val-unit-mat-o[3] + item-estab.val-unit-mob-o[3] +  
                                     item-estab.val-unit-ggf-o[3].
            &endif /*** Valor em ON-LINE***/
        end.

        assign mmv-movto-mater.val-mater-1 = valor-unitario1 * b-movto.quantidade.
        assign mmv-movto-mater.val-mater-2 = valor-unitario2 * b-movto.quantidade.
        assign mmv-movto-mater.val-mater-3 = valor-unitario3 * b-movto.quantidade.
    end.
end.

RUN piTtEpcAtualizaValor.  

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTtEpcAtualizaValor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTtEpcAtualizaValor Procedure 
PROCEDURE piTtEpcAtualizaValor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF AVAIL mmv-movto-mater THEN DO:

      FOR EACH tt-epc WHERE tt-epc.cod-event = "ATUALIZA-VALOR":
          DELETE tt-epc.
      END.
    
      CREATE tt-epc.
      ASSIGN tt-epc.cod-event     = "ATUALIZA-VALOR"
             tt-epc.cod-parameter = "Rowid"
             tt-epc.val-parameter = STRING(Rowid(mmv-movto-mater)).
      {include/i-epc201.i "ATUALIZA-VALOR"}
    
      IF RETURN-VALUE = "OK" THEN DO:
          FOR FIRST tt-epc 
              WHERE tt-epc.cod-event     = "ATUALIZA-VALOR"
                AND tt-epc.cod-parameter = "val-mater-1":
              ASSIGN mmv-movto-mater.val-mater-1 = DEC(tt-epc.val-parameter).
              RUN piConverteMoeda IN THIS-PROCEDURE (INPUT  mmv-movto-mater.val-mater-1,
                                                     OUTPUT mmv-movto-mater.val-mater-2,
                                                     OUTPUT mmv-movto-mater.val-mater-3,
                                                     INPUT  mmv-movto-mater.dat-movto).
          END.
      END.

  END.

  RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

