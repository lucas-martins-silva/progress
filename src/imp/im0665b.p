/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0665B 2.00.00.027 } /*** "010027" 17/08/2026 02:49:40 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0665b MIM}
&ENDIF

/******************************************************************************
**
**       PROGRAMA:  IM0665B.P
**
**       DATA....:  FEVEREIRO DE 2003
**
**       OBJETIVO:  Custo Real de Importa‡Æo / Por Embarque - Resumido
**
**       VERSAO..:  1.00.000 - Ivonei Vock
**
******************************************************************************/

{cdp/cdcfgmat.i}
{imp/im0665.i} /* Defini‡Æo tt-param          **
               ** Defini‡Æo tt-detalha-item   **
               ** Defini‡Æo tt-embarque-cabec **
               ** Defini‡Æo tt-embarque-corpo */
{imp/im0665.i1} /* Defini‡Æo das Frames */

DEF INPUT  PARAM TABLE FOR tt-param.
DEF INPUT  PARAM TABLE FOR tt-detalha-item.
DEF INPUT  PARAM TABLE FOR tt-embarque-cabec.
DEF INPUT  PARAM TABLE FOR tt-embarque-corpo.
DEF OUTPUT PARAM bh-dados-excel        AS HANDLE NO-UNDO. 
DEF OUTPUT PARAM bh-dados-excel-detail AS HANDLE NO-UNDO. 
DEF OUTPUT PARAM bh-dados-excel-total  AS HANDLE NO-UNDO. 

DEFINE VARIABLE hQuery                 AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQueryDetail           AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQueryTotal            AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel        AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel-detail AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel-total  AS HANDLE      NO-UNDO.

FIND FIRST tt-param.

FOR EACH tt-embarque-corpo-agr:
    DELETE tt-embarque-corpo-agr.
END.

IF tt-param.excel THEN DO:
    
    CREATE TEMP-TABLE tth-dados-excel.
    {utp/ut-liter.i Estabelecimento *}
    tth-dados-excel:add-new-field("cod-estabel",tt-embarque-corpo.cod-estabel:DATA-TYPE,?,tt-embarque-corpo.cod-estabel:format,?,return-value). 
    {utp/ut-liter.i Descri‡Æo *}
    tth-dados-excel:add-new-field("desc-estabel",tt-embarque-corpo.desc-estabel:DATA-TYPE,?,tt-embarque-corpo.desc-estabel:format,?,return-value). 
    {utp/ut-liter.i Embarque *}
    tth-dados-excel:add-new-field("embarque",tt-embarque-corpo.embarque:DATA-TYPE,?,tt-embarque-corpo.embarque:format,?,return-value). 
    {utp/ut-liter.i Exportador *}
    tth-dados-excel:add-new-field("cod-emitente",tt-embarque-corpo.cod-emitente:DATA-TYPE,?,tt-embarque-corpo.cod-emitente:format,?,return-value). 
    {utp/ut-liter.i Ponto_de_Despacho *}
    tth-dados-excel:ADD-NEW-FIELD("pto-despacho","CHAR",?,"x(100)",?,RETURN-VALUE).
    {utp/ut-liter.i Data_élt_Prev_Despacho *}
    tth-dados-excel:ADD-NEW-FIELD("data-ult-prev-desp","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Despacho *}
    tth-dados-excel:ADD-NEW-FIELD("data-despacho","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Ponto_de_Embarque *}
    tth-dados-excel:ADD-NEW-FIELD("pto-embarque","CHAR",?,"x(100)",?,RETURN-VALUE).       
    {utp/ut-liter.i Data_élt_Prev_Embarque *}
    tth-dados-excel:ADD-NEW-FIELD("data-ult-prev-embarque","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Embarque *}
    tth-dados-excel:ADD-NEW-FIELD("data-embarque","DATE",?,"99/99/9999":U,?,RETURN-VALUE).         
    {utp/ut-liter.i Ponto_de_Nacionaliza‡Æo *}
    tth-dados-excel:ADD-NEW-FIELD("pto-nacional","CHAR",?,"x(100)",?,RETURN-VALUE).           
    {utp/ut-liter.i Data_élt_PrevisÆo_Nacionaliza‡Æo *}
    tth-dados-excel:ADD-NEW-FIELD("data-ult-prev-nac","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Nacionaliza‡Æo *}
    tth-dados-excel:ADD-NEW-FIELD("data-nacional","DATE",?,"99/99/9999":U,?,RETURN-VALUE).    
    {utp/ut-liter.i Ponto_de_Chegada *}
    tth-dados-excel:ADD-NEW-FIELD("pto-chegada","CHAR",?,"x(100)",?,RETURN-VALUE).            
    {utp/ut-liter.i Data_élt_PrevisÆo_Chegada *}
    tth-dados-excel:ADD-NEW-FIELD("data-ult-prev-chegada","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Chegada_na_F brica *}
    tth-dados-excel:ADD-NEW-FIELD("data-chegada","DATE",?,"99/99/9999":U,?,RETURN-VALUE).         
    {utp/ut-liter.i Vl_Embarque *}
    tth-dados-excel:add-new-field("vl-ger-tot-com-ipi-icms-merc-rea",tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea:data-type,?,tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea:format,?,return-value). 
    {utp/ut-liter.i Vl_Merc *}
    tth-dados-excel:add-new-field("vl-ger-mercado-rea",tt-embarque-corpo.vl-ger-mercado-rea:data-type,?,tt-embarque-corpo.vl-ger-mercado-rea:format,?,return-value). 
    {utp/ut-liter.i Total_Desp *}
    tth-dados-excel:add-new-field("vl-ger-tot-des-rea",tt-embarque-corpo.vl-ger-tot-des-rea:data-type,?,tt-embarque-corpo.vl-ger-tot-des-rea:format,?,return-value). 
    {utp/ut-liter.i Impostos *}
    tth-dados-excel:add-new-field("vl-ger-tot-imp-rea",tt-embarque-corpo.vl-ger-tot-imp-rea:data-type,?,tt-embarque-corpo.vl-ger-tot-imp-rea:format,?,return-value). 
    {utp/ut-liter.i %_Merc *}
    tth-dados-excel:add-new-field("per-mercado",tt-embarque-corpo.per-mercado:data-type,?,tt-embarque-corpo.per-mercado:format,?,return-value). 
    {utp/ut-liter.i %_Desp *}
    tth-dados-excel:add-new-field("per-despesa",tt-embarque-corpo.per-despesa:data-type,?,tt-embarque-corpo.per-despesa:format,?,return-value). 
    {utp/ut-liter.i %_Impt *}
    tth-dados-excel:add-new-field("per-imposto",tt-embarque-corpo.per-imposto:data-type,?,tt-embarque-corpo.per-imposto:format,?,return-value). 

    CREATE TEMP-TABLE tth-dados-excel-detail. /*cria a temp-table da handle*/

    {utp/ut-liter.i Item *}
    tth-dados-excel-detail:ADD-NEW-FIELD("it-codigo",tt-detalha-item.it-codigo:DATA-TYPE,?,tt-detalha-item.it-codigo:format,?,RETURN-VALUE).
    IF tt-param.l-desp-imposto THEN DO:
        {utp/ut-liter.i Descri‡Æo *}
        tth-dados-excel-detail:ADD-NEW-FIELD("descricao",tt-detalha-item.descricao:DATA-TYPE,?,tt-detalha-item.descricao:format,?,RETURN-VALUE).
    END.
    {utp/ut-liter.i Estabelecimento *}
    tth-dados-excel-detail:ADD-NEW-FIELD("cod-estabel",tt-detalha-item.cod-estabel:DATA-TYPE,?,tt-detalha-item.cod-estabel:format,?,RETURN-VALUE).
    {utp/ut-liter.i Embarque *}
    tth-dados-excel-detail:ADD-NEW-FIELD("embarque",tt-detalha-item.embarque:DATA-TYPE,?,tt-detalha-item.embarque:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Item *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea",tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Valor_Merc *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-mercado-rea",tt-detalha-item.vl-mercado-rea:DATA-TYPE,?,tt-detalha-item.vl-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Despesas *}
    tth-dados-excel-detail:ADD-NEW-FIELD("valor-total-despesa","DEC",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).   
    {utp/ut-liter.i Total_Impostos *}
    tth-dados-excel-detail:ADD-NEW-FIELD("valor-total-imposto","DEC",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).
    {utp/ut-liter.i %_Vl_Merc *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-mercado-rea",tt-detalha-item.per-mercado-rea:DATA-TYPE,?,tt-detalha-item.per-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i %_Total_Despesas *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-des-rea",tt-detalha-item.per-tot-des-rea:DATA-TYPE,?,tt-detalha-item.per-tot-des-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i %_Total_Impostos *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-imp-rea",tt-detalha-item.per-tot-imp-rea:DATA-TYPE,?,tt-detalha-item.per-tot-imp-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Quantidade *}
    tth-dados-excel-detail:ADD-NEW-FIELD("quantidade",tt-detalha-item.quantidade:DATA-TYPE,?,tt-detalha-item.quantidade:format,?,RETURN-VALUE).  
    {utp/ut-liter.i UN *}
    tth-dados-excel-detail:ADD-NEW-FIELD("un",tt-detalha-item.un:DATA-TYPE,?,tt-detalha-item.un:format,?,RETURN-VALUE).
    

    if tt-param.l-desp-imposto THEN DO:
        {utp/ut-liter.i %_II *}
        tth-dados-excel:add-new-field("per-ii",tt-embarque-corpo.per-ii:data-type,?,tt-embarque-corpo.per-ii:format,?,return-value). 
        {utp/ut-liter.i II *}
        tth-dados-excel:add-new-field("vl-ger-ii-rea",tt-embarque-corpo.vl-ger-ii-rea:data-type,?,tt-embarque-corpo.vl-ger-ii-rea:format,?,return-value). 
        {utp/ut-liter.i IPI *}
        tth-dados-excel:add-new-field("vl-ger-ipi-rea    ",tt-embarque-corpo.vl-ger-ipi-rea    :data-type,?,tt-embarque-corpo.vl-ger-ipi-rea     :format,?,return-value). 

        {utp/ut-liter.i Aliq.II *}
        tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ii",tt-detalha-item.aliquota-ii:DATA-TYPE,?,tt-detalha-item.aliquota-ii:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i Aliq.IPI *}
        tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ipi",tt-detalha-item.aliquota-ipi:DATA-TYPE,?,tt-detalha-item.aliquota-ipi:FORMAT,?,RETURN-VALUE).
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            {utp/ut-liter.i CBS *}
            tth-dados-excel:add-new-field("vl-ger-cbs-rea",tt-embarque-corpo.vl-ger-cbs-rea:data-type,?,tt-embarque-corpo.vl-ger-cbs-rea:format,?,return-value). 
            {utp/ut-liter.i IBS_UF *}
            tth-dados-excel:add-new-field("vl-ger-ibs-uf-rea",tt-embarque-corpo.vl-ger-ibs-uf-rea:data-type,?,tt-embarque-corpo.vl-ger-ibs-uf-rea:format,?,return-value). 
            {utp/ut-liter.i IBS_MUN *}
            tth-dados-excel:add-new-field("vl-ger-ibs-mun-rea",tt-embarque-corpo.vl-ger-ibs-mun-rea:data-type,?,tt-embarque-corpo.vl-ger-ibs-mun-rea:format,?,return-value). 
            {utp/ut-liter.i IS *}
            tth-dados-excel:add-new-field("vl-ger-is-rea",tt-embarque-corpo.vl-ger-is-rea:data-type,?,tt-embarque-corpo.vl-ger-is-rea:format,?,return-value). 

            {utp/ut-liter.i Aliq.CBS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-cbs",tt-detalha-item.aliquota-cbs:DATA-TYPE,?,tt-detalha-item.aliquota-cbs:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IBS_UF *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ibs-uf",tt-detalha-item.aliquota-ibs-uf:DATA-TYPE,?,tt-detalha-item.aliquota-ibs-uf:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IBS_MUN *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ibs-mun",tt-detalha-item.aliquota-ibs-mun:DATA-TYPE,?,tt-detalha-item.aliquota-ibs-mun:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-is",tt-detalha-item.aliquota-is:DATA-TYPE,?,tt-detalha-item.aliquota-is:FORMAT,?,RETURN-VALUE).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
        ELSE DO:
            {utp/ut-liter.i ICMS *}
            tth-dados-excel:add-new-field("vl-ger-icms-rea   ",tt-embarque-corpo.vl-ger-icms-rea   :data-type,?,tt-embarque-corpo.vl-ger-icms-rea    :format,?,return-value). 
            {utp/ut-liter.i PIS *}
            tth-dados-excel:add-new-field("vl-ger-pis-rea    ",tt-embarque-corpo.vl-ger-pis-rea    :data-type,?,tt-embarque-corpo.vl-ger-pis-rea     :format,?,return-value). 
            {utp/ut-liter.i COFINS *}
            tth-dados-excel:add-new-field("vl-ger-cofins-rea ",tt-embarque-corpo.vl-ger-cofins-rea :data-type,?,tt-embarque-corpo.vl-ger-cofins-rea  :format,?,return-value). 
        
            {utp/ut-liter.i Aliq.PIS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-pis",tt-detalha-item.aliquota-pis:DATA-TYPE,?,tt-detalha-item.aliquota-pis:FORMAT,?,RETURN-VALUE).      
            {utp/ut-liter.i Aliq.COFINS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-cofins",tt-detalha-item.aliquota-cofins:DATA-TYPE,?,tt-detalha-item.aliquota-cofins:FORMAT,?,RETURN-VALUE).      
            {utp/ut-liter.i Aliq.ICMS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-icms",tt-detalha-item.aliquota-icms:DATA-TYPE,?,tt-detalha-item.aliquota-icms:FORMAT,?,RETURN-VALUE).      
        END.
        
        {utp/ut-liter.i II *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-item-ii-rea","dec",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).
        {utp/ut-liter.i %_II *}
        tth-dados-excel-detail:ADD-NEW-FIELD("per-ii-rea",tt-detalha-item.per-ii-rea:DATA-TYPE,?,tt-detalha-item.per-ii-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i IPI *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-ipi-rea",tt-detalha-item.vl-ipi-rea:DATA-TYPE,?,tt-detalha-item.vl-ipi-rea:FORMAT,?,RETURN-VALUE).
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            {utp/ut-liter.i CBS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-cbs-rea",tt-detalha-item.vl-cbs-rea:DATA-TYPE,?,tt-detalha-item.vl-cbs-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS_UF *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-uf-rea",tt-detalha-item.vl-ibs-uf-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-uf-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS_MUN *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-mun-rea",tt-detalha-item.vl-ibs-mun-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-mun-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-is-rea",tt-detalha-item.vl-is-rea:DATA-TYPE,?,tt-detalha-item.vl-is-rea:FORMAT,?,RETURN-VALUE).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
        ELSE DO:
            {utp/ut-liter.i PIS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-pis-rea",tt-detalha-item.vl-pis-rea:DATA-TYPE,?,tt-detalha-item.vl-pis-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i COFINS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-cofins-rea",tt-detalha-item.vl-cofins-rea:DATA-TYPE,?,tt-detalha-item.vl-cofins-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i ICMS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-icms-rea",tt-detalha-item.vl-icms-rea:DATA-TYPE,?,tt-detalha-item.vl-icms-rea:FORMAT,?,RETURN-VALUE).      
        END.
    END.

    {utp/ut-liter.i Frete *}
    tth-dados-excel:add-new-field("total-vl-frete",tt-embarque-corpo.total-vl-frete:data-type,?,tt-embarque-corpo.total-vl-frete:format,?,return-value). 
    {utp/ut-liter.i Embalagem *}
    tth-dados-excel:add-new-field("total-vl-embalagem",tt-embarque-corpo.total-vl-embalagem:data-type,?,tt-embarque-corpo.total-vl-embalagem:format,?,return-value). 
    {utp/ut-liter.i Seguro *}
    tth-dados-excel:add-new-field("total-vl-seguro",tt-embarque-corpo.total-vl-seguro:data-type,?,tt-embarque-corpo.total-vl-seguro:format,?,return-value). 
    {utp/ut-liter.i Outras *}
    tth-dados-excel:add-new-field("total-vl-outras",tt-embarque-corpo.total-vl-outras:data-type,?,tt-embarque-corpo.total-vl-outras:format,?,return-value). 

    {utp/ut-liter.i Frete *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-frete",tt-detalha-item.vl-des-frete:DATA-TYPE,?,tt-detalha-item.vl-des-frete:FORMAT,?,RETURN-VALUE).  
    {utp/ut-liter.i Embalagem *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-embalagem",tt-detalha-item.vl-des-embalagem:DATA-TYPE,?,tt-detalha-item.vl-des-embalagem:FORMAT,?,RETURN-VALUE).      
    {utp/ut-liter.i Seguro *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-seguro",tt-detalha-item.vl-des-seguro:DATA-TYPE,?,tt-detalha-item.vl-des-seguro:FORMAT,?,RETURN-VALUE).               
    {utp/ut-liter.i Outras *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-outras",tt-detalha-item.vl-des-outras:DATA-TYPE,?,tt-detalha-item.vl-des-outras:FORMAT,?,RETURN-VALUE).      

    /*Totais */
    CREATE TEMP-TABLE tth-dados-excel-total.
    {utp/ut-liter.i Estabelecimento *}
    tth-dados-excel-total:ADD-NEW-FIELD("cod-estabel",tt-embarque-corpo.cod-estabel:DATA-TYPE,?,tt-embarque-corpo.cod-estabel:format,?,RETURN-VALUE).
    {utp/ut-liter.i Descri‡Æo *}
    tth-dados-excel-total:add-new-field("desc-estabel",tt-embarque-corpo.desc-estabel:DATA-TYPE,?,tt-embarque-corpo.desc-estabel:format,?,return-value). 
    {utp/ut-liter.i Vl_Unit_M‚dio *} 
    tth-dados-excel-total:ADD-NEW-FIELD("vl-unit-medio-item","dec",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Valor_Merc *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-mercado-rea",tt-detalha-item.vl-mercado-rea:DATA-TYPE,?,tt-detalha-item.vl-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i %_Vl_Merc *}
    tth-dados-excel-total:ADD-NEW-FIELD("per-mercado-rea",tt-detalha-item.per-mercado-rea:DATA-TYPE,?,tt-detalha-item.per-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Despesas *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-tot-des-rea",tt-detalha-item.vl-tot-des-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-des-rea:format,?,RETURN-VALUE).   
    {utp/ut-liter.i %_Total_Despesas *}
    tth-dados-excel-total:ADD-NEW-FIELD("per-tot-des-rea",tt-detalha-item.per-tot-des-rea:DATA-TYPE,?,tt-detalha-item.per-tot-des-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Impostos *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-tot-imp-rea",tt-detalha-item.vl-tot-imp-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-imp-rea:format,?,RETURN-VALUE).   
    {utp/ut-liter.i %_Total_Impostos *}
    tth-dados-excel-total:ADD-NEW-FIELD("per-tot-imp-rea",tt-detalha-item.per-tot-imp-rea:DATA-TYPE,?,tt-detalha-item.per-tot-imp-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i II *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-est-ii-rea","dec",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).
    {utp/ut-liter.i %_II *}
    tth-dados-excel-total:ADD-NEW-FIELD("per-ii-rea",tt-detalha-item.per-ii-rea:DATA-TYPE,?,tt-detalha-item.per-ii-rea:FORMAT,?,RETURN-VALUE).
    {utp/ut-liter.i IPI *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-ipi-rea",tt-detalha-item.vl-ipi-rea:DATA-TYPE,?,tt-detalha-item.vl-ipi-rea:FORMAT,?,RETURN-VALUE).
    
    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
        {utp/ut-liter.i CBS *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-cbs-rea",tt-detalha-item.vl-cbs-rea:DATA-TYPE,?,tt-detalha-item.vl-cbs-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i IBS_UF *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-ibs-uf-rea",tt-detalha-item.vl-ibs-uf-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-uf-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i IBS_MUN *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-ibs-mun-rea",tt-detalha-item.vl-ibs-mun-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-mun-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i IS *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-is-rea",tt-detalha-item.vl-is-rea:DATA-TYPE,?,tt-detalha-item.vl-is-rea:FORMAT,?,RETURN-VALUE).
    END.
    /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
    ELSE DO:
        {utp/ut-liter.i PIS *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-pis-rea",tt-detalha-item.vl-pis-rea:DATA-TYPE,?,tt-detalha-item.vl-pis-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i COFINS *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-cofins-rea",tt-detalha-item.vl-cofins-rea:DATA-TYPE,?,tt-detalha-item.vl-cofins-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i ICMS *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-icms-rea",tt-detalha-item.vl-icms-rea:DATA-TYPE,?,tt-detalha-item.vl-icms-rea:FORMAT,?,RETURN-VALUE).      
    END.
    
    {utp/ut-liter.i Frete *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-des-frete",tt-detalha-item.vl-des-frete:DATA-TYPE,?,tt-detalha-item.vl-des-frete:FORMAT,?,RETURN-VALUE).  
    {utp/ut-liter.i Embalagem *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-des-embalagem",tt-detalha-item.vl-des-embalagem:DATA-TYPE,?,tt-detalha-item.vl-des-embalagem:FORMAT,?,RETURN-VALUE).      
    {utp/ut-liter.i Seguro *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-des-seguro",tt-detalha-item.vl-des-seguro:DATA-TYPE,?,tt-detalha-item.vl-des-seguro:FORMAT,?,RETURN-VALUE).               
    {utp/ut-liter.i Outras *}
    tth-dados-excel-total:ADD-NEW-FIELD("vl-des-outras",tt-detalha-item.vl-des-outras:DATA-TYPE,?,tt-detalha-item.vl-des-outras:FORMAT,?,RETURN-VALUE).      

    tth-dados-excel:TEMP-TABLE-PREPARE("dadosExcel"). 
    bh-dados-excel = tth-dados-excel:DEFAULT-BUFFER-HANDLE. 

    tth-dados-excel-detail:TEMP-TABLE-PREPARE("dadosExcelDetail"). 
    bh-dados-excel-detail = tth-dados-excel-detail:DEFAULT-BUFFER-HANDLE.

    tth-dados-excel-total:TEMP-TABLE-PREPARE("dadosExcelTotal").
    bh-dados-excel-total = tth-dados-excel-total:DEFAULT-BUFFER-HANDLE.

END.

for each tt-embarque-corpo
    break by tt-embarque-corpo.embarque:
    IF LAST-OF(tt-embarque-corpo.embarque) THEN DO:    
        find first tt-embarque-corpo-agr
             where tt-embarque-corpo-agr.embarque    = tt-embarque-corpo.embarque
               and tt-embarque-corpo-agr.cod-estabel = tt-embarque-corpo.cod-estabel no-error.
        if  not avail tt-embarque-corpo-agr then do:
            create tt-embarque-corpo-agr.
            assign tt-embarque-corpo-agr.embarque     = tt-embarque-corpo.embarque
                   tt-embarque-corpo-agr.cod-estabel  = tt-embarque-corpo.cod-estabel
                   tt-embarque-corpo-agr.desc-estabel = tt-embarque-corpo.desc-estabel
                   tt-embarque-corpo-agr.cod-emitente = tt-embarque-corpo.cod-emitente.
        end.
    
        assign tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea = tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea
                                                                 + tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
               tt-embarque-corpo-agr.vl-ger-mercado-rea          = tt-embarque-corpo-agr.vl-ger-mercado-rea
                                                                 + tt-embarque-corpo.vl-ger-mercado-rea
               tt-embarque-corpo-agr.vl-ger-tot-des-rea          = tt-embarque-corpo-agr.vl-ger-tot-des-rea
                                                                 + tt-embarque-corpo.vl-ger-tot-des-rea
               tt-embarque-corpo-agr.vl-ger-tot-imp-rea          = tt-embarque-corpo-agr.vl-ger-tot-imp-rea
                                                                 + tt-embarque-corpo.vl-ger-tot-imp-rea
               tt-embarque-corpo-agr.vl-ger-ii-rea               = tt-embarque-corpo-agr.vl-ger-ii-rea
                                                                 + tt-embarque-corpo.vl-ger-ii-rea
               tt-embarque-corpo-agr.vl-ger-ipi-rea              = tt-embarque-corpo-agr.vl-ger-ipi-rea
                                                                 + tt-embarque-corpo.vl-ger-ipi-rea
               tt-embarque-corpo-agr.vl-ger-icms-rea             = tt-embarque-corpo-agr.vl-ger-icms-rea
                                                                 + tt-embarque-corpo.vl-ger-icms-rea
               tt-embarque-corpo-agr.vl-ger-cofins-rea           = tt-embarque-corpo-agr.vl-ger-cofins-rea
                                                                 + tt-embarque-corpo.vl-ger-cofins-rea
               tt-embarque-corpo-agr.vl-ger-pis-rea              = tt-embarque-corpo-agr.vl-ger-pis-rea
                                                                 + tt-embarque-corpo.vl-ger-pis-rea
               tt-embarque-corpo-agr.total-vl-frete              = tt-embarque-corpo-agr.total-vl-frete
                                                                 + tt-embarque-corpo.total-vl-frete
               tt-embarque-corpo-agr.total-vl-embalagem          = tt-embarque-corpo-agr.total-vl-embalagem
                                                                 + tt-embarque-corpo.total-vl-embalagem
               tt-embarque-corpo-agr.total-vl-seguro             = tt-embarque-corpo-agr.total-vl-seguro
                                                                 + tt-embarque-corpo.total-vl-seguro
               tt-embarque-corpo-agr.total-vl-outras             = tt-embarque-corpo-agr.total-vl-outras
                                                                 + tt-embarque-corpo.total-vl-outras
               tt-embarque-corpo-agr.per-mercado                 = (tt-embarque-corpo-agr.vl-ger-mercado-rea
                                                                 / tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea) * 100
               tt-embarque-corpo-agr.per-despesa                 = (tt-embarque-corpo-agr.vl-ger-tot-des-rea
                                                                 / tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea) * 100
               tt-embarque-corpo-agr.per-imposto                 = (tt-embarque-corpo-agr.vl-ger-tot-imp-rea
                                                                 / tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea) * 100
               tt-embarque-corpo-agr.per-ii                      = (tt-embarque-corpo-agr.vl-ger-ii-rea
                                                                 / tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea) * 100.
                                                                 
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            ASSIGN tt-embarque-corpo-agr.vl-ger-cbs-rea      = tt-embarque-corpo-agr.vl-ger-cbs-rea      + tt-embarque-corpo.vl-ger-cbs-rea
                   tt-embarque-corpo-agr.vl-ger-ibs-uf-rea   = tt-embarque-corpo-agr.vl-ger-ibs-uf-rea   + tt-embarque-corpo.vl-ger-ibs-uf-rea
                   tt-embarque-corpo-agr.vl-ger-ibs-mun-rea  = tt-embarque-corpo-agr.vl-ger-ibs-mun-rea  + tt-embarque-corpo.vl-ger-ibs-mun-rea
                   tt-embarque-corpo-agr.vl-ger-is-rea       = tt-embarque-corpo-agr.vl-ger-is-rea       + tt-embarque-corpo.vl-ger-is-rea.
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
    end.
END.

for each tt-embarque-corpo-agr
    break by tt-embarque-corpo-agr.cod-estabel
          BY tt-embarque-corpo-agr.cod-emitente
          by tt-embarque-corpo-agr.embarque :

    IF  NOT tt-param.excel THEN
        if  first-of(tt-embarque-corpo-agr.cod-estabel) then do:
            put skip(1).
            disp tt-embarque-corpo-agr.cod-estabel  @ tt-embarque-corpo.cod-estabel
                 tt-embarque-corpo-agr.desc-estabel @ tt-embarque-corpo.desc-estabel
                 with frame f-estabel.
        end.
    /*EMBARQUE*/

    IF tt-param.excel THEN DO:

        bh-dados-excel:BUFFER-CREATE. 
        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(bh-dados-excel).
        hQuery:QUERY-PREPARE("FOR EACH dadosExcel"). 
        hQuery:QUERY-OPEN().  

        FOR FIRST tt-embarque-cabec
            WHERE tt-embarque-cabec.embarque     = tt-embarque-corpo-agr.embarque
              AND tt-embarque-cabec.cod-estabel  = tt-embarque-corpo-agr.cod-estabel
              AND tt-embarque-cabec.cod-emitente = tt-embarque-corpo-agr.cod-emitente NO-LOCK:

            ASSIGN bh-dados-excel:BUFFER-FIELD("pto-despacho"):BUFFER-VALUE           = tt-embarque-cabec.pto-despacho 
                   bh-dados-excel:BUFFER-FIELD("data-despacho"):BUFFER-VALUE          = tt-embarque-cabec.data-despacho
                   bh-dados-excel:BUFFER-FIELD("data-ult-prev-desp"):BUFFER-VALUE     = tt-embarque-cabec.data-ult-prev-desp
                   bh-dados-excel:BUFFER-FIELD("pto-embarque"):BUFFER-VALUE           = tt-embarque-cabec.pto-embarque 
                   bh-dados-excel:BUFFER-FIELD("data-embarque"):BUFFER-VALUE          = tt-embarque-cabec.data-embarque
                   bh-dados-excel:BUFFER-FIELD("data-ult-prev-embarque"):BUFFER-VALUE = tt-embarque-cabec.data-ult-prev-embarque
                   bh-dados-excel:BUFFER-FIELD("pto-nacional"):BUFFER-VALUE           = tt-embarque-cabec.pto-nacional 
                   bh-dados-excel:BUFFER-FIELD("pto-chegada"):BUFFER-VALUE            = tt-embarque-cabec.pto-chegada  
                   bh-dados-excel:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                   bh-dados-excel:BUFFER-FIELD("data-nacional"):BUFFER-VALUE          = tt-embarque-cabec.data-nacional
                   bh-dados-excel:BUFFER-FIELD("data-chegada"):BUFFER-VALUE           = tt-embarque-cabec.data-chegada
                   bh-dados-excel:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                   bh-dados-excel:BUFFER-FIELD("data-ult-prev-chegada"):BUFFER-VALUE  = tt-embarque-cabec.data-ult-prev-chegada.

        END.

        ASSIGN bh-dados-excel:buffer-field("cod-estabel"):buffer-value                      = tt-embarque-corpo-agr.cod-estabel
               bh-dados-excel:buffer-field("desc-estabel"):buffer-value                     = tt-embarque-corpo-agr.desc-estabel
               bh-dados-excel:buffer-field("embarque"):buffer-value                         = tt-embarque-corpo-agr.embarque
               bh-dados-excel:buffer-field("cod-emitente"):buffer-value                     = tt-embarque-corpo-agr.cod-emitente
               bh-dados-excel:buffer-field("vl-ger-tot-com-ipi-icms-merc-rea"):buffer-value = tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea
               bh-dados-excel:buffer-field("vl-ger-mercado-rea"):buffer-value               = tt-embarque-corpo-agr.vl-ger-mercado-rea
               bh-dados-excel:buffer-field("vl-ger-tot-des-rea"):buffer-value               = tt-embarque-corpo-agr.vl-ger-tot-des-rea
               bh-dados-excel:buffer-field("vl-ger-tot-imp-rea"):buffer-value               = tt-embarque-corpo-agr.vl-ger-tot-imp-rea
               bh-dados-excel:buffer-field("per-mercado"):buffer-value                      = tt-embarque-corpo-agr.per-mercado
               bh-dados-excel:buffer-field("per-despesa"):buffer-value                      = tt-embarque-corpo-agr.per-despesa
               bh-dados-excel:buffer-field("per-imposto"):buffer-value                      = tt-embarque-corpo-agr.per-imposto
               bh-dados-excel:buffer-field("total-vl-frete"):buffer-value                   = tt-embarque-corpo-agr.total-vl-frete
               bh-dados-excel:buffer-field("total-vl-embalagem"):buffer-value               = tt-embarque-corpo-agr.total-vl-embalagem
               bh-dados-excel:buffer-field("total-vl-seguro"):buffer-value                  = tt-embarque-corpo-agr.total-vl-seguro
               bh-dados-excel:buffer-field("total-vl-outras"):buffer-value                  = tt-embarque-corpo-agr.total-vl-outras.

        IF tt-param.l-desp-imposto THEN DO:
            ASSIGN bh-dados-excel:buffer-field("per-ii"):buffer-value             = tt-embarque-corpo-agr.per-ii
                   bh-dados-excel:buffer-field("vl-ger-ii-rea"):buffer-value      = tt-embarque-corpo-agr.vl-ger-ii-rea
                   bh-dados-excel:buffer-field("vl-ger-ipi-rea"):buffer-value     = tt-embarque-corpo-agr.vl-ger-ipi-rea
                   bh-dados-excel:buffer-field("vl-ger-ipi-rea"):buffer-value     = tt-embarque-corpo-agr.vl-ger-ipi-rea.
                   
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN bh-dados-excel:buffer-field("vl-ger-cbs-rea"):buffer-value      = tt-embarque-corpo-agr.vl-ger-cbs-rea
                       bh-dados-excel:buffer-field("vl-ger-ibs-uf-rea"):buffer-value   = tt-embarque-corpo-agr.vl-ger-ibs-uf-rea
                       bh-dados-excel:buffer-field("vl-ger-ibs-mun-rea"):buffer-value  = tt-embarque-corpo-agr.vl-ger-ibs-mun-rea
                       bh-dados-excel:buffer-field("vl-ger-is-rea"):buffer-value       = tt-embarque-corpo-agr.vl-ger-is-rea.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
            ELSE DO:
                ASSIGN bh-dados-excel:buffer-field("vl-ger-icms-rea"):buffer-value    = tt-embarque-corpo-agr.vl-ger-icms-rea
                       bh-dados-excel:buffer-field("vl-ger-pis-rea"):buffer-value     = tt-embarque-corpo-agr.vl-ger-pis-rea
                       bh-dados-excel:buffer-field("vl-ger-cofins-rea"):buffer-value  = tt-embarque-corpo-agr.vl-ger-cofins-rea.
            END.
        END.
    END.
    ELSE DO:
        if  tt-param.l-desp-imposto then do: /*Detalha Despesa x Imposto*/
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                disp tt-embarque-corpo-agr.embarque @ tt-embarque-corpo.embarque
                     tt-embarque-corpo-agr.cod-emitente @ tt-embarque-corpo.cod-emitente
                     tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea @ tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea 
                     tt-embarque-corpo-agr.vl-ger-mercado-rea @ tt-embarque-corpo.vl-ger-mercado-rea
                     tt-embarque-corpo-agr.vl-ger-tot-des-rea @ tt-embarque-corpo.vl-ger-tot-des-rea
                     tt-embarque-corpo-agr.vl-ger-tot-imp-rea @ tt-embarque-corpo.vl-ger-tot-imp-rea
                     tt-embarque-corpo-agr.per-mercado @ tt-embarque-corpo.per-mercado
                     tt-embarque-corpo-agr.per-despesa @ tt-embarque-corpo.per-despesa
                     tt-embarque-corpo-agr.per-imposto @ tt-embarque-corpo.per-imposto
                     tt-embarque-corpo-agr.per-ii @ tt-embarque-corpo.per-ii
                     tt-embarque-corpo-agr.vl-ger-ii-rea @ tt-embarque-corpo.vl-ger-ii-rea
                     tt-embarque-corpo-agr.vl-ger-ipi-rea @ tt-embarque-corpo.vl-ger-ipi-rea
                     tt-embarque-corpo-agr.vl-ger-cbs-rea @ tt-embarque-corpo.vl-ger-cbs-rea
                     tt-embarque-corpo-agr.vl-ger-ibs-uf-rea @ tt-embarque-corpo.vl-ger-ibs-uf-rea
                     tt-embarque-corpo-agr.vl-ger-ibs-mun-rea @ tt-embarque-corpo.vl-ger-ibs-mun-rea
                     tt-embarque-corpo-agr.vl-ger-is-rea @ tt-embarque-corpo.vl-ger-is-rea
                     tt-embarque-corpo-agr.total-vl-frete @ tt-embarque-corpo.total-vl-frete
                     tt-embarque-corpo-agr.total-vl-embalagem @ tt-embarque-corpo.total-vl-embalagem
                     tt-embarque-corpo-agr.total-vl-seguro @ tt-embarque-corpo.total-vl-seguro
                     tt-embarque-corpo-agr.total-vl-outras @ tt-embarque-corpo.total-vl-outras
                     with frame f-embarq-resum-1-CbsIbs.
                down with frame f-embarq-resum-1-CbsIbs.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
            ELSE DO:
                disp tt-embarque-corpo-agr.embarque @ tt-embarque-corpo.embarque
                     tt-embarque-corpo-agr.cod-emitente @ tt-embarque-corpo.cod-emitente
                     tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea @ tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea 
                     tt-embarque-corpo-agr.vl-ger-mercado-rea @ tt-embarque-corpo.vl-ger-mercado-rea
                     tt-embarque-corpo-agr.vl-ger-tot-des-rea @ tt-embarque-corpo.vl-ger-tot-des-rea
                     tt-embarque-corpo-agr.vl-ger-tot-imp-rea @ tt-embarque-corpo.vl-ger-tot-imp-rea
                     tt-embarque-corpo-agr.per-mercado @ tt-embarque-corpo.per-mercado
                     tt-embarque-corpo-agr.per-despesa @ tt-embarque-corpo.per-despesa
                     tt-embarque-corpo-agr.per-imposto @ tt-embarque-corpo.per-imposto
                     tt-embarque-corpo-agr.per-ii @ tt-embarque-corpo.per-ii
                     tt-embarque-corpo-agr.vl-ger-ii-rea @ tt-embarque-corpo.vl-ger-ii-rea
                     tt-embarque-corpo-agr.vl-ger-ipi-rea @ tt-embarque-corpo.vl-ger-ipi-rea
                     tt-embarque-corpo-agr.vl-ger-icms-rea @ tt-embarque-corpo.vl-ger-icms-rea
                     tt-embarque-corpo-agr.vl-ger-pis-rea @ tt-embarque-corpo.vl-ger-pis-rea
                     tt-embarque-corpo-agr.vl-ger-cofins-rea @ tt-embarque-corpo.vl-ger-cofins-rea
                     tt-embarque-corpo-agr.total-vl-frete @ tt-embarque-corpo.total-vl-frete
                     tt-embarque-corpo-agr.total-vl-embalagem @ tt-embarque-corpo.total-vl-embalagem
                     tt-embarque-corpo-agr.total-vl-seguro @ tt-embarque-corpo.total-vl-seguro
                     tt-embarque-corpo-agr.total-vl-outras @ tt-embarque-corpo.total-vl-outras
                     with frame f-embarq-resum-1.
                down with frame f-embarq-resum-1.
            END.
        end.
        else do:
            disp tt-embarque-corpo-agr.embarque     @ tt-embarque-corpo.embarque
                 tt-embarque-corpo-agr.cod-emitente @ tt-embarque-corpo.cod-emitente
                 tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea @ tt-embarque-corpo.vl-ger-tot-com-ipi-icms-merc-rea
                 tt-embarque-corpo-agr.vl-ger-mercado-rea @ tt-embarque-corpo.vl-ger-mercado-rea
                 tt-embarque-corpo-agr.vl-ger-tot-des-rea @ tt-embarque-corpo.vl-ger-tot-des-rea
                 tt-embarque-corpo-agr.vl-ger-tot-imp-rea @ tt-embarque-corpo.vl-ger-tot-imp-rea
                 tt-embarque-corpo-agr.per-mercado @ tt-embarque-corpo.per-mercado
                 tt-embarque-corpo-agr.per-despesa @ tt-embarque-corpo.per-despesa
                 tt-embarque-corpo-agr.per-imposto @ tt-embarque-corpo.per-imposto
                 tt-embarque-corpo-agr.total-vl-frete @ tt-embarque-corpo.total-vl-frete
                 tt-embarque-corpo-agr.total-vl-embalagem @ tt-embarque-corpo.total-vl-embalagem
                 tt-embarque-corpo-agr.total-vl-seguro @ tt-embarque-corpo.total-vl-seguro
                 tt-embarque-corpo-agr.total-vl-outras @ tt-embarque-corpo.total-vl-outras
                 with frame f-embarq-resum-2.
            down with frame f-embarq-resum-2.
        end.
    END.

    /* ITEM */ 
    if  tt-param.l-itens then do:
        if can-find(first tt-detalha-item
                    where tt-detalha-item.embarque    = tt-embarque-corpo-agr.embarque
                      and tt-detalha-item.cod-estabel = tt-embarque-corpo-agr.cod-estabel no-lock) then
            put skip(1).
        
        for each  tt-detalha-item
            where tt-detalha-item.embarque     = tt-embarque-corpo-agr.embarque
              and tt-detalha-item.cod-estabel  = tt-embarque-corpo-agr.cod-estabel
            use-index ch-codigo:

            if  i-desp-imposto = 1 then
                assign valor-total-despesa = tt-detalha-item.vl-des-rea
                                           + tt-detalha-item.vl-ii2-rea
                       valor-total-imposto = tt-detalha-item.vl-ipi-rea
                                           + tt-detalha-item.vl-icms-rea
                                           + tt-detalha-item.vl-pis-rea
                                           + tt-detalha-item.vl-cofins-rea.
            else
                assign valor-total-despesa = tt-detalha-item.vl-des-rea
                       valor-total-imposto = tt-detalha-item.vl-ii-rea
                                           + tt-detalha-item.vl-ipi-rea
                                           + tt-detalha-item.vl-icms-rea
                                           + tt-detalha-item.vl-pis-rea
                                           + tt-detalha-item.vl-cofins-rea.
                                           
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN valor-total-imposto = valor-total-imposto 
                                           + tt-detalha-item.vl-cbs-rea 
                                           + tt-detalha-item.vl-ibs-uf-rea
                                           + tt-detalha-item.vl-ibs-mun-rea
                                           + tt-detalha-item.vl-is-rea.
            END.
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */

            /*Busca a descri‡Æo do item**/
            FIND FIRST ITEM 
                 WHERE ITEM.it-codigo = tt-detalha-item.it-codigo NO-LOCK NO-ERROR.
            IF  AVAIL ITEM THEN
                ASSIGN c-desc-item = ITEM.desc-item.
            ELSE 
                ASSIGN c-desc-item = "".
                
            IF  tt-param.i-custo-item = 2 THEN
                RUN pi-altera-formato.

            IF tt-param.excel THEN DO:
                bh-dados-excel-detail:BUFFER-CREATE. 
                CREATE QUERY hQueryDetail.
                hQuery:SET-BUFFERS(bh-dados-excel-detail).
                hQuery:QUERY-PREPARE("FOR EACH dadosExcelDetail"). 
                hQuery:QUERY-OPEN().  
                
                ASSIGN bh-dados-excel-detail:BUFFER-FIELD("it-codigo"):BUFFER-VALUE                        = tt-detalha-item.it-codigo                        
                       bh-dados-excel-detail:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE                      = tt-detalha-item.cod-estabel                       
                       bh-dados-excel-detail:BUFFER-FIELD("embarque"):BUFFER-VALUE                         = tt-detalha-item.embarque
                       bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea 
                       bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-mercado-rea
                       bh-dados-excel-detail:BUFFER-FIELD("valor-total-despesa"):BUFFER-VALUE              = valor-total-despesa
                       bh-dados-excel-detail:BUFFER-FIELD("valor-total-imposto"):BUFFER-VALUE              = valor-total-imposto
                       bh-dados-excel-detail:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE                  = tt-detalha-item.per-mercado-rea                  
                       bh-dados-excel-detail:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-des-rea                  
                       bh-dados-excel-detail:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-imp-rea                  
                       bh-dados-excel-detail:BUFFER-FIELD("quantidade"):BUFFER-VALUE                       = tt-detalha-item.quantidade                       
                       bh-dados-excel-detail:BUFFER-FIELD("un"):BUFFER-VALUE                               = tt-detalha-item.un                               
                       bh-dados-excel-detail:BUFFER-FIELD("vl-des-frete"):BUFFER-VALUE                     = tt-detalha-item.vl-des-frete                     
                       bh-dados-excel-detail:BUFFER-FIELD("vl-des-embalagem"):BUFFER-VALUE                 = tt-detalha-item.vl-des-embalagem                 
                       bh-dados-excel-detail:BUFFER-FIELD("vl-des-seguro"):BUFFER-VALUE                    = tt-detalha-item.vl-des-seguro                    
                       bh-dados-excel-detail:BUFFER-FIELD("vl-des-outras"):BUFFER-VALUE                    = tt-detalha-item.vl-des-outras.                    

                IF l-desp-imposto THEN DO:
                    ASSIGN bh-dados-excel-detail:BUFFER-FIELD("descricao"):BUFFER-VALUE                    = tt-detalha-item.descricao
                           bh-dados-excel-detail:BUFFER-FIELD("aliquota-ii"):BUFFER-VALUE                  = tt-detalha-item.aliquota-ii
                           bh-dados-excel-detail:BUFFER-FIELD("aliquota-ipi"):BUFFER-VALUE                 = tt-detalha-item.aliquota-ipi
                           bh-dados-excel-detail:BUFFER-FIELD("vl-item-ii-rea"):BUFFER-VALUE               = tt-detalha-item.vl-ii-rea
                           bh-dados-excel-detail:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE                   = tt-detalha-item.per-ii-rea
                           bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-ipi-rea.
                           
                    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
                    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("aliquota-cbs"):BUFFER-VALUE              = tt-detalha-item.aliquota-cbs
                               bh-dados-excel-detail:BUFFER-FIELD("aliquota-ibs-uf"):BUFFER-VALUE           = tt-detalha-item.aliquota-ibs-uf
                               bh-dados-excel-detail:BUFFER-FIELD("aliquota-ibs-mun"):BUFFER-VALUE          = tt-detalha-item.aliquota-ibs-mun
                               bh-dados-excel-detail:BUFFER-FIELD("aliquota-is"):BUFFER-VALUE               = tt-detalha-item.aliquota-is
                               bh-dados-excel-detail:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE                = tt-detalha-item.vl-cbs-rea
                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE             = tt-detalha-item.vl-ibs-uf-rea
                               bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE            = tt-detalha-item.vl-ibs-mun-rea
                               bh-dados-excel-detail:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE                 = tt-detalha-item.vl-is-rea.
                    END.
                    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
                    ELSE DO:
                        ASSIGN bh-dados-excel-detail:BUFFER-FIELD("aliquota-pis"):BUFFER-VALUE             = tt-detalha-item.aliquota-pis
                               bh-dados-excel-detail:BUFFER-FIELD("aliquota-cofins"):BUFFER-VALUE          = tt-detalha-item.aliquota-cofins
                               bh-dados-excel-detail:BUFFER-FIELD("aliquota-icms"):BUFFER-VALUE            = tt-detalha-item.aliquota-icms
                               bh-dados-excel-detail:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE               = tt-detalha-item.vl-pis-rea
                               bh-dados-excel-detail:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE            = tt-detalha-item.vl-cofins-rea
                               bh-dados-excel-detail:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE              = tt-detalha-item.vl-icms-rea.
                    END.
                END.
            END.
            ELSE DO:
                
                if  l-desp-imposto then do:
                    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
                    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                        disp tt-detalha-item.it-codigo
                             tt-detalha-item.quantidade
                             tt-detalha-item.un
                             c-desc-item
                             tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                             tt-detalha-item.vl-mercado-rea
                             valor-total-despesa
                             valor-total-imposto
                             tt-detalha-item.per-mercado-rea
                             tt-detalha-item.per-tot-des-rea
                             tt-detalha-item.per-tot-imp-rea
                             tt-detalha-item.aliquota-ii
                             tt-detalha-item.aliquota-ipi
                             tt-detalha-item.aliquota-cbs
                             tt-detalha-item.aliquota-ibs-uf
                             tt-detalha-item.aliquota-ibs-mun
                             tt-detalha-item.aliquota-is
                             tt-detalha-item.vl-ii-rea
                             tt-detalha-item.vl-ipi-rea
                             tt-detalha-item.vl-cbs-rea
                             tt-detalha-item.vl-ibs-uf-rea
                             tt-detalha-item.vl-ibs-mun-rea
                             tt-detalha-item.vl-is-rea
                             tt-detalha-item.vl-des-frete
                             tt-detalha-item.vl-des-embalagem
                             tt-detalha-item.vl-des-seguro
                             tt-detalha-item.vl-des-outras
                             with frame f-item-resum-CbsIbs.
                        down with frame f-item-resum-CbsIbs.
                    END.
                    /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
                    ELSE DO:
                        disp tt-detalha-item.it-codigo
                             tt-detalha-item.quantidade
                             tt-detalha-item.un
                             c-desc-item
                             tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                             tt-detalha-item.vl-mercado-rea
                             valor-total-despesa
                             valor-total-imposto
                             tt-detalha-item.per-mercado-rea
                             tt-detalha-item.per-tot-des-rea
                             tt-detalha-item.per-tot-imp-rea
                             tt-detalha-item.aliquota-ii
                             tt-detalha-item.aliquota-ipi
                             tt-detalha-item.aliquota-pis
                             tt-detalha-item.aliquota-cofins
                             tt-detalha-item.aliquota-icms
                             tt-detalha-item.vl-ii-rea
                             tt-detalha-item.vl-ipi-rea
                             tt-detalha-item.vl-pis-rea
                             tt-detalha-item.vl-cofins-rea
                             tt-detalha-item.vl-icms-rea
                             tt-detalha-item.vl-des-frete
                             tt-detalha-item.vl-des-embalagem
                             tt-detalha-item.vl-des-seguro
                             tt-detalha-item.vl-des-outras
                             with frame f-item-resum.
                        down with frame f-item-resum.
                    END.
                end.
                else do:
                    disp tt-detalha-item.it-codigo
                         tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                         tt-detalha-item.vl-mercado-rea
                         valor-total-despesa
                         valor-total-imposto
                         tt-detalha-item.per-mercado-rea
                         tt-detalha-item.per-tot-des-rea
                         tt-detalha-item.per-tot-imp-rea
                         tt-detalha-item.quantidade
                         tt-detalha-item.un
                         tt-detalha-item.vl-des-frete
                         tt-detalha-item.vl-des-embalagem
                         tt-detalha-item.vl-des-seguro
                         tt-detalha-item.vl-des-outras
                         with frame f-item-resum-1.
                    down with frame f-item-resum-1.
                end.
            END.
        end.
    end.
    
    /* ESTABELECIMENTO */
    assign tot-est-importado = tot-est-importado
                             + tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea
           tot-est-mercado   = tot-est-mercado
                             + tt-embarque-corpo-agr.vl-ger-mercado-rea
           tot-est-despesa   = tot-est-despesa
                             + tt-embarque-corpo-agr.vl-ger-tot-des-rea
           tot-est-imposto   = tot-est-imposto
                             + tt-embarque-corpo-agr.vl-ger-tot-imp-rea
           tot-est-ii        = tot-est-ii
                             + tt-embarque-corpo-agr.vl-ger-ii-rea
           tot-est-ipi       = tot-est-ipi
                             + tt-embarque-corpo-agr.vl-ger-ipi-rea
           tot-est-pis       = tot-est-pis
                             + tt-embarque-corpo-agr.vl-ger-pis-rea
           tot-est-cofins    = tot-est-cofins
                             + tt-embarque-corpo-agr.vl-ger-cofins-rea
           tot-est-icms      = tot-est-icms
                             + tt-embarque-corpo-agr.vl-ger-icms-rea
           tot-est-frete     = tot-est-frete
                             + tt-embarque-corpo-agr.total-vl-frete
           tot-est-embalagem = tot-est-embalagem
                             + tt-embarque-corpo-agr.total-vl-embalagem
           tot-est-seguro    = tot-est-seguro
                             + tt-embarque-corpo-agr.total-vl-seguro
           tot-est-outras    = tot-est-outras
                             + tt-embarque-corpo-agr.total-vl-outras.
                             
    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
        ASSIGN tot-est-cbs      = tot-est-cbs      + tt-embarque-corpo-agr.vl-ger-cbs-rea
               tot-est-ibs-uf   = tot-est-ibs-uf   + tt-embarque-corpo-agr.vl-ger-ibs-uf-rea
               tot-est-ibs-mun  = tot-est-ibs-mun  + tt-embarque-corpo-agr.vl-ger-ibs-mun-rea
               tot-est-is       = tot-est-is       + tt-embarque-corpo-agr.vl-ger-is-rea.
    END.
    /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
    
    if  last-of (tt-embarque-corpo-agr.cod-estabel) then do:
        assign per-est-mercado = (tot-est-mercado * 100) / tot-est-importado
               per-est-despesa = (tot-est-despesa * 100) / tot-est-importado
               per-est-imposto = (tot-est-imposto * 100) / tot-est-importado
               per-est-ii      = (tot-est-imposto * 100) / tot-est-importado.

        IF tt-param.excel THEN DO:

            bh-dados-excel-total:BUFFER-CREATE. 
            CREATE QUERY hQueryTotal.
            hQuery:SET-BUFFERS(bh-dados-excel-total).
            hQuery:QUERY-PREPARE("FOR EACH dadosExcelTotal"). 
            hQuery:QUERY-OPEN(). 

            ASSIGN bh-dados-excel-total:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE        = tt-embarque-corpo-agr.cod-estabel
                   bh-dados-excel-total:BUFFER-FIELD("desc-estabel"):BUFFER-VALUE       = tt-embarque-corpo.desc-estabel
                   bh-dados-excel-total:BUFFER-FIELD("vl-unit-medio-item"):BUFFER-VALUE = tot-est-importado
                   bh-dados-excel-total:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE     = tot-est-mercado
                   bh-dados-excel-total:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE    = per-est-mercado
                   bh-dados-excel-total:BUFFER-FIELD("vl-tot-des-rea"):BUFFER-VALUE     = tot-est-despesa
                   bh-dados-excel-total:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE    = per-est-despesa
                   bh-dados-excel-total:BUFFER-FIELD("vl-tot-imp-rea"):BUFFER-VALUE     = tot-est-imposto
                   bh-dados-excel-total:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE    = per-est-imposto
                   bh-dados-excel-total:BUFFER-FIELD("vl-est-ii-rea"):BUFFER-VALUE      = tot-est-ii
                   bh-dados-excel-total:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE         = per-est-ii
                   bh-dados-excel-total:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE         = tot-est-ipi      
                   bh-dados-excel-total:BUFFER-FIELD("vl-des-frete"):BUFFER-VALUE       = tot-est-frete    
                   bh-dados-excel-total:BUFFER-FIELD("vl-des-embalagem"):BUFFER-VALUE   = tot-est-embalagem
                   bh-dados-excel-total:BUFFER-FIELD("vl-des-seguro"):BUFFER-VALUE      = tot-est-seguro   
                   bh-dados-excel-total:BUFFER-FIELD("vl-des-outras"):BUFFER-VALUE      = tot-est-outras.
                   
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN bh-dados-excel-total:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE      = tot-est-cbs
                       bh-dados-excel-total:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE   = tot-est-ibs-uf
                       bh-dados-excel-total:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE  = tot-est-ibs-mun
                       bh-dados-excel-total:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE       = tot-est-is.
            END.
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-903) */
            ELSE DO:
                ASSIGN bh-dados-excel-total:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE     = tot-est-pis
                       bh-dados-excel-total:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE  = tot-est-cofins
                       bh-dados-excel-total:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE    = tot-est-icms.
            END.
        END.
        ELSE DO:

            put skip(1).

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-total-estabelecimento AS CHARACTER FORMAT "X(23)" NO-UNDO.
            {utp/ut-liter.i "Total_Estabelecimento" *}
            ASSIGN c-lbl-liter-total-estabelecimento = TRIM(RETURN-VALUE).

            put c-lbl-liter-total-estabelecimento at 01 FORMAT "X(23)".
            
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                disp tot-est-importado
                     tot-est-mercado 
                     tot-est-despesa
                     tot-est-imposto
                     tot-est-ii
                     tot-est-ipi
                     tot-est-cbs
                     tot-est-ibs-uf
                     tot-est-ibs-mun
                     tot-est-is
                     tot-est-frete
                     tot-est-embalagem
                     tot-est-seguro
                     tot-est-outras
                     per-est-mercado
                     per-est-despesa
                     per-est-imposto
                     per-est-ii
                     with frame f-tot-gerais-CbsIbs.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
            ELSE DO:
                disp tot-est-importado
                     tot-est-mercado 
                     tot-est-despesa
                     tot-est-imposto
                     tot-est-ii
                     tot-est-ipi
                     tot-est-pis
                     tot-est-cofins
                     tot-est-icms
                     tot-est-frete
                     tot-est-embalagem
                     tot-est-seguro
                     tot-est-outras
                     per-est-mercado
                     per-est-despesa
                     per-est-imposto
                     per-est-ii
                     with frame f-tot-gerais.
            END.
        END.
        assign tot-est-importado   = 0
               tot-est-mercado     = 0
               tot-est-despesa     = 0
               tot-est-imposto     = 0
               tot-est-ii          = 0
               tot-est-ipi         = 0
               tot-est-pis         = 0
               tot-est-cofins      = 0
               tot-est-icms        = 0
               tot-est-frete       = 0
               tot-est-embalagem   = 0
               tot-est-seguro      = 0
               tot-est-outras      = 0
               per-est-mercado     = 0
               per-est-despesa     = 0
               per-est-imposto     = 0
               per-est-ii          = 0
               valor-total-despesa = 0
               valor-total-imposto = 0.
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            ASSIGN tot-est-cbs      = 0
                   tot-est-ibs-uf   = 0
                   tot-est-ibs-mun  = 0
                   tot-est-is       = 0.
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
    END.

    /* TOTAL GERAL */
    assign tot-ger-importado = tot-ger-importado
                             + tt-embarque-corpo-agr.vl-ger-tot-com-ipi-icms-rea
           tot-ger-mercado   = tot-ger-mercado
                             + tt-embarque-corpo-agr.vl-ger-mercado-rea
           tot-ger-despesa   = tot-ger-despesa
                             + tt-embarque-corpo-agr.vl-ger-tot-des-rea
           tot-ger-imposto   = tot-ger-imposto
                             + tt-embarque-corpo-agr.vl-ger-tot-imp-rea
           tot-ger-ii        = tot-ger-ii
                             + tt-embarque-corpo-agr.vl-ger-ii-rea
           tot-ger-ipi       = tot-ger-ipi
                             + tt-embarque-corpo-agr.vl-ger-ipi-rea
           tot-ger-pis       = tot-ger-pis
                             + tt-embarque-corpo-agr.vl-ger-pis-rea
           tot-ger-cofins    = tot-ger-cofins
                             + tt-embarque-corpo-agr.vl-ger-cofins-rea
           tot-ger-icms      = tot-ger-icms
                             + tt-embarque-corpo-agr.vl-ger-icms-rea
           tot-ger-frete     = tot-ger-frete
                             + tt-embarque-corpo-agr.total-vl-frete
           tot-ger-embalagem = tot-ger-embalagem
                             + tt-embarque-corpo-agr.total-vl-embalagem
           tot-ger-seguro    = tot-ger-seguro
                             + tt-embarque-corpo-agr.total-vl-seguro
           tot-ger-outras    = tot-ger-outras
                             + tt-embarque-corpo-agr.total-vl-outras.
                             
    /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
    IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
        ASSIGN tot-ger-cbs      = tot-ger-cbs      + tt-embarque-corpo-agr.vl-ger-cbs-rea
               tot-ger-ibs-uf   = tot-ger-ibs-uf   + tt-embarque-corpo-agr.vl-ger-ibs-uf-rea
               tot-ger-ibs-mun  = tot-ger-ibs-mun  + tt-embarque-corpo-agr.vl-ger-ibs-mun-rea
               tot-ger-is       = tot-ger-is       + tt-embarque-corpo-agr.vl-ger-is-rea.
    END.
    /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
end.

assign per-ger-mercado = (tot-ger-mercado * 100) / tot-ger-importado
       per-ger-despesa = (tot-ger-despesa * 100) / tot-ger-importado
       per-ger-imposto = (tot-ger-imposto * 100) / tot-ger-importado
       per-ger-ii      = (tot-ger-imposto * 100) / tot-ger-importado.

IF  NOT tt-param.excel AND CAN-FIND(FIRST tt-embarque-corpo-agr) THEN DO:
    put skip(1).
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-total-geral AS CHARACTER FORMAT "X(13)" NO-UNDO.
    {utp/ut-liter.i "Total_Geral" *}
    ASSIGN c-lbl-liter-total-geral = TRIM(RETURN-VALUE).
    put c-lbl-liter-total-geral at 01 FORMAT "X(13)".

    IF  tt-param.l-desp-imposto THEN DO:
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            disp tot-ger-importado
                 tot-ger-mercado 
                 tot-ger-despesa
                 tot-ger-imposto
                 tot-ger-frete
                 tot-ger-embalagem
                 tot-ger-seguro
                 tot-ger-outras
                 per-ger-mercado
                 per-ger-despesa
                 per-ger-imposto
                 tot-ger-ii
                 tot-ger-ipi
                 tot-ger-cbs
                 tot-ger-ibs-uf
                 tot-ger-ibs-mun
                 tot-ger-is
                 per-ger-ii
                 with frame f-tot-geral-1-CbsIbs.
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-897) */
        ELSE DO:
            disp tot-ger-importado
                 tot-ger-mercado 
                 tot-ger-despesa
                 tot-ger-imposto
                 tot-ger-frete
                 tot-ger-embalagem
                 tot-ger-seguro
                 tot-ger-outras
                 per-ger-mercado
                 per-ger-despesa
                 per-ger-imposto
                 tot-ger-ii
                 tot-ger-ipi
                 tot-ger-pis
                 tot-ger-cofins
                 tot-ger-icms   
                 per-ger-ii
                 with frame f-tot-geral-1.
        END.
    END.
    else
        disp tot-ger-importado
             tot-ger-mercado 
             tot-ger-despesa
             tot-ger-imposto
             tot-ger-frete
             tot-ger-embalagem
             tot-ger-seguro
             tot-ger-outras
             per-ger-mercado
             per-ger-despesa
             per-ger-imposto
             with frame f-tot-geral-2.
END.

IF tt-param.excel THEN DO:
    hQuery:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.     

    hQueryDetail:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQueryDetail NO-ERROR.

    hQueryTotal:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQueryTotal NO-ERROR.
END.
