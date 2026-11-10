/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0801 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0801 MAB}
&ENDIF


/*****************************************************************************
**
**    Programa: AB0801
**
**    Objetivo: Calculo do preco medio - Ordens de Manutencao de Frota - Fase -> 2
**
*******************************************************************************

Observacao Importante:
---------- ----------
Este programa  pode ser chamado  recursivamente,  devido a  isto  deve-se
tomar cuidado ao se alterar o programa, principalmente no que se refere a
tornar  buffers,  variaveis  ou workfiles compartilhados entre  programas
(new shared ou new global shared).                                            */

/* Buffers Utilizados para Calculo dos Debitos/Creditos das Ordens de
   Producao/Servico nas Tres Moedas do Estoque.                    */
{cdp/cdcfgmat.i}

def input parameter h-acomp as handle no-undo.

&if defined(bf_mat_fech_estab) &then
    def input parameter r-item-estab as rowid no-undo.
    find item-estab where rowid(item-estab) = r-item-estab no-lock no-error.
&endif


def buffer b-item      for item. 
def buffer b-movto     for movto-estoq.  
def buffer b-ordem     for ord-prod.
DEF BUFFER b-ordem-2   FOR ord-prod.
def buffer b-movto-mat for movto-mat.
DEF BUFFER b-movto-ggf FOR movto-ggf.
DEF BUFFER b-movto-dir FOR movto-dir.
def buffer b-it-est-ant for item-estab. /* Medio do mes anterior */
def buffer b-item-est-aux for item-estab. /*recursividade*/
def buffer b-item-estab for item-estab.

/* Controle de recursividade de ordens */
def shared temp-table t-ord-it no-undo
    field nr-ordem like ord-prod.nr-ord-prod
    index codigo is unique nr-ordem.

def new shared var de-mob-d-ord      as decimal decimals 4 extent 3  no-undo.
def new shared var de-ggf-d-ord      as decimal decimals 4 extent 3  no-undo.
def new shared var l-tr-mat          as logical                      no-undo.
def new shared var l-tr-mob          as logical                      no-undo.
def new shared var l-tr-ggf          as logical                      no-undo.
def new shared var de-total-cre-mat  as decimal extent 3             no-undo.
def new shared var de-total-cre-mob  as decimal decimals 02 extent 3 no-undo.
def new shared var de-total-cre-ggf  as decimal decimals 02 extent 3 no-undo.
def new shared var de-total-deb-mat  as decimal extent 3             no-undo.
def new shared var de-total-deb-mob  as decimal decimals 02 extent 3 no-undo.
def new shared var de-total-deb-ggf  as decimal decimals 02 extent 3 no-undo.
def new shared var de-preco-fiscal   like item.preco-fiscal          no-undo.
def new shared var i-sequencia       as integer                      no-undo.
def new shared var de-qt-pecas-boas  like movto-ggf.qt-pecas-boas    no-undo.
def new shared var l-tem-sal-op      as logical init no              no-undo.
def new shared var de-aux-0          like item.preco-fiscal          no-undo.
def new shared var de-aux-1          like item.preco-fiscal          no-undo.
def new shared var de-vl-ext-db-mt   as decimal decimals 4 extent 3  no-undo.
def new shared var de-vl-ext-cr-mt   as decimal decimals 4 extent 3  no-undo. 
def new shared var de-vl-ext-db-mb   as decimal decimals 4 extent 3  no-undo. 
def new shared var de-vl-ext-cr-mb   as decimal decimals 4 extent 3  no-undo.
def new shared var de-vl-ext-db-gf   as decimal decimals 4 extent 3  no-undo. 
def new shared var de-vl-ext-cr-gf   as decimal decimals 4 extent 3  no-undo.

def shared var l-tem-mov        as logical init no             no-undo.
def shared var i-msg            as integer init 0              no-undo.
def shared var i-msg-moeda      as logical extent 3.
def shared var r-tab-msg        as integer extent 20           no-undo.
def shared var r-tab-mov        as logical extent 20           no-undo.
def shared var r-tab-moe        as charac  extent 20 format "x(3)" init "000".
def shared var c-it-codigo         like item.it-codigo no-undo.
def shared var i-ct-acerto         like param-estoq.ct-acerto no-undo.
def shared var i-moeda-1           like param-estoq.moeda1 no-undo.
def shared var i-moeda-2           like param-estoq.moeda2 no-undo.
def shared var i-sc-acerto         like param-estoq.sc-acerto no-undo.
def shared var l-modulo-cs         like param-global.modulo-cs no-undo.
def shared var l-moeda-1           like param-estoq.tem-moeda1 no-undo.
def shared var l-moeda-2           like param-estoq.tem-moeda2 no-undo.
def shared var l-tipo-pr-med       like param-estoq.tipo-pr-med no-undo.
def shared var da-data-fim         as date    format "99/99/9999" no-undo.
def shared var da-data-ini         as date    format "99/99/9999" no-undo.
def shared var da-data-prox        as date    format "99/99/9999" no-undo.
def shared var r-item              as rowid   no-undo.
def shared var si-acertos-feitos   as integer no-undo.
def shared var si-itens-recursivos as integer no-undo.
def shared var i-tempo-a           as integer no-undo.
def shared var i-tempo-g           as integer no-undo.
def shared var i-mo-fasb           as integer no-undo.
def shared var i-mo-cmi            as integer no-undo.
def shared var l-fasb              as logical no-undo.
def shared var l-cmi               as logical no-undo.
def shared var r-tab-rowid         as rowid extent 25 no-undo.
def shared var i-ind               as integer no-undo.
def shared var i-decimais          as integer no-undo.
def shared var l-x                 as logical no-undo.
def shared var da-inicio-calc      as date    no-undo.
def shared var i-seq-ocorrencia    as integer no-undo.
def shared var data-medio          as date    no-undo.


def var i-mensagem       as integer                      no-undo.
def var l-erro-x         as logical init no              no-undo.
def var l-problema       as logical init no              no-undo.
def var c-mensagem       as char format "x(100)"         no-undo.
def var r-ult-oper       as rowid                        no-undo.
def var da-data-aux      as date                         no-undo.
def var de-vl-unit-aux   as decimal decimals 10          no-undo.
def var de-vl-unit-aux-1 as decimal decimals 10          no-undo.
def var l-pm-ja-calc     as logical                      no-undo.

def var de-tot-mob-pai   as decimal decimals 4           no-undo.
def var de-tot-ggf-pai   as decimal decimals 4           no-undo.
def var de-qt-calculada  as decimal                      no-undo.
def var i-cont           as integer                      no-undo.
def var i-moeda          as integer                      no-undo.
def var i-tmp-moe        as integer                      no-undo.
def var i-x              as integer                      no-undo.
def var i-y              as integer                      no-undo.
def var i-tempo-ini      as integer                      no-undo.
def var i-aux            as integer                      no-undo.
def var de-difer-ggf     as decimal decimals 4           no-undo.
def var c-tit            as char                         no-undo.
def var l-tem-movto-ggf  as logical init no              no-undo.
def var l-tem-movto-dir  as logical init no              no-undo.
def var i-op-seq         as integer                      no-undo.
DEF VAR l-ordem          AS LOGICAL INIT NO              NO-UNDO.
DEF VAR l-calcula        AS LOGICAL INIT YES             NO-UNDO.
def var c-desc-ocor      as char format "x(255)"         no-undo.
def var c-especie        as char                         no-undo.

/*
Tabela SHARED para salvar os valores de GGF (6 tipos de custo)
nas 3 moedas do estoque. Esta tabela e utilizada de maneira
bidimensional (3 x 6) atraves dos indexadores i-x e i-y
*/

def new shared var de-vl-ggf-cr     as decimal decimals 2  extent 18 no-undo.
def new shared var de-vl-ggf-db     as decimal decimals 2  extent 18 no-undo.
def new shared var de-vl-mob-cr     as decimal decimals 2  extent 3  no-undo.
def new shared var de-vl-mob-db     as decimal decimals 2  extent 3  no-undo.
def new shared var b-item-ant        as rowid no-undo.
def new shared var da-ult-fech-dia   as date format "99/99/9999"     no-undo.
def new shared var i-tipo-pr-med     as integer                      no-undo.

find first param-cs     no-lock no-error.
find first param-global no-lock no-error.
find first param-estoq  no-lock no-error.
find item where r-item = rowid(item) no-lock .

&if defined(bf_mat_fech_estab) &then
    /* define e seta variaveis com o nome do programa UPC */
    {cep/ce0401x.i2}
    {cep/ce0401x.i1 "shared" "ce0401n"  0}
    {cep/ce0401x.i1 "shared" "ce0401g1" 0}
&endif

{cdp/cd1234.i} /* Defini»’o de Temp-Table e Vari vieis - Valida»’o Decimais */
{cep/ce0401.i13}

assign c-it-codigo = item.it-codigo
       i-tempo-ini = time.
       
&if defined(bf_mat_fech_estab) &then
    if param-estoq.tp-fech = 1 then
        assign da-ult-fech-dia = param-estoq.ult-fech-dia
               i-tipo-pr-med   = param-estoq.tipo-pr-med.
    else do:
        find first estab-mat 
             where estab-mat.cod-estabel = item-estab.cod-estabel
             no-lock no-error.
        assign da-ult-fech-dia = estab-mat.ult-fech-dia
               i-tipo-pr-med   = estab-mat.tipo-pr-med.
    end.
&else
    assign da-ult-fech-dia = param-estoq.ult-fech-dia
           i-tipo-pr-med   = param-estoq.tipo-pr-med.
&endif

{utp/ut-table.i movfro mmv-ord-manut 1}  
assign c-tit = return-value.

if l-modulo-cs then
for each ord-prod use-index ori-val where
    ord-prod.it-codigo   = ITEM.it-codigo and 
    ord-prod.cod-estabel = item-estab.cod-estabel and 
    ord-prod.origem      = "MV"           and 
    ord-prod.valorizada  = no             and
    ord-prod.estado      > 3
    no-lock transaction:        
   
    /* verifica se a OM j  foi valorizada Itatiaia */
   if can-find(first movto-mat where
                     movto-mat.nr-ord-produ = ord-prod.nr-ord-prod   and
                     movto-mat.dt-trans     = data-medio             and 
                     movto-mat.it-codigo    = ord-prod.it-codigo     and
                     movto-mat.esp-docto    = 1)
   then next.
   else                  
    if can-find(first movto-mat where
                      movto-mat.nr-ord-produ = ord-prod.nr-ord-prod   and
                      movto-mat.dt-trans     = data-medio             and 
                      movto-mat.it-codigo    = ord-prod.it-codigo     and
                      movto-mat.esp-docto    = 8)
   then next.              
  
   run pi-acompanhar in h-acomp ( c-tit + " : " + string(ord-prod.nr-ord-produ)).   
   find t-ord-it where 
        t-ord-it.nr-ordem = ord-prod.nr-ord-prod
        no-lock no-error.
   if avail t-ord-it 
   then
      next. /* Ordem esta sendo calculada */
   else
      create t-ord-it.
   assign t-ord-it.nr-ordem = ord-prod.nr-ord-prod.
   
   assign de-aux-0       = 0
          de-aux-1       = 0.
  
   /*Randig - Verifica se a ordem possui algum movimento no perðodo.
     As variaveis irao ajudar na chamada dos programas que
     valorizam GGF e MOB*/
   for first movto-mat fields (nr-ord-prod dt-trans it-codigo esp-docto)
             use-index data where
             movto-mat.nr-ord-prod  = ord-prod.nr-ord-prod and
             movto-mat.dt-trans    >= da-inicio-calc       and
             movto-mat.dt-trans    <= da-data-fim        
             no-lock : end.
   for first movto-ggf fields (nr-ord-prod dt-trans cc-codigo)
             use-index ordem where
             movto-ggf.nr-ord-prod  = ord-prod.nr-ord-prod and
             movto-ggf.dt-trans    >= da-inicio-calc       and
             movto-ggf.dt-trans    <= da-data-fim        
             no-lock : end.
   assign l-tem-movto-ggf = avail(movto-ggf).          
   for first movto-dir fields (nr-ord-prod dt-trans cc-codigo)
             use-index ordem where
             movto-dir.nr-ord-prod  = ord-prod.nr-ord-prod and
             movto-dir.dt-trans    >= da-inicio-calc       and
             movto-dir.dt-trans    <= da-data-fim        
             no-lock : end.
   assign l-tem-movto-dir = avail(movto-dir).  
   if not avail movto-mat and
      not avail movto-ggf and
      not avail movto-dir then do:
      if ord-prod.estado = 8 then do:
         run pi-verifica-mov-fut.
         find t-ord-it where 
              t-ord-it.nr-ordem = ord-prod.nr-ord-prod no-error.
         if avail t-ord-it then delete t-ord-it.
         next.
      end.
      else do:
        find t-ord-it where 
              t-ord-it.nr-ordem = ord-prod.nr-ord-prod no-error.
         if avail t-ord-it then delete t-ord-it.
         next.
      end.
   end.
   
   assign l-tr-mat          = no
          l-tr-mob          = no 
          l-tr-ggf          = no
          de-vl-ext-db-mt   = 0  /* Controle de saldos ext-ord x movto-mat */
          de-vl-ext-cr-mt   = 0
          de-vl-ext-db-mb   = 0
          de-vl-ext-cr-mb   = 0
          de-vl-ext-db-gf   = 0
          de-vl-ext-cr-gf   = 0.

   /* Se ordem nao possuir movimento anterior ao periodo, zera saldos da OP */
   for first movto-mat fields (nr-ord-prod dt-trans it-codigo esp-docto)
             use-index data where
             movto-mat.nr-ord-prod = ord-prod.nr-ord-prod 
             no-lock : end.
   for first movto-dir fields (nr-ord-prod dt-trans cc-codigo)
             use-index ordem where
             movto-dir.nr-ord-prod = ord-prod.nr-ord-prod 
             no-lock : end.
   for first movto-ggf fields (nr-ord-prod dt-trans cc-codigo)
             use-index ordem where
             movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod
             no-lock : end.

   /* Zeramento dos debitos e creditos do mes para ordem.
      Este procedimento ser  executado caso o pre»o m²dio
      seja mensal ou seja a primeira execu»’o do pre»o m²dio
      di rio no m¼s                                       */
      if (i-tipo-pr-med = 2) or
         (i-tipo-pr-med = 1 and da-inicio-calc = (da-ult-fech-dia + 1))
   then do : 
      for each ext-ord where
               ext-ord.nr-ord-prod = ord-prod.nr-ord-prod exclusive-lock:
         if (not avail movto-mat or movto-mat.dt-trans >= da-data-ini) and
            (not avail movto-dir or movto-dir.dt-trans >= da-data-ini) and
            (not avail movto-ggf or movto-ggf.dt-trans >= da-data-ini) 
         then 
            delete ext-ord.
         else
            assign ext-ord.vl-mb-cr-mes-m = 0
                   ext-ord.vl-mb-db-mes-m = 0
                   ext-ord.vl-mob-cr-me-m = 0
                   ext-ord.vl-mob-db-me-m = 0                                
                   ext-ord.vl-gf-cr-mes-m = 0
                   ext-ord.vl-gf-db-mes-m = 0
                   ext-ord.vl-ggf-cr-me-m = 0
                   ext-ord.vl-ggf-db-me-m = 0                                
                   ext-ord.vl-mt-cr-mes-m = 0
                   ext-ord.vl-mt-db-mes-m = 0.
         validate ext-ord.
      end.             
   end.

   /* Operacoes da ordem */
   do:
      assign i-sequencia = 0.
      do i-moeda = 1 to 3:
         if (i-moeda = 2 and not l-moeda-1) or 
            (i-moeda = 3 and not l-moeda-2) then next.
       
         assign i-tmp-moe = if i-moeda = 1 then 0
                                           else if i-moeda = 2 then i-moeda-1
                                                               else i-moeda-2.
 
         /*  Cria as ext-ord caso nao exista */
         if not can-find(ext-ord use-index ordem where
                         ext-ord.nr-ord-prod = ord-prod.nr-ord-prod and
                         ext-ord.mo-codigo   = i-tmp-moe            and
                         ext-ord.op-seq      = i-sequencia) then do:
            create ext-ord.
            assign ext-ord.nr-ord-prod = ord-prod.nr-ord-prod
                   ext-ord.mo-codigo   = i-tmp-moe
                   ext-ord.op-seq      = i-sequencia.
            validate ext-ord.
         end.
      end.
 
      assign de-total-deb-mob = 0
             de-total-cre-mob = 0
             de-total-deb-mat = 0
             de-total-cre-mat = 0
             de-total-deb-ggf = 0
             de-total-cre-ggf = 0 /*ok*/
             de-qt-pecas-boas = 0.
             

      for each movto-mat use-index data where
               movto-mat.nr-ord-prod = ord-prod.nr-ord-prod and
               movto-mat.op-seq      = i-sequencia          and
               movto-mat.dt-trans   >= da-inicio-calc       and
               movto-mat.dt-trans   <= da-data-fim EXCLUSIVE-LOCK: 

         assign l-tr-mat = yes.         

         for first movto-estoq fields (nr-ord-prod num-sequen
                                        esp-docto   tipo-trans
                                        valor-mat-m valor-mob-m
                                        valor-ggf-m log-1      )  
               use-index ord-seq where
               movto-estoq.nr-ord-produ = movto-mat.nr-ord-prod and
               movto-estoq.num-sequen   = movto-mat.num-sequen  and
               movto-estoq.esp-docto    = movto-mat.esp-docto   and
               movto-estoq.tipo-trans   = movto-mat.tipo-trans EXCLUSIVE-LOCK: end.
                
         if movto-mat.valor-mat-m[1] = 0           and
            movto-mat.valor-mob-m[1] = 0           and             
            movto-mat.valor-ggf-m[1] = 0           and
            movto-mat.esp-docto   <> 1 /* ACA */   and 
            movto-mat.esp-docto   <> 8 /* EAC */   then do:

            for first b-item fields (it-codigo tipo-contr preco-fiscal pm-ja-calc niv-mais-bai) where             
                      b-item.it-codigo = movto-mat.it-codigo 
                      no-lock : end.

            FOR FIRST b-item-estab 
                WHERE b-item-estab.it-codigo = movto-mat.it-codigo
                  AND b-item-estab.cod-estabel = movto-mat.cod-estabel 
                  NO-LOCK: END.
            
            
            IF b-item.tipo-contr = 2 /* Total */ then do:

               /* Verifica se o movimento ² de sobra para valoriza-lo ao preco fiscal.*/
               if movto-mat.esp-docto = 35 /* SOB */ then do:

                  do i-moeda = 1 to 3:
                     if (i-moeda = 2 and not l-moeda-1) or
                        (i-moeda = 3 and not l-moeda-2) then next.
                    
                     if b-item.preco-fiscal = 0 
                     then assign de-preco-fiscal = 1.
                     else assign de-preco-fiscal = b-item.preco-fiscal.   
                    
                     run "cdp/cd0813.p" 
                         (0, i-moeda - 1, de-preco-fiscal, movto-mat.dt-trans, 
                         output de-aux-1).
                     if de-aux-1 = 0 or de-aux-1 = ? 
                     then assign de-aux-1    = 0
                                 movto-mat.valor-mat-m[i-moeda] = movto-mat.valor-mat-m[1].
                     ELSE assign movto-mat.valor-mat-m[i-moeda] =
                                 fn_ajust_dec(round((de-aux-1 * movto-mat.quantidade),2),
                                 fn_acha_moeda(i-moeda))
                                 de-aux-1 = 0.
                        
                     if movto-mat.valor-mat-m[i-moeda] = 0 then
                        assign movto-mat.valor-mat-m[i-moeda] = 0.01.       
                     validate movto-mat.
                  end.
               end.
               ELSE DO:
                   /*Se o movimento nao possui valor e o item do movimento eh de controle
                    total, entao sera valorizado ao preco medio do mes anterior*/

                   RUN pi-verifica-compr.
                                      
                   IF l-calcula = YES THEN DO: 
                       &if defined(bf_mat_fech_estab) &then
                            /*******************************************************************
                            **                           Release 2.04                         **
                            **                                                                **
                            ** Fechamento Unico: processa todos os estabelecimentos num ßnico **
                            ** momento para ser possivel valorizar as NFTs corretamente.      **
                            **                                                                **
                            ** Fechamento Estabelecimento: cada estabelecimento sera proces-  **
                            ** do em momentos diferentes conforme digita"'o do usuario.       **
                            *******************************************************************/          
                            if param-estoq.tp-fech = 1 and param-estoq.tip-calc-med = 1  then  /* Fechamento Unico */
                                for each b-item-est-aux where
                                    b-item-est-aux.it-codigo = b-item-estab.it-codigo exclusive-lock:
                                    run "cep/ce0401g.p" (rowid(b-item-est-aux)).
                                end.
                            else DO:                           /* Fechamento por Estabelecimento */
                               run "cep/ce0401g.p" (rowid(b-item-estab)).    
                            END.
                       &else          
                            run "cep/ce0401g.p" (rowid(b-item)).
                       &endif
                       
                   END.
                   ELSE DO: /*Busca m²dio do m¼s anterior para movimento da ordem*/
                   
                       for first b-it-est-ant fields(cod-estabel    it-codigo
                                                     val-unit-mat-m val-unit-mob-m
                                                     val-unit-ggf-m               ) where
                                 b-it-est-ant.cod-estabel = movto-mat.cod-estabel and
                                 b-it-est-ant.it-codigo   = movto-mat.it-codigo 
                                 no-lock : end.
            
                       /*Gera ocorr¼ncia no m²dio*/
                       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                           DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                           ASSIGN cAuxTraducao001 = {ininc/i03in218.i 04 movto-mat.esp-docto}.
                           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                               INPUT "",
                                               INPUT "").
                           ASSIGN  c-especie = RETURN-VALUE.  
                       &else
                           ASSIGN c-especie = {ininc/i03in218.i 04 movto-mat.esp-docto}.
                       &endif
                             run utp/ut-msgs.p (input "msg",
                                                input 26862,
                                                input " ").
                       assign c-desc-ocor = return-value.
     
                       run utp/ut-msgs.p (input "help",   
                                          input 26862,
                                          input c-especie + "~~" +
                                          string(movto-mat.it-codigo) + "~~" +
                                          string(movto-mat.nr-ord-prod)).
                            
                       run "cep/ce0401e.p" (ord-prod.nr-ord-prod,
                                            c-desc-ocor         ,
                                            return-value        ,
                                            rowid(b-item)       ,
                                            1                   ,
                                            2                   ).

                       do i-moeda = 1 to 3:
                          if (i-moeda = 2 and not l-moeda-1) or
                             (i-moeda = 3 and not l-moeda-2) 
                             then next.
                          if (not avail b-it-est-ant 
                          or (b-it-est-ant.val-unit-mat-m[i-moeda] = 0 
                          and b-it-est-ant.val-unit-mob-m[i-moeda] = 0
                          and b-it-est-ant.val-unit-ggf-m[i-moeda] = 0)) then do:
            
                              run "cep/ce0401h.p" (input  movto-mat.nr-ord-produ,
                                                   input  i-moeda               ,
                                                   input  movto-mat.it-codigo   ,
                                                   &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
                                                       INPUT movto-mat.cod-estabel ,
                                                   &endif
                                                   output de-vl-unit-aux        ).
        
                              assign movto-mat.valor-mat-m[i-moeda] =
                                     fn_ajust_dec(round((de-vl-unit-aux *
                                     movto-mat.quantidade),2),fn_acha_moeda(i-moeda)).
                                  {cep/ce0401a.i movto-mat.nr-ord-produ i-moeda}
                          end.
                          else
                                assign movto-mat.valor-mat-m[i-moeda] =
                                       fn_ajust_dec(round((b-it-est-ant.val-unit-mat-m[i-moeda] *
                                       movto-mat.quantidade),2),fn_acha_moeda(i-moeda))
                                       movto-mat.valor-mob-m[i-moeda] =
                                       fn_ajust_dec(round((b-it-est-ant.val-unit-mob-m[i-moeda] *
                                       movto-mat.quantidade),2),fn_acha_moeda(i-moeda))
                                       movto-mat.valor-ggf-m[i-moeda] =
                                       fn_ajust_dec(round((b-it-est-ant.val-unit-ggf-m[i-moeda] *
                                       movto-mat.quantidade),2),fn_acha_moeda(i-moeda)).
                          validate movto-mat.
                       end.       
                   END.
               END.
               assign movto-estoq.valor-mat-m[1] = movto-mat.valor-mat-m[1]
                      movto-estoq.valor-mat-m[2] = movto-mat.valor-mat-m[2]
                      movto-estoq.valor-mat-m[3] = movto-mat.valor-mat-m[3]
                      movto-estoq.valor-mob-m[1] = movto-mat.valor-mob-m[1]
                      movto-estoq.valor-mob-m[2] = movto-mat.valor-mob-m[2]
                      movto-estoq.valor-mob-m[3] = movto-mat.valor-mob-m[3]
                      movto-estoq.valor-ggf-m[1] = movto-mat.valor-ggf-m[1]
                      movto-estoq.valor-ggf-m[2] = movto-mat.valor-ggf-m[2]
                      movto-estoq.valor-ggf-m[3] = movto-mat.valor-ggf-m[3]
                      movto-estoq.tipo-valor     = 2.
               validate movto-estoq.
            end.  /* then do */  
         end. /* movto-mat valor = 0 */

         do i-moeda = 1 to 3:
             if movto-mat.tipo-trans = 1 then do:
               assign de-total-cre-mob[i-moeda] = de-total-cre-mob[i-moeda] + 
                                                  movto-mat.valor-mob-m[i-moeda]
                      de-total-cre-mat[i-moeda] = de-total-cre-mat[i-moeda] +
                                                  movto-mat.valor-mat-m[i-moeda].
                      de-total-cre-ggf[i-moeda] = de-total-cre-ggf[i-moeda] +
                                                  movto-mat.valor-ggf-m[i-moeda].
             end.
             else do:
               assign de-total-deb-mob[i-moeda] = de-total-deb-mob[i-moeda] + 
                                                  movto-mat.valor-mob-m[i-moeda]
                      de-total-deb-mat[i-moeda] = de-total-deb-mat[i-moeda] + 
                                                  movto-mat.valor-mat-m[i-moeda]
                      de-total-deb-ggf[i-moeda] = de-total-deb-ggf[i-moeda] + 
                                                  movto-mat.valor-ggf-m[i-moeda].                                                  
             end.
         end.    
      end. /* for each movto-mat */  

      /* Calculo do GGF apropriado na ordem de servico/producao.
         Nesta rotina tambem sao apurados os valores que serao creditados
         aos centros de custos e debitados nas ordens de servico, estes
         valores serao atualizados no movimento de estoque atraves de
         transacoes de debito direto. */
      assign de-vl-ggf-cr = 0
             de-vl-ggf-db = 0
             de-vl-mob-db = 0
             de-vl-mob-cr = 0
             de-mob-d-ord = 0
             de-ggf-d-ord = 0
             l-tem-sal-op = no
             de-aux-0     = 0.
             
      /* Valorizacao das movimentacoes de GGF */
      if l-tem-movto-ggf then    DO:

         run "cep/ce0401p.p" (input  rowid(ord-prod),
                              input  rowid(item)    ,
                              input  i-sequencia    ,
                              output l-tem-sal-op   ,
                              output l-tr-ggf       ).
      END.
                           
      /* Valoriza»’o da m’o-de-obra direta */
      if l-tem-movto-dir THEN DO:
         run cep/ce0401t.p  (input  rowid(ord-prod) ,
                             input  rowid(item)     ,
                             input  i-sequencia     ,
                             output l-tr-mob        ).           
      END.
                                            

      /* Cria ACA/EAC para ordens doFrota */
      if CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-mmv-impl":U 
                                  AND funcao.ativo) then do:

         for first mmv-ord-manut fields(nr-ord-produ) where 
                   mmv-ord-manut.nr-ord-produ = ord-prod.nr-ord-produ 
                   no-lock : 
         end.
         /* Programa que gera o movimento de ACA/EAC na ordem de Frota.*/
         if avail(mmv-ord-manut) then DO:
            run "abp/ab0802.p" (input rowid(ord-prod)).
         END.
      end.     
      
   end. 

   /* Apura saldos da ordem, para verificar se a mesma podera ser passada
       para valorizada. */
   if ord-prod.estado = 8 /* Terminada */ then do:
      
      for last movto-mat fields(nr-ord-prod dt-trans esp-docto it-codigo)
               use-index data where
               movto-mat.nr-ord-prod = ord-prod.nr-ord-prod and
               movto-mat.dt-trans    > da-data-fim 
               no-lock : end.
      for last movto-ggf fields(nr-ord-prod dt-trans cc-codigo)
               use-index ordem where
               movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod and
               movto-ggf.dt-trans    > da-data-fim 
               no-lock : end.
      for last movto-dir fields(nr-ord-prod dt-trans cc-codigo)
               use-index ordem where
               movto-dir.nr-ord-prod = ord-prod.nr-ord-prod and
               movto-dir.dt-trans    > da-data-fim 
               no-lock : end.
      if not avail movto-mat and
         not avail movto-ggf and
         not avail movto-dir then do:
         find b-ordem where
              rowid(b-ordem) = rowid(ord-prod)
              exclusive-lock.
         assign b-ordem.valorizada = yes.
         validate b-ordem.
      end.
   end. 

   /* Elimina ordem da temp-table, ordem ja calculada. */
   find t-ord-it where 
        t-ord-it.nr-ordem = ord-prod.nr-ord-prod
        exclusive-lock no-error.
   if avail t-ord-it then delete t-ord-it.
end. /* l-modulo-cs */


assign i-tempo-a   = i-tempo-a + (time - i-tempo-ini).

/* Calculo do preco medio por estabelecimento */

assign i-tempo-ini = time.

do i-moeda = 1 to 3:
  if i-msg-moeda[i-moeda] then
     {cep/ce0401a.i 0 i-moeda}
end.

PROCEDURE pi-verifica-mov-fut.
 /* Verifica se a ordem possui movimento futuro */
 for first movto-mat fields (nr-ord-prod dt-trans)
     where movto-mat.nr-ord-prod = ord-prod.nr-ord-prod
       and movto-mat.dt-trans > data-medio no-lock: end.
 if not avail movto-mat then do:
    for first movto-dir fields (nr-ord-prod dt-trans)
        where movto-dir.nr-ord-prod = ord-prod.nr-ord-prod
          and movto-dir.dt-trans > data-medio no-lock: end.
   if not avail movto-dir then do:
      for first movto-ggf fields (nr-ord-prod dt-trans)
          where movto-ggf.nr-ord-prod = ord-prod.nr-ord-prod
            and movto-ggf.dt-trans > data-medio no-lock: end.
      if not avail movto-ggf then do:
     
         find b-ordem where
              rowid(b-ordem) = rowid(ord-prod) exclusive-lock.
              assign b-ordem.valorizada = yes.
         validate b-ordem.
      end.
   end.
 end.
END PROCEDURE.

PROCEDURE pi-verifica-compr.
/*********************************************************************** 
   A consistencia abaixo ira dizer se o item do movimento de material
   eh comprado (nao possui ordens movimentadas ou co-produto no periodo).
   Se for um item coprado entao ira calcular o preco medio do item
   senao o movimento de material irah receber o preco medio do mes
   anterior.
***********************************************************************/   
 ASSIGN l-calcula = YES.  

 /* Verifica se o item possui alguma ordem nao valorizada. */
 if ( param-global.modulo-cp and 
     can-find(first b-ordem-2 where
                    b-ordem-2.it-codigo  = movto-mat.it-codigo and
                    b-ordem-2.origem     = "CP"                and
                    b-ordem-2.valorizada = no no-lock) )              
 or
    ( param-global.modulo-mi and
      can-find(first b-ordem-2 where
                     b-ordem-2.it-codigo  = movto-mat.it-codigo and
                     b-ordem-2.origem     = "MI"                and
                     b-ordem-2.valorizada = no no-lock) )  
 or
        ( param-global.modulo-ch and
          can-find(first b-ordem-2 where
                         b-ordem-2.it-codigo  = movto-mat.it-codigo and
                         b-ordem-2.origem     = "SF"                and
                         b-ordem-2.valorizada = no no-lock) )
 or
        ( CAN-FIND (FIRST funcao WHERE funcao.cd-funcao = "spp-mmv-impl" 
                                   AND funcao.ativo) and
          can-find(first b-ordem-2 where
                         b-ordem-2.it-codigo  = movto-mat.it-codigo and
                         b-ordem-2.origem     = "MV"                and
                         b-ordem-2.valorizada = no no-lock) )
 then assign l-ordem = yes. /* Tem ordens CP/MI/SF/MV */
 

  /* Verifica se o item possui alguma ordem movimentada no periodo. */
 if l-ordem = yes then do: 
   ordem-mv:
   for each b-ordem-2 fields(nr-ord-prod it-codigo) where
            b-ordem-2.it-codigo  = movto-mat.it-codigo and
            b-ordem-2.valorizada = no exclusive-lock:
       IF   can-find(first b-movto-mat where
                           b-movto-mat.nr-ord-prod  = b-ordem-2.nr-ord-prod and
                           b-movto-mat.dt-trans    >= da-inicio-calc and
                           b-movto-mat.dt-trans    <= da-data-fim) or
            can-find(first b-movto-ggf where
                           b-movto-ggf.nr-ord-prod  = b-ordem-2.nr-ord-prod and
                           b-movto-ggf.dt-trans    >= da-inicio-calc and
                           b-movto-ggf.dt-trans    <= da-data-fim) or
            can-find(first b-movto-dir where
                           b-movto-dir.nr-ord-prod  = b-ordem-2.nr-ord-prod and
                           b-movto-dir.dt-trans    >= da-inicio-calc and
                           b-movto-dir.dt-trans    <= da-data-fim)
       THEN do: 
          ASSIGN l-calcula = NO.
          LEAVE ordem-mv.
       END.
   end.
 end.
 

  /* Se for co-produto em alguma ordem deve ser calculado na 4 fase. */
 IF l-calcula = YES THEN DO:
    if can-find(first b-movto-mat where 
                      b-movto-mat.it-codigo =  movto-mat.it-codigo and                          
                      b-movto-mat.esp-docto =  1              and                          
                     (b-movto-mat.dt-trans  >= da-inicio-calc     and
                      b-movto-mat.dt-trans  <= da-data-fim)) 
    OR can-find(first b-movto-mat where 
                      b-movto-mat.it-codigo =  movto-mat.it-codigo and                          
                      b-movto-mat.esp-docto =  8              and                          
                     (b-movto-mat.dt-trans  >= da-inicio-calc     and
                      b-movto-mat.dt-trans  <= da-data-fim))           
      then ASSIGN l-calcula = NO.       
 END.

 END PROCEDURE.
