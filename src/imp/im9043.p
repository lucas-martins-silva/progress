/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9043 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9043 MIM}
&ENDIF

/*
** Aliquota IPI na Importacao
*/ 
DEF INPUT PARAMETER p-usuario       LIKE param-re.usuario          NO-UNDO.
DEF INPUT PARAMETER p-numero-ordem  LIKE ordem-compra.numero-ordem NO-UNDO.
DEF INPUT PARAMETER p-it-codigo     LIKE ITEM.it-codigo            NO-UNDO.
DEF OUTPUT PARAMETER p-aliquota-ipi LIKE ITEM.aliquota-ipi         NO-UNDO.

{cdp/cdcfgmat.i} /* include pre-processadores */

{cdp/cd4300.i3}
&if '{&bf_mat_versao_ems}' >= '2.062' &then
    {ocp/oc0201.i50}
&else
    {ccp/cc0303.i50}
&endif

FOR FIRST cotacao-item FIELDS (aliquota-ipi char-1 it-codigo aliquota-ipi
                               &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
                               cdn-pais-orig
                               &endif
                               &if defined(bf-mat-comex) &then
                               &else 
                                   char-2 
                               &endif)
    WHERE cotacao-item.numero-ordem = p-numero-ordem 
      AND cotacao-item.cot-aprovada NO-LOCK:

  &if defined (bf-mat-comex) &then
    assign i-regime-import-i50  = integer(substring(cotacao-item.char-1,42,2)).
  &else
    {cdp/cd4300.i4 "yes" cotacao-item.char-2}
    &if '{&bf_mat_versao_ems}' >= '2.062' &then
        {ocp/oc0201.i51 "yes"}
    &else
        {ccp/cc0303.i51 "yes"}
    &endif
  &endif
  
END.
&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then

    find first item
         where item.it-codigo = cotacao-item.it-codigo no-lock no-error.

    if  i-regime-import-i50 <> 0 
    and i-regime-import-i50 <> ? then do:
    
        if  avail item then do:
    
            find first pais-aliquota
                where pais-aliquota.cod-pais      = cotacao-item.cdn-pais-orig
                and   pais-aliquota.regime-import = i-regime-import-i50 
                and   pais-aliquota.class-fiscal  = if  item.tipo-contr = 4 then 
                                                        substring(cotacao-item.char-1,81,20) 
                                                    else 
                                                        item.class-fiscal no-lock no-error.
            if  avail pais-aliquota
            and pais-aliquota.log-ipi-especial then do:
    
                find first ordem-compra
                    where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.
                if  avail ordem-compra then
                    find first param-imp
                        where param-imp.cod-estabel = ordem-compra.cod-estabel no-lock no-error.
        
                if  pais-aliquota.cod-natur-operac-ipi <> "" 
                and pais-aliquota.aliquota-ipi = 0 then do:
                    if  avail param-imp
                    and param-imp.log-cotac-autom-ipi then do:
                        if  item.tipo-contr = 4 then do:
                            find classif-fisc
                                where classif-fisc.class-fiscal = ITEM.class-fiscal no-lock no-error.
                            if avail classif-fisc then                                 
                                assign p-aliquota-ipi = classif-fisc.aliquota-ipi.
                        end.
                        else
                            assign p-aliquota-ipi = item.aliquota-ipi.
                    end.
                    else
                        assign p-aliquota-ipi = cotacao-item.aliquota-ipi.
                end.
                else do:
                    if  avail param-imp 
                    and param-imp.log-cotac-autom-ipi then
                        assign p-aliquota-ipi = pais-aliquota.aliquota-ipi.
                    else
                        assign p-aliquota-ipi = cotacao-item.aliquota-ipi.
                end.
            end.
            else if  item.tipo-contr = 4 then do:
                find classif-fisc
                    where classif-fisc.class-fiscal = ITEM.class-fiscal no-lock no-error.
                if  avail classif-fisc then                                 
                    assign p-aliquota-ipi = classif-fisc.aliquota-ipi.
            end.
            else
                assign p-aliquota-ipi = item.aliquota-ipi.
    
        end.
    end.
    else do:
        if  item.tipo-contr = 4 then do:
            find classif-fisc
                where classif-fisc.class-fiscal = ITEM.class-fiscal no-lock no-error.
            if  avail classif-fisc then                                 
                assign p-aliquota-ipi = classif-fisc.aliquota-ipi.
        end.
        ELSE DO:
            FOR FIRST param-re FIELDS (orig-aliq-ip)
                WHERE param-re.usuario = p-usuario NO-LOCK:
                if  param-re.orig-aliq-ip  = 2 then
                    assign p-aliquota-ipi = item.aliquota-ipi.
                ELSE DO:
                    find classif-fisc
                        where classif-fisc.class-fiscal = ITEM.class-fiscal no-lock no-error.
                    if avail classif-fisc then
                        assign p-aliquota-ipi = classif-fisc.aliquota-ipi.
                END.

            END.
        END.
    end.

&ELSE
    IF i-regime-import-i50 <> 0 AND 
       i-regime-import-i50 <> ? THEN 
        ASSIGN p-aliquota-ipi = cotacao-item.aliquota-ipi.
    ELSE DO:
    
        FOR FIRST param-re FIELDS (orig-aliq-ip)
            WHERE param-re.usuario = p-usuario NO-LOCK:
        END.
    
        FOR FIRST ITEM FIELDS (aliquota-ipi class-fiscal)
            WHERE ITEM.it-codigo = p-it-codigo NO-LOCK:
        END.
    
        IF AVAIL param-re THEN DO:
            if  param-re.orig-aliq-ip = 1 then do:
                find classif-fisc
                    where classif-fisc.class-fiscal = ITEM.class-fiscal no-lock no-error.
                if avail classif-fisc then
                    assign p-aliquota-ipi = classif-fisc.aliquota-ipi.
            end.
            else
                assign p-aliquota-ipi = item.aliquota-ipi.
        END.
    END.
&ENDIF

