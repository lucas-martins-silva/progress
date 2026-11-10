/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/** {1} = Nome da P gina **/

/*------------------------------------------------------------------------------
  Purpose:     piItem
  Parameters:  entrada pPosto = C¢digo Posto
  Notes:       Verifica Atributos do item e habilita/desabilita campos em tela
------------------------------------------------------------------------------*/
procedure piItem:

define input parameter pPosto like mab-posto.cod-posto no-undo.
define input parameter pAcao  as   character           no-undo.

define variable iTpContEst  as   integer                no-undo.
define variable lLocaliz    as   logical                no-undo.
define variable cCodLocaliz like {&ttTable}.cod-localiz no-undo.
define variable dePreco     like {&ttTable}.val-mater-1 no-undo.
define variable cEstab      like mab-posto.cod-estabel    no-undo.

define buffer bfItem for item.
define buffer bfPosto for mab-posto.
DEFINE BUFFER bfItem-Estab FOR item-uni-estab.

/** Busca Atributos do Item **/
for first bfItem fields(tipo-con-est loc-unica cod-localiz preco-ul-ent)
    where bfItem.it-codigo = input frame {1} {&tttable}.it-codigo no-lock:
    assign iTpContEst  = bfItem.tipo-con-est
           lLocaliz    = bfItem.loc-unica
           cCodLocaliz = bfItem.cod-localiz
           dePreco     = bfItem.preco-ul-ent.
end.
/** Busca Estabelecimento **/
for first bfPosto fields(cod-depos idi-posto cod-estab)
    where bfPosto.cod-posto = pPosto no-lock:
    assign cEstab    = bfPosto.cod-estabel.
end.
/** Busca na tabela item-uni-estab a localiza‡Æo do item **/
FOR FIRST bfItem-Estab FIELDS(it-codigo cod-estabel cod-localiz)
     WHERE bfItem-Estab.it-codigo = input frame {1} {&tttable}.it-codigo AND
           bfItem-Estab.cod-estabel = cEstab NO-LOCK:
    ASSIGN cCodLocaliz = bfItem-Estab.cod-localiz.
END.



assign /** Referˆncia **/
       {&ttTable}.cod-refer:sensitive in frame {1}   = if iTpContEst = 4 then yes else no
       {&ttTable}.cod-refer                             = ""
       /** Localiza‡Æo **/
       {&ttTable}.cod-localiz:sensitive in frame {1} = if lLocaliz then no else yes
       {&ttTable}.cod-localiz                           = cCodLocaliz
       /** Lote **/
       {&ttTable}.lote:sensitive in frame {1}        = if iTpContEst <> 1 then yes else no
       {&ttTable}.lote                                  = ""
       /** val-quant **/
       {&ttTable}.val-quant:sensitive in frame {1}   = if iTpContEst <> 2 then yes else no
       {&ttTable}.val-quant                             = if iTpContEst <> 2 then 0 else 1.

/** Valor **/
case iTpValor:
    /** NÆo Busca Valor EMS **/
    when 1 then do:
        assign {&ttTable}.val-mater-1:sensitive in frame {1} = yes.
    end.
    /** Pre‡o M‚dio **/
    when 2 then do:
        /** Busca Pre‡o M‚dio **/
        for first item-estab 
            where item-estab.it-codigo   = input frame {1} {&tttable}.it-codigo
            and   item-estab.cod-estabel = cEstab no-lock:
            assign {&ttTable}.val-mater-1:sensitive in frame {1} = no
                   dePrecoMater                                     = item-estab.val-unit-mat-m[1]
                                                                    + item-estab.val-unit-mob-m[1]
                                                                    + item-estab.val-unit-ggf-m[1].
        end.
        /** Mostra Pre‡o Total **/
        if iTpContEst = 2 then do:
            assign {&ttTable}.val-mater-1 = {&ttTable}.val-quant * dePrecoMater.
        end.
    end.
    /** Pre‡o éltima Entrada **/
    when 3 then do:
        assign {&ttTable}.val-mater-1:sensitive in frame {1} = no.
        /** EMS 2.04B em diante **/
        &IF defined(bf_man_custeio_item) &THEN
            /** Busca Pre‡o Ultima Entrada **/
            for first item-uni-estab fields(preco-ul-ent)
                where item-uni-estab.it-codigo   = input frame {1} {&tttable}.it-codigo
                and   item-uni-estab.cod-estabel = cEstab no-lock:
                assign dePrecoMater = item-uni-estab.preco-ul-ent.
            end.
        /** EMS 2.00 a EMS 2.04 **/
        &ELSE
            assign dePrecoMater = dePreco.
        &ENDIF
        /** Mostra Pre‡o Total **/
        if iTpContEst = 2 then do:
            assign {&ttTable}.val-mater-1 = {&ttTable}.val-quant * dePrecoMater.
        end.
    end.
end case.

if pAcao = "ADD":U  or
   pAcao = "COPY":U then do:
    /** Mostra Campos em tela **/
    display {&ttTable}.cod-refer
            {&ttTable}.cod-localiz
            {&ttTable}.lote       
            {&ttTable}.val-quant  
            {&ttTable}.val-mater-1
        with frame {1}.
    APPLY "leave":U TO {&ttTable}.cod-localiz IN FRAME {1}.
end.

return "OK":U.

end procedure.

procedure piPrecoItem:

define input parameter pPosto like mab-posto.cod-posto no-undo.
define variable cEstab      like mab-posto.cod-estabel    no-undo.
define variable iTpContEst  as   integer                no-undo.
define variable dePreco     like {&ttTable}.val-mater-1 no-undo.

define buffer bfItem for item.
define buffer bfPosto for mab-posto.


/** Busca Estabelecimento **/
for first bfPosto fields(cod-depos idi-posto cod-estab)
    where bfPosto.cod-posto = pPosto no-lock:
    assign cEstab    = bfPosto.cod-estabel.
end.

if iTpValor <> 1 and 
   avail bfposto and 
   bfposto.idi-posto = 2 then return "NOK":U.

/** Busca Atributos do Item **/
for first bfItem fields(tipo-con-est loc-unica cod-localiz preco-ul-ent)
    where bfItem.it-codigo = input frame {1} {&tttable}.it-codigo no-lock:
    assign iTpContEst  = bfItem.tipo-con-est
           dePreco     = bfItem.preco-ul-ent.
end.

/** Valor **/
case iTpValor:
    
    when 1 then do:
        /** Busca Pre‡o M‚dio **/
        FIND LAST mgf-cust-item-estoq
            WHERE mgf-cust-item-estoq.it-codigo   = input frame {1} {&tttable}.it-codigo 
             AND  mgf-cust-item-estoq.cod-estabel = cEstab NO-LOCK NO-ERROR.
             IF AVAIL mgf-cust-item-estoq THEN DO:
                 ASSIGN dePrecoMater  = mgf-cust-item-estoq.val-mater-1.
             END.
             ELSE DO:
                 FIND LAST mgf-cust-item-estoq
                   WHERE mgf-cust-item-estoq.it-codigo   = input frame {1} {&tttable}.it-codigo 
                    AND  mgf-cust-item-estoq.cod-estabel = "*" NO-LOCK NO-ERROR.
                    IF AVAIL mgf-cust-item-estoq THEN DO:
                         ASSIGN dePrecoMater  = mgf-cust-item-estoq.val-mater-1.
                    END.
             END.
             
        /** Mostra Pre‡o Total **/
        if iTpContEst = 2 then do:
            assign {&ttTable}.val-mater-1 = {&ttTable}.val-quant * dePrecoMater.
        end.
    END.
    /** Pre‡o M‚dio **/
    when 2 then do:
        /** Busca Pre‡o M‚dio **/
        for first item-estab 
            where item-estab.it-codigo   = input frame {1} {&tttable}.it-codigo
            and   item-estab.cod-estabel = cEstab no-lock:
            assign dePrecoMater                                     = item-estab.val-unit-mat-m[1]
                                                                    + item-estab.val-unit-mob-m[1]
                                                                    + item-estab.val-unit-ggf-m[1].
        end.
        /** Mostra Pre‡o Total **/
        if iTpContEst = 2 then do:
            assign {&ttTable}.val-mater-1 = {&ttTable}.val-quant * dePrecoMater.
        end.
    end.
    /** Pre‡o éltima Entrada **/
    when 3 then do:
        assign {&ttTable}.val-mater-1:sensitive in frame {1} = no.
        /** Busca Pre‡o Ultima Entrada **/
        for first item-uni-estab fields(preco-ul-ent)
            where item-uni-estab.it-codigo   = input frame {1} {&tttable}.it-codigo
            and   item-uni-estab.cod-estabel = cEstab no-lock:
            assign dePrecoMater = item-uni-estab.preco-ul-ent.
        end.
        IF dePrecoMater <= 0 OR dePrecoMater = ? THEN DO:
            assign dePrecoMater = dePreco.
        END.
        /** Mostra Pre‡o Total **/
        if iTpContEst = 2 then do:
            assign {&ttTable}.val-mater-1 = {&ttTable}.val-quant * dePrecoMater.
        end.
    end.
end case.
 display {&ttTable}.val-mater-1 with frame {1}.
 

return "OK":U.

end procedure.
