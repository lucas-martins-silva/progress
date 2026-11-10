/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172M 2.00.00.014 } /*** "010014" 17/10/2023 17:33:05 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172m MUT}
&ENDIF

{cdp/cdcfgman.i}

def temp-table tt-depos NO-UNDO
  field cod-depos  like deposito.cod-depos     
  field nome       like deposito.nome          
  field quantidade like movto-estoq.quantidade
  index dep cod-depos.   

def temp-table tt-raw-transfere NO-UNDO
   field raw-registro as RAW.

&if defined(bf-mat-comex) &then
&else
    {cpp/cp0318.i} /* tt-work */
&endif

{cep/ce1234.i} 

def input param p-it-codigo                as char no-undo.
def input param p-sequencia                as INT  no-undo.
def input param p-dt-validade              as date no-undo.
def input param p-cod-estabel              as char no-undo.
def input param p-lote                     as char no-undo.
def input param p-refer                    as char no-undo.
def input param l-consiste-valor-retorno   as log  no-undo.
def input param p-percentual-acrescimo     as dec  no-undo.
def input param p-ct-aplicacao as char no-undo.
def input param p-sc-aplicacao as char no-undo.

def input-output param table for tt-depos.
def input-output param table for tt-work. 
def input-output param table for tt-raw-transfere.
def input param lDesmonta                  as log  no-undo.

def var i-sequencia   as int format ">>9" no-undo.
def var i-fator       as decimal extent 22.
def var i-retorno     as integer.
def var c-item        like item.it-codigo.
def var c-refer       as char  no-undo.
def var r-end-ret     as rowid extent 22.
def var de-qtd-calc   as dec   no-undo.
def var de-qtd        as dec   no-undo.
def var i-x           as integer.
def var de-medio-mat  as decimal no-undo.
def var de-medio-mob  as decimal no-undo.
def var de-medio-ggf  as decimal no-undo.
DEF VAR r-estrutura AS ROWID NO-UNDO.
def var l-refer-incluida as logical no-undo initial no.
def var de-quantidade   as decimal no-undo initial 1.
def var de-quant-liq    as decimal no-undo initial 1.
def var da-data-corte   as date    no-undo initial today.
def var de-quant-usada  like estrutura.quant-usada no-undo.
define var c-refer-es   like ref-item.cod-refer.

def buffer b-estrutura for estrutura.
def buffer b-item   for item.
DEF BUFFER c-estrutura FOR estrutura.
DEF BUFFER b3-item FOR ITEM.

for each tt-depos exclusive-lock:
    delete tt-depos.
end.

for each tt-raw-transfere no-lock:
    create tt-depos.
    raw-transfer tt-raw-transfere.raw-registro to tt-depos.
end.

for each tt-work exclusive-lock:
    delete tt-work.
end.

find first item where item.it-codigo = p-it-codigo no-lock no-error.

assign i-sequencia = 0
       i-fator[1]  = 1
       i-retorno   = 1
       c-item      = item.it-codigo.

if lDesmonta then do:

/* Caso n’o seja o programa CP0318 que esteja chamando esta BO, a l½gica abaixo
   sera executada */

    comeco:
    repeat:
        find first estrutura where estrutura.it-codigo    = c-item        and
                                   estrutura.data-inicio <= p-dt-validade and
                                   estrutura.data-termino > p-dt-validade no-lock no-error.
        if not available estrutura and 
           i-retorno < 3 then
            leave.

        if i-retorno = 1 then
            assign i-retorno = i-retorno + 1
                   r-end-ret[i-retorno] = rowid(estrutura).

        repeat:
            if available estrutura then do:
            
                &if defined(bf_man_sfc_lc) &then
                    /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                    assign de-qtd-calc = if estrutura.log-quant-fix then estrutura.qtd-compon
                                         else estrutura.qtd-compon / estrutura.qtd-item.
                &else
                    assign de-qtd-calc = estrutura.quant-usada.
                &endif

                find item where item.it-codigo = estrutura.es-codigo no-lock no-error.
                
                /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                assign i-fator[i-retorno] = if estrutura.log-quant-fix then de-qtd-calc
                                            else i-fator[i-retorno - 1] * de-qtd-calc * estrutura.proporcao / 100
                       c-refer            = "".

                if estrutura.fantasma then do:
                    find first b-estrutura where b-estrutura.it-codigo    = estrutura.es-codigo and 
                                                 b-estrutura.data-inicio <= p-dt-validade and 
                                                 b-estrutura.data-termino > p-dt-validade no-lock no-error.
                    if not avail b-estrutura and 
                       item.it-codigo <> "" then do:

                        /* Se o comp. for controlado por refer¼ncia, procura a refer¼ncia associada
                           na estrutura */
                        if item.tipo-con-est = 4 then do:
                            find ref-estrut where ref-estrut.it-codigo  = estrutura.it-codigo and 
                                                  ref-estrut.sequencia  = estrutura.sequencia and 
                                                  ref-estrut.es-codigo  = estrutura.es-codigo and 
                                                  ref-estrut.cod-ref-it = p-refer no-lock no-error.
                            if avail ref-estrut then
                                assign c-refer = ref-estrut.cod-ref-es.
                        end.

                        /* GERA tt-work */
                        {cpp/cp0318.i1 estrutura i-fator[i-retorno] ITEM}
                    end.

                    find ref-estrut where ref-estrut.it-codigo  = estrutura.it-codigo and
                                          ref-estrut.sequencia  = estrutura.sequencia and
                                          ref-estrut.es-codigo  = estrutura.es-codigo and
                                          ref-estrut.cod-ref-it = p-refer no-lock no-error.

                    assign c-item               = estrutura.es-codigo
                           i-retorno            = i-retorno + 1
                           r-end-ret[i-retorno] = rowid(estrutura)
                           p-refer              = if avail ref-estrut then ref-estrut.cod-ref-es
                                                  else "".
.
                    next comeco.
                end.
                else do:
                    if item.it-codigo  <> "" and 
                       de-qtd-calc > 0 then do:

                        /* Se o comp. for controlado por refer¼ncia, procura a refer¼ncia associada
                           na estrutura */
                        if item.tipo-con-est = 4 then do:
                            find ref-estrut where ref-estrut.it-codigo  = estrutura.it-codigo and 
                                                  ref-estrut.sequencia  = estrutura.sequencia and 
                                                  ref-estrut.es-codigo  = estrutura.es-codigo and 
                                                  ref-estrut.cod-ref-es = p-refer no-lock no-error.
                            if avail ref-estrut then
                                assign c-refer = ref-estrut.cod-ref-es.
                        end.

                    end.

                    /* GERA tt-work */
                    {cpp/cp0318.i1 estrutura i-fator[i-retorno] ITEM}
                end.
            end.
            else do:
                if i-retorno = 2 then
                    leave comeco.
                else do:
                    find estrutura where rowid(estrutura) = r-end-ret[i-retorno] no-lock no-error.

                    assign c-item    = estrutura.it-codigo
                           i-retorno = i-retorno - 1.
                end.
            end.

            find next estrutura where estrutura.it-codigo    = c-item and 
                                      estrutura.data-inicio <= p-dt-validade and 
                                      estrutura.data-termino > p-dt-validade no-lock no-error.
        end.
    end.

    if p-ct-aplicacao <> "" then do:

        for each tt-work where tt-work.ct-codigo = "" exclusive-lock:

            find item where item.it-codigo = tt-work.it-codigo no-lock no-error.

            if item.tipo-contr = 2 then
                next.

            assign tt-work.ct-codigo = p-ct-aplicacao
                   tt-work.sc-codigo = p-sc-aplicacao
                   .
        END.
    END.
END.
else do:

    assign c-refer = p-refer.
    
    FIND FIRST ITEM WHERE ITEM.it-codigo = c-item NO-LOCK NO-ERROR.
    
    DEFINE TEMP-TABLE tt-proces-item NO-UNDO
        LIKE proces-item.
    	
    DEFINE VARIABLE h-enapi607 AS HANDLE      NO-UNDO.
    RUN enp/enapi607.p PERSISTENT SET h-enapi607.
    IF VALID-HANDLE(h-enapi607) THEN DO:
        RUN generateProcessList IN h-enapi607(INPUT item.it-codigo,
                                              INPUT ?,
                                              INPUT p-cod-estabel,
                                              INPUT c-refer,
                                              INPUT ?,
                                              INPUT ?,
                                              INPUT YES,
                                              INPUT "",
                                              INPUT-OUTPUT TABLE tt-proces-item).
        DELETE PROCEDURE h-enapi607.
        ASSIGN h-enapi607 = ?.
    END.
 
    FOR EACH tt-proces-item
       WHERE tt-proces-item.it-codigo = item.it-codigo
         AND (tt-proces-item.sequencia = p-sequencia OR p-sequencia = 0):

        for each estrutura fields (data-inicio data-termino  es-codigo quant-usada it-codigo
                                   proporcao   fator-perda   it-codigo sequencia cod-lista-compon
                                   fantasma    log-quant-fix )
            WHERE estrutura.it-codigo = ITEM.it-codigo
              AND estrutura.cod-lista-compon = tt-proces-item.cod-lista-compon NO-LOCK:
            
            if (estrutura.data-inicio  <= da-data-corte and
                estrutura.data-termino > da-data-corte) or da-data-corte = ? then do:
                for first b-item fields (it-codigo tipo-con-est compr-fabric) where 
                    b-item.it-codigo = estrutura.es-codigo no-lock: end.
                    if not avail b-item then next.

                    /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                assign de-quant-usada = if estrutura.log-quant-fix then estrutura.quant-usada
                                        else estrutura.quant-usada * de-quantidade * (estrutura.proporcao / 100)
                       de-quant-liq   = if estrutura.log-quant-fix then estrutura.quant-usada
                                        else (estrutura.quant-usada * de-quantidade * estrutura.proporcao / 100) * (1 - (estrutura.fator-perda / 100)).             
        
                if b-item.tipo-con-est = 4 or 
                   item.tipo-con-est   = 4 then do:
                    find first ref-estrut where 
                               ref-estrut.it-codigo = estrutura.it-codigo and  
                               ref-estrut.es-codigo = estrutura.es-codigo and
                               ref-estrut.sequencia = estrutura.sequencia no-lock no-error.
                    if not available ref-estrut then
                       assign c-refer-es       = ""
                              l-refer-incluida = yes.
                    else do:
                        find first ref-estrut where 
                            ref-estrut.it-codigo  = estrutura.it-codigo and  
                            ref-estrut.cod-ref-it = c-refer and  
                            ref-estrut.es-codigo  = estrutura.es-codigo and
                            ref-estrut.sequencia  = estrutura.sequencia no-lock no-error.
                        if available ref-estrut then          
                            assign c-refer-es = ref-estrut.cod-ref-es
                                   l-refer-incluida = yes.
                        else          
                            assign l-refer-incluida = no.
                    end.
                end.
                else
                    assign l-refer-incluida = yes
                           c-refer-es       = ''.
        
                if l-refer-incluida then do:
                    assign r-estrutura = rowid(estrutura).
        
                    FIND FIRST c-estrutura WHERE
                        ROWID(c-estrutura) = r-estrutura NO-LOCK NO-ERROR.
        
                    /* GERA tt-work */
                    IF NOT c-estrutura.fantasma THEN DO:
                        FIND FIRST b3-item WHERE
                            b3-item.it-codigo = c-estrutura.es-codigo NO-LOCK NO-ERROR.
        
                        {cpp/cp0318.i1 c-estrutura de-quant-liq b3-item}
                    END.
                    
                    if estrutura.fantasma = YES THEN   
                       run pi-gera-tt-work-filho(rowid(b-item), c-refer-es, de-quant-usada, de-quant-liq).
                END.
            END.
        END.
    END.

/**************************************************************************************************/
PROCEDURE pi-gera-tt-work-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter v-row-item as rowid no-undo.
define input parameter c-refer as char no-undo.
define input parameter p-quantidade as decimal no-undo.
define input parameter p-quant-liq  as decimal no-undo.

define buffer b1-item for item.
define buffer b2-item for item.
define buffer b-estrutura for estrutura.
define var de-quant-usada as decimal.

for first b1-item fields ( it-codigo tipo-con-est) where 
     rowid(b1-item) = v-row-item no-lock: end.

for each b-estrutura fields (data-inicio data-termino  es-codigo quant-usada
                             proporcao   fator-perda   it-codigo sequencia
                             fantasma    log-quant-fix ) of b1-item no-lock:
    if (b-estrutura.data-inicio  <= da-data-corte and
        b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:
        for first b2-item fields (it-codigo tipo-con-est compr-fabric) where 
            b2-item.it-codigo = b-estrutura.es-codigo no-lock: end.
        if not avail b2-item then next.
        /* D_MAN002 - Quantidade fixa para componentes de engenharia */
        assign de-quant-usada = if b-estrutura.log-quant-fix then b-estrutura.quant-usada
                                else b-estrutura.quant-usada * p-quantidade * (b-estrutura.proporcao / 100)
               de-quant-liq   = if b-estrutura.log-quant-fix then b-estrutura.quant-usada
                                else (b-estrutura.quant-usada * p-quantidade * b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).            
        if  b2-item.tipo-con-est = 4 or 
            b1-item.tipo-con-est = 4 then do:
            find first ref-estrut where 
                        ref-estrut.it-codigo = b-estrutura.it-codigo and  
                        ref-estrut.es-codigo = b-estrutura.es-codigo and
                        ref-estrut.sequencia = b-estrutura.sequencia no-lock no-error.
            
            if  not available ref-estrut then
                assign c-refer-es       = ""
                       l-refer-incluida = yes.
            else do:
                find first ref-estrut where 
                    ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                    ref-estrut.cod-ref-it = c-refer and  
                    ref-estrut.es-codigo  = b-estrutura.es-codigo and
                    ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
                  
                if available ref-estrut then
                    assign c-refer-es = ref-estrut.cod-ref-es
                           l-refer-incluida = yes.
                else   
                    assign l-refer-incluida = no.
            end.          
        end.
    else
        assign l-refer-incluida = yes
               c-refer-es       = ''.

        if l-refer-incluida then do:
            assign r-estrutura = rowid(b-estrutura).

            FIND FIRST c-estrutura WHERE
                ROWID(c-estrutura) = r-estrutura NO-LOCK NO-ERROR.

            /* GERA tt-work */
            IF NOT c-estrutura.fantasma THEN DO:
                FIND FIRST b3-item WHERE
                    b3-item.it-codigo = c-estrutura.es-codigo NO-LOCK NO-ERROR.

                {cpp/cp0318.i1 c-estrutura de-quant-liq b3-item}
            END.

            if  b-estrutura.fantasma = YES THEN   
                run pi-gera-tt-work-filho(rowid(b2-item), c-refer-es, de-quant-usada, de-quant-liq).
        end.
   end.

end.

      
END PROCEDURE.

end.
