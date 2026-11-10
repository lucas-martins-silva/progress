/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0665D 2.00.00.026 } /*** "010026" 17/08/2026 02:49:41 ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0665d MIM}
&ENDIF

/******************************************************************************
**
**       PROGRAMA:  IM0665D.P
**
**       DATA....:  FEVEREIRO DE 2003
**
**       OBJETIVO:  Custo Real de Importa‡Æo / Por Item - Detalhado/Resumido
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

def input param table for tt-param.
def input param table for tt-detalha-item.
def input param table for tt-embarque-cabec.
def input param table for tt-embarque-corpo.
DEF OUTPUT PARAM bh-dados-excel-detail  AS HANDLE NO-UNDO.
DEF OUTPUT PARAM bh-dados-excel-total   AS HANDLE NO-UNDO.


def var vl-item-ii-rea     like tt-detalha-item.vl-ii-rea  no-undo.
DEF VAR i-numero-itens     AS   INTEGER                    NO-UNDO.
DEF VAR de-unit-medio-item LIKE tot-item-importado         NO-UNDO.
DEF VAR de-tot-qtde-item   LIKE tt-detalha-item.quantidade NO-UNDO.

DEFINE VARIABLE tth-dados-excel-detail  AS HANDLE      NO-UNDO.
DEFINE VARIABLE tth-dados-excel-total   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQueryDetail            AS HANDLE      NO-UNDO.
DEFINE VARIABLE hQueryTotal             AS HANDLE      NO-UNDO.

find first tt-param.

IF tt-param.excel THEN DO:
    /*Por Item*/
    CREATE TEMP-TABLE tth-dados-excel-detail. /*cria a temp-table da handle*/

    {utp/ut-liter.i Item *}
    tth-dados-excel-detail:ADD-NEW-FIELD("it-codigo",tt-detalha-item.it-codigo:DATA-TYPE,?,tt-detalha-item.it-codigo:format,?,RETURN-VALUE).
    {utp/ut-liter.i Descri‡Æo *}
    tth-dados-excel-detail:ADD-NEW-FIELD("descricao",tt-detalha-item.descricao:DATA-TYPE,?,tt-detalha-item.descricao:format,?,RETURN-VALUE).
    {utp/ut-liter.i Estabelecimento *}
    tth-dados-excel-detail:ADD-NEW-FIELD("cod-estabel",tt-detalha-item.cod-estabel:DATA-TYPE,?,tt-detalha-item.cod-estabel:format,?,RETURN-VALUE).
    {utp/ut-liter.i Embarque *}
    tth-dados-excel-detail:ADD-NEW-FIELD("embarque",tt-detalha-item.embarque:DATA-TYPE,?,tt-detalha-item.embarque:format,?,RETURN-VALUE).
    {utp/ut-liter.i Ponto_de_Despacho *}
    tth-dados-excel-detail:ADD-NEW-FIELD("pto-despacho","CHAR",?,"x(100)",?,RETURN-VALUE).
    {utp/ut-liter.i Data_élt_Prev_Despacho *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-ult-prev-desp","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Despacho *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-despacho","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Ponto_de_Embarque *}
    tth-dados-excel-detail:ADD-NEW-FIELD("pto-embarque","CHAR",?,"x(100)",?,RETURN-VALUE).       
    {utp/ut-liter.i Data_élt_Prev_Embarque *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-ult-prev-embarque","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Embarque *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-embarque","DATE",?,"99/99/9999":U,?,RETURN-VALUE).         
    {utp/ut-liter.i Ponto_de_Nacionaliza‡Æo *}
    tth-dados-excel-detail:ADD-NEW-FIELD("pto-nacional","CHAR",?,"x(100)",?,RETURN-VALUE).           
    {utp/ut-liter.i Data_élt_PrevisÆo_Nacionaliza‡Æo *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-ult-prev-nac","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Nacionaliza‡Æo *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-nacional","DATE",?,"99/99/9999":U,?,RETURN-VALUE).    
    {utp/ut-liter.i Ponto_de_Chegada *}
    tth-dados-excel-detail:ADD-NEW-FIELD("pto-chegada","CHAR",?,"x(100)",?,RETURN-VALUE).            
    {utp/ut-liter.i Data_élt_PrevisÆo_Chegada *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-ult-prev-chegada","DATE",?,"99/99/9999":U,?,RETURN-VALUE).
    {utp/ut-liter.i Data_Chegada_na_F brica *}
    tth-dados-excel-detail:ADD-NEW-FIELD("data-chegada","DATE",?,"99/99/9999":U,?,RETURN-VALUE).         
    {utp/ut-liter.i UN *}
    tth-dados-excel-detail:ADD-NEW-FIELD("un",tt-detalha-item.un:DATA-TYPE,?,tt-detalha-item.un:format,?,RETURN-VALUE).
    {utp/ut-liter.i Quantidade *}
    tth-dados-excel-detail:ADD-NEW-FIELD("quantidade",tt-detalha-item.quantidade:DATA-TYPE,?,tt-detalha-item.quantidade:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Item *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea",tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Valor_Merc *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-mercado-rea",tt-detalha-item.vl-mercado-rea:DATA-TYPE,?,tt-detalha-item.vl-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i %_Vl_Merc *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-mercado-rea",tt-detalha-item.per-mercado-rea:DATA-TYPE,?,tt-detalha-item.per-mercado-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Despesas *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-des-rea",tt-detalha-item.vl-tot-des-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-des-rea:format,?,RETURN-VALUE).   
    {utp/ut-liter.i %_Total_Despesas *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-des-rea",tt-detalha-item.per-tot-des-rea:DATA-TYPE,?,tt-detalha-item.per-tot-des-rea:format,?,RETURN-VALUE).
    {utp/ut-liter.i Total_Impostos *}
    tth-dados-excel-detail:ADD-NEW-FIELD("vl-tot-imp-rea",tt-detalha-item.vl-tot-imp-rea:DATA-TYPE,?,tt-detalha-item.vl-tot-imp-rea:format,?,RETURN-VALUE).   
    {utp/ut-liter.i %_Total_Impostos *}
    tth-dados-excel-detail:ADD-NEW-FIELD("per-tot-imp-rea",tt-detalha-item.per-tot-imp-rea:DATA-TYPE,?,tt-detalha-item.per-tot-imp-rea:format,?,RETURN-VALUE).
    
    /*Totais */
    CREATE TEMP-TABLE tth-dados-excel-total.
    {utp/ut-liter.i Item *}
    tth-dados-excel-total:ADD-NEW-FIELD("it-codigo",tt-detalha-item.it-codigo:DATA-TYPE,?,tt-detalha-item.it-codigo:format,?,RETURN-VALUE).
    {utp/ut-liter.i Estabelecimento *}
    tth-dados-excel-total:ADD-NEW-FIELD("cod-estabel",tt-detalha-item.cod-estabel:DATA-TYPE,?,tt-detalha-item.cod-estabel:format,?,RETURN-VALUE).
    {utp/ut-liter.i UN *}
    tth-dados-excel-total:ADD-NEW-FIELD("un",tt-detalha-item.un:DATA-TYPE,?,tt-detalha-item.un:format,?,RETURN-VALUE).
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

    IF tt-param.l-desp-imposto THEN DO:
        {utp/ut-liter.i Aliq.II *}
        tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ii",tt-detalha-item.aliquota-ii:DATA-TYPE,?,tt-detalha-item.aliquota-ii:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i Aliq.IPI *}
        tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ipi",tt-detalha-item.aliquota-ipi:DATA-TYPE,?,tt-detalha-item.aliquota-ipi:FORMAT,?,RETURN-VALUE).
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            {utp/ut-liter.i Aliq.CBS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-cbs",tt-detalha-item.aliquota-cbs:DATA-TYPE,?,tt-detalha-item.aliquota-cbs:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IBS UF *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ibs-uf",tt-detalha-item.aliquota-ibs-uf:DATA-TYPE,?,tt-detalha-item.aliquota-ibs-uf:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IBS_MUN *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-ibs-mun",tt-detalha-item.aliquota-ibs-mun:DATA-TYPE,?,tt-detalha-item.aliquota-ibs-mun:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i Aliq.IS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("aliquota-is",tt-detalha-item.aliquota-is:DATA-TYPE,?,tt-detalha-item.aliquota-is:FORMAT,?,RETURN-VALUE).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
        ELSE DO:
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
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            {utp/ut-liter.i CBS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-cbs-rea",tt-detalha-item.vl-cbs-rea:DATA-TYPE,?,tt-detalha-item.vl-cbs-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS UF *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-uf-rea",tt-detalha-item.vl-ibs-uf-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-uf-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS_MUN *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-ibs-mun-rea",tt-detalha-item.vl-ibs-mun-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-mun-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-is-rea",tt-detalha-item.vl-is-rea:DATA-TYPE,?,tt-detalha-item.vl-is-rea:FORMAT,?,RETURN-VALUE).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
        ELSE DO:
            {utp/ut-liter.i PIS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-pis-rea",tt-detalha-item.vl-pis-rea:DATA-TYPE,?,tt-detalha-item.vl-pis-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i COFINS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-cofins-rea",tt-detalha-item.vl-cofins-rea:DATA-TYPE,?,tt-detalha-item.vl-cofins-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i ICMS *}
            tth-dados-excel-detail:ADD-NEW-FIELD("vl-icms-rea",tt-detalha-item.vl-icms-rea:DATA-TYPE,?,tt-detalha-item.vl-icms-rea:FORMAT,?,RETURN-VALUE).      
        END.
        
        {utp/ut-liter.i Frete *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-frete",tt-detalha-item.vl-des-frete:DATA-TYPE,?,tt-detalha-item.vl-des-frete:FORMAT,?,RETURN-VALUE).  
        {utp/ut-liter.i Embalagem *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-embalagem",tt-detalha-item.vl-des-embalagem:DATA-TYPE,?,tt-detalha-item.vl-des-embalagem:FORMAT,?,RETURN-VALUE).      
        {utp/ut-liter.i Seguro *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-seguro",tt-detalha-item.vl-des-seguro:DATA-TYPE,?,tt-detalha-item.vl-des-seguro:FORMAT,?,RETURN-VALUE).               
        {utp/ut-liter.i Outras *}
        tth-dados-excel-detail:ADD-NEW-FIELD("vl-des-outras",tt-detalha-item.vl-des-outras:DATA-TYPE,?,tt-detalha-item.vl-des-outras:FORMAT,?,RETURN-VALUE).      

        {utp/ut-liter.i II *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-item-ii-rea","dec",?,">>>,>>>,>>9.99999":U,?,RETURN-VALUE).
        {utp/ut-liter.i %_II *}
        tth-dados-excel-total:ADD-NEW-FIELD("per-ii-rea",tt-detalha-item.per-ii-rea:DATA-TYPE,?,tt-detalha-item.per-ii-rea:FORMAT,?,RETURN-VALUE).
        {utp/ut-liter.i IPI *}
        tth-dados-excel-total:ADD-NEW-FIELD("vl-ipi-rea",tt-detalha-item.vl-ipi-rea:DATA-TYPE,?,tt-detalha-item.vl-ipi-rea:FORMAT,?,RETURN-VALUE).
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            {utp/ut-liter.i CBS *}
            tth-dados-excel-total:ADD-NEW-FIELD("vl-cbs-rea",tt-detalha-item.vl-cbs-rea:DATA-TYPE,?,tt-detalha-item.vl-cbs-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS UF *}
            tth-dados-excel-total:ADD-NEW-FIELD("vl-ibs-uf-rea",tt-detalha-item.vl-ibs-uf-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-uf-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IBS_MUN *}
            tth-dados-excel-total:ADD-NEW-FIELD("vl-ibs-mun-rea",tt-detalha-item.vl-ibs-mun-rea:DATA-TYPE,?,tt-detalha-item.vl-ibs-mun-rea:FORMAT,?,RETURN-VALUE).
            {utp/ut-liter.i IS *}
            tth-dados-excel-total:ADD-NEW-FIELD("vl-is-rea",tt-detalha-item.vl-is-rea:DATA-TYPE,?,tt-detalha-item.vl-is-rea:FORMAT,?,RETURN-VALUE).
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
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
    END.

    tth-dados-excel-detail:TEMP-TABLE-PREPARE("dadosExcelDetail"). 
    bh-dados-excel-detail = tth-dados-excel-detail:DEFAULT-BUFFER-HANDLE. 

    tth-dados-excel-total:TEMP-TABLE-PREPARE("dadosExcelTotal"). /*Significa que todas as defini»„es de campo e ­ndice para uma tabela temporÿria foram fornecidas.*/
    bh-dados-excel-total = tth-dados-excel-total:DEFAULT-BUFFER-HANDLE. /*Como as tabelas temporÿrias estÿticas, toda tabela temporÿria din³mica ² criada com pelo menos um buffer. O identificador de objeto desse buffer ² retornado por esse atributo. DEFAULT-BUFFER-HANDLE n’o pode ser chamado at² que o m²todo TEMP-TABLE-PREPARE () tenha sido chamado, jÿ que o buffer padr’o n’o ² criado at² ent’o.*/
END.
    

IF tt-param.i-custo-item = 2 THEN
    RUN pi-altera-formato.

if  tt-param.l-desp-imposto then do: /*DETALHADO*/
    for each tt-detalha-item
        use-index ch-item
        break by tt-detalha-item.it-codigo:

        IF tt-param.excel THEN DO:
            bh-dados-excel-detail:BUFFER-CREATE. 
            CREATE QUERY hQueryDetail.
            hQueryDetail:SET-BUFFERS(bh-dados-excel-detail).
            hQueryDetail:QUERY-PREPARE("FOR EACH dadosExcelDetail"). 
            hQueryDetail:QUERY-OPEN().  
        
            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("it-codigo"):BUFFER-VALUE = tt-detalha-item.it-codigo
                   bh-dados-excel-detail:BUFFER-FIELD("descricao"):BUFFER-VALUE = tt-detalha-item.descricao.

            FOR FIRST  tt-embarque-cabec
                  WHERE tt-embarque-cabec.embarque     = tt-detalha-item.embarque
                    AND tt-embarque-cabec.cod-estabel  = tt-detalha-item.cod-estabel NO-LOCK.
             
                 ASSIGN bh-dados-excel-detail:BUFFER-FIELD("pto-despacho"):BUFFER-VALUE           = tt-embarque-cabec.pto-despacho 
                        bh-dados-excel-detail:BUFFER-FIELD("data-despacho"):BUFFER-VALUE          = tt-embarque-cabec.data-despacho
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-desp"):BUFFER-VALUE     = tt-embarque-cabec.data-ult-prev-desp
                        bh-dados-excel-detail:BUFFER-FIELD("pto-embarque"):BUFFER-VALUE           = tt-embarque-cabec.pto-embarque 
                        bh-dados-excel-detail:BUFFER-FIELD("data-embarque"):BUFFER-VALUE          = tt-embarque-cabec.data-embarque
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-embarque"):BUFFER-VALUE = tt-embarque-cabec.data-ult-prev-embarque
                        bh-dados-excel-detail:BUFFER-FIELD("pto-nacional"):BUFFER-VALUE           = tt-embarque-cabec.pto-nacional 
                        bh-dados-excel-detail:BUFFER-FIELD("pto-chegada"):BUFFER-VALUE            = tt-embarque-cabec.pto-chegada  
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                        bh-dados-excel-detail:BUFFER-FIELD("data-nacional"):BUFFER-VALUE          = tt-embarque-cabec.data-nacional
                        bh-dados-excel-detail:BUFFER-FIELD("data-chegada"):BUFFER-VALUE           = tt-embarque-cabec.data-chegada
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-chegada"):BUFFER-VALUE  = tt-embarque-cabec.data-ult-prev-chegada.
             END.
        END.

        if  first-of (tt-detalha-item.it-codigo) AND NOT tt-param.excel then do:
            disp tt-detalha-item.it-codigo
                 tt-detalha-item.descricao
                 with frame f-item.       
        END.

        IF tt-detalha-item.i-numero-itens <> 0 THEN
            ASSIGN i-numero-itens   = tt-detalha-item.i-numero-itens.

        IF tt-detalha-item.tot-quantidade <> 0 THEN
            ASSIGN de-tot-qtde-item = tt-detalha-item.tot-quantidade.
        
        if  tt-param.i-custo-item = 1 then /*Despesa*/
            assign vl-item-ii-rea = tt-detalha-item.vl-ii2-rea.
        else
            assign vl-item-ii-rea = tt-detalha-item.vl-ii-rea.

        IF  tt-param.excel THEN DO:
            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE                      = tt-detalha-item.cod-estabel
                   bh-dados-excel-detail:BUFFER-FIELD("embarque"):BUFFER-VALUE                         = tt-detalha-item.embarque
                   bh-dados-excel-detail:BUFFER-FIELD("un"):BUFFER-VALUE                               = tt-detalha-item.un
                   bh-dados-excel-detail:BUFFER-FIELD("quantidade"):BUFFER-VALUE                       = tt-detalha-item.quantidade
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-mercado-rea                 
                   bh-dados-excel-detail:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE                  = tt-detalha-item.per-mercado-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-des-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-tot-des-rea                  
                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-des-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-imp-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-tot-imp-rea             
                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-imp-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-item-ii-rea"):BUFFER-VALUE                   = vl-item-ii-rea
                   bh-dados-excel-detail:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE                       = tt-detalha-item.per-ii-rea
                   bh-dados-excel-detail:BUFFER-FIELD("aliquota-ii"):BUFFER-VALUE                      = tt-detalha-item.aliquota-ii
                   bh-dados-excel-detail:BUFFER-FIELD("aliquota-ipi"):BUFFER-VALUE                     = tt-detalha-item.aliquota-ipi.
                   
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                ASSIGN bh-dados-excel-detail:BUFFER-FIELD("aliquota-cbs"):BUFFER-VALUE      = tt-detalha-item.aliquota-cbs
                       bh-dados-excel-detail:BUFFER-FIELD("aliquota-ibs-uf"):BUFFER-VALUE   = tt-detalha-item.aliquota-ibs-uf
                       bh-dados-excel-detail:BUFFER-FIELD("aliquota-ibs-mun"):BUFFER-VALUE  = tt-detalha-item.aliquota-ibs-mun
                       bh-dados-excel-detail:BUFFER-FIELD("aliquota-is"):BUFFER-VALUE       = tt-detalha-item.aliquota-is
                       bh-dados-excel-detail:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE        = tt-detalha-item.vl-cbs-rea
                       bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE     = tt-detalha-item.vl-ibs-uf-rea
                       bh-dados-excel-detail:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE    = tt-detalha-item.vl-ibs-mun-rea
                       bh-dados-excel-detail:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE         = tt-detalha-item.vl-is-rea.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
            ELSE DO:
                ASSIGN bh-dados-excel-detail:BUFFER-FIELD("aliquota-pis"):BUFFER-VALUE     = tt-detalha-item.aliquota-pis
                       bh-dados-excel-detail:BUFFER-FIELD("aliquota-cofins"):BUFFER-VALUE  = tt-detalha-item.aliquota-cofins
                       bh-dados-excel-detail:BUFFER-FIELD("aliquota-icms"):BUFFER-VALUE    = tt-detalha-item.aliquota-icms
                       bh-dados-excel-detail:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE       = tt-detalha-item.vl-pis-rea
                       bh-dados-excel-detail:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE    = tt-detalha-item.vl-cofins-rea
                       bh-dados-excel-detail:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE      = tt-detalha-item.vl-icms-rea.
            END.
                   
            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE           = tt-detalha-item.vl-ipi-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-des-frete"):BUFFER-VALUE         = tt-detalha-item.vl-des-frete
                   bh-dados-excel-detail:BUFFER-FIELD("vl-des-embalagem"):BUFFER-VALUE     = tt-detalha-item.vl-des-embalagem
                   bh-dados-excel-detail:BUFFER-FIELD("vl-des-seguro"):BUFFER-VALUE        = tt-detalha-item.vl-des-seguro
                   bh-dados-excel-detail:BUFFER-FIELD("vl-des-outras"):BUFFER-VALUE        = tt-detalha-item.vl-des-outras.
        END.
        ELSE DO:
            /* ESTABELECIMENTO */
            /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
            IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                disp tt-detalha-item.cod-estabel
                     tt-detalha-item.embarque
                     tt-detalha-item.un
                     tt-detalha-item.quantidade
                     tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                     tt-detalha-item.vl-mercado-rea
                     tt-detalha-item.vl-tot-des-rea
                     tt-detalha-item.vl-tot-imp-rea
                     tt-detalha-item.per-mercado-rea
                     tt-detalha-item.per-tot-des-rea
                     tt-detalha-item.per-tot-imp-rea
                     tt-detalha-item.per-ii-rea
                     tt-detalha-item.aliquota-ii
                     tt-detalha-item.aliquota-ipi
                     tt-detalha-item.aliquota-cbs
                     tt-detalha-item.aliquota-ibs-uf
                     tt-detalha-item.aliquota-ibs-mun
                     tt-detalha-item.aliquota-is
                     vl-item-ii-rea @ tt-detalha-item.vl-ii-rea
                     tt-detalha-item.vl-ipi-rea
                     tt-detalha-item.vl-cbs-rea
                     tt-detalha-item.vl-ibs-uf-rea
                     tt-detalha-item.vl-ibs-mun-rea
                     tt-detalha-item.vl-is-rea
                     tt-detalha-item.vl-des-frete
                     tt-detalha-item.vl-des-embalagem
                     tt-detalha-item.vl-des-seguro
                     tt-detalha-item.vl-des-outras
                     with frame f-item-resumido-1-CbsIbs.
                down with frame f-item-resumido-1-CbsIbs.
            END.
            /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
            ELSE DO:
                disp tt-detalha-item.cod-estabel
                     tt-detalha-item.embarque
                     tt-detalha-item.un
                     tt-detalha-item.quantidade
                     tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                     tt-detalha-item.vl-mercado-rea
                     tt-detalha-item.vl-tot-des-rea
                     tt-detalha-item.vl-tot-imp-rea
                     tt-detalha-item.per-mercado-rea
                     tt-detalha-item.per-tot-des-rea
                     tt-detalha-item.per-tot-imp-rea
                     tt-detalha-item.per-ii-rea
                     tt-detalha-item.aliquota-ii
                     tt-detalha-item.aliquota-ipi
                     tt-detalha-item.aliquota-icms
                     tt-detalha-item.aliquota-pis
                     tt-detalha-item.aliquota-cofins
                     vl-item-ii-rea @ tt-detalha-item.vl-ii-rea
                     tt-detalha-item.vl-ipi-rea
                     tt-detalha-item.vl-pis-rea
                     tt-detalha-item.vl-cofins-rea
                     tt-detalha-item.vl-icms-rea
                     tt-detalha-item.vl-des-frete
                     tt-detalha-item.vl-des-embalagem
                     tt-detalha-item.vl-des-seguro
                     tt-detalha-item.vl-des-outras
                     with frame f-item-resumido-1.
                down with frame f-item-resumido-1.
            END.
        END.
        
        /* TOTAL ITEM */
        assign tot-item-importado = tot-item-importado
                                  + tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
               tot-item-mercado   = tot-item-mercado
                                  + tt-detalha-item.vl-mercado-rea
               tot-item-despesa   = tot-item-despesa
                                  + tt-detalha-item.vl-tot-des-rea
               tot-item-imposto   = tot-item-imposto
                                  + tt-detalha-item.vl-tot-imp-rea
               tot-item-ipi       = tot-item-ipi
                                  + tt-detalha-item.vl-ipi-rea
               tot-item-icms      = tot-item-icms
                                  + tt-detalha-item.vl-icms-rea
               tot-item-pis       = tot-item-pis
                                  + tt-detalha-item.vl-pis-rea
               tot-item-cofins    = tot-item-cofins
                                  + tt-detalha-item.vl-cofins-rea
               tot-item-frete     = tot-item-frete
                                  + tt-detalha-item.vl-des-frete
               tot-item-embalagem = tot-item-embalagem
                                  + tt-detalha-item.vl-des-embalagem
               tot-item-seguro    = tot-item-seguro
                                  + tt-detalha-item.vl-des-seguro
               tot-item-outras    = tot-item-outras
                                  + tt-detalha-item.vl-des-outras.
                                  
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            ASSIGN tot-item-cbs      = tot-item-cbs      + tt-detalha-item.vl-cbs-rea
                   tot-item-ibs-uf   = tot-item-ibs-uf   + tt-detalha-item.vl-ibs-uf-rea
                   tot-item-ibs-mun  = tot-item-ibs-mun  + tt-detalha-item.vl-ibs-mun-rea
                   tot-item-is       = tot-item-is       + tt-detalha-item.vl-is-rea
                   tot-ger-cbs       = tot-ger-cbs       + tt-detalha-item.vl-cbs-rea
                   tot-ger-ibs-uf    = tot-ger-ibs-uf    + tt-detalha-item.vl-ibs-uf-rea
                   tot-ger-ibs-mun   = tot-ger-ibs-mun   + tt-detalha-item.vl-ibs-mun-rea
                   tot-ger-is        = tot-ger-is        + tt-detalha-item.vl-is-rea.
        END.

        IF  tt-param.i-custo-item = 1 THEN /*Despesa*/
            ASSIGN tot-item-ii    = tot-item-ii
                                  + tt-detalha-item.vl-ii2-rea.
        ELSE 
            ASSIGN tot-item-ii    = tot-item-ii
                                  + tt-detalha-item.vl-ii-rea.

        if  last-of (tt-detalha-item.it-codigo) then do:

            assign per-item-mercado   = (tot-item-mercado * 100) / tot-item-importado
                   per-item-despesa   = (tot-item-despesa * 100) / tot-item-importado
                   per-item-imposto   = (tot-item-imposto * 100) / tot-item-importado
                   per-item-ii        = (tot-item-imposto * 100) / tot-item-importado
                   de-unit-medio-item = (tot-item-importado * i-numero-itens) / de-tot-qtde-item.

            IF tt-param.excel THEN DO:

                bh-dados-excel-total:BUFFER-CREATE. 
                CREATE QUERY hQueryTotal.
                hQueryTotal:SET-BUFFERS(bh-dados-excel-total).
                hQueryTotal:QUERY-PREPARE("FOR EACH dadosExcelTotal"). 
                hQueryTotal:QUERY-OPEN(). 

                ASSIGN bh-dados-excel-total:BUFFER-FIELD("it-codigo"):BUFFER-VALUE           = tt-detalha-item.it-codigo
                       bh-dados-excel-total:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE         = tt-detalha-item.cod-estabel
                       bh-dados-excel-total:BUFFER-FIELD("un"):BUFFER-VALUE                  = tt-detalha-item.un
                       bh-dados-excel-total:BUFFER-FIELD("vl-unit-medio-item"):BUFFER-VALUE  = de-unit-medio-item
                       bh-dados-excel-total:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE      = tot-item-mercado
                       bh-dados-excel-total:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE     = per-item-mercado
                       bh-dados-excel-total:BUFFER-FIELD("vl-tot-des-rea"):BUFFER-VALUE      = tot-item-despesa
                       bh-dados-excel-total:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE     = per-item-despesa
                       bh-dados-excel-total:BUFFER-FIELD("vl-tot-imp-rea"):BUFFER-VALUE      = tot-item-imposto
                       bh-dados-excel-total:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE     = per-item-imposto
                       bh-dados-excel-total:BUFFER-FIELD("vl-item-ii-rea"):BUFFER-VALUE      = tot-item-ii
                       bh-dados-excel-total:BUFFER-FIELD("per-ii-rea"):BUFFER-VALUE          = per-item-ii
                       bh-dados-excel-total:BUFFER-FIELD("vl-ipi-rea"):BUFFER-VALUE          = tot-item-ipi.
                       
                /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    ASSIGN bh-dados-excel-total:BUFFER-FIELD("vl-cbs-rea"):BUFFER-VALUE      = tot-item-cbs
                           bh-dados-excel-total:BUFFER-FIELD("vl-ibs-uf-rea"):BUFFER-VALUE   = tot-item-ibs-uf
                           bh-dados-excel-total:BUFFER-FIELD("vl-ibs-mun-rea"):BUFFER-VALUE  = tot-item-ibs-mun
                           bh-dados-excel-total:BUFFER-FIELD("vl-is-rea"):BUFFER-VALUE       = tot-item-is.
                END.
                /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-927) */
                ELSE DO:
                    ASSIGN bh-dados-excel-total:BUFFER-FIELD("vl-pis-rea"):BUFFER-VALUE     = tot-item-pis
                           bh-dados-excel-total:BUFFER-FIELD("vl-cofins-rea"):BUFFER-VALUE  = tot-item-cofins
                           bh-dados-excel-total:BUFFER-FIELD("vl-icms-rea"):BUFFER-VALUE    = tot-item-icms.
                END.
                
                ASSIGN bh-dados-excel-total:BUFFER-FIELD("vl-des-frete"):BUFFER-VALUE        = tot-item-frete    
                       bh-dados-excel-total:BUFFER-FIELD("vl-des-embalagem"):BUFFER-VALUE    = tot-item-embalagem
                       bh-dados-excel-total:BUFFER-FIELD("vl-des-seguro"):BUFFER-VALUE       = tot-item-seguro   
                       bh-dados-excel-total:BUFFER-FIELD("vl-des-outras"):BUFFER-VALUE       = tot-item-outras.
            END.
            ELSE DO:
                put skip(1).
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-total-item AS CHARACTER FORMAT "X(13)" NO-UNDO.
                {utp/ut-liter.i "Total_Item" *}
                ASSIGN c-lbl-liter-total-item = TRIM(RETURN-VALUE).
                put c-lbl-liter-total-item + " " FORMAT "X(13)" at 01 SKIP.
                
                /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
                IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
                    disp de-unit-medio-item    @   tot-est-importado
                         tot-item-mercado      @   tot-est-mercado
                         tot-item-despesa      @   tot-est-despesa
                         tot-item-imposto      @   tot-est-imposto
                         per-item-mercado      @   per-est-mercado
                         per-item-despesa      @   per-est-despesa
                         per-item-imposto      @   per-est-imposto
                         per-item-ii           @   per-est-ii
                         tot-item-ii           @   tot-est-ii
                         tot-item-ipi          @   tot-est-ipi
                         tot-item-cbs          @   tot-est-cbs
                         tot-item-ibs-uf       @   tot-est-ibs-uf
                         tot-item-ibs-mun      @   tot-est-ibs-mun
                         tot-item-is           @   tot-est-is
                         tot-item-frete        @   tot-est-frete
                         tot-item-embalagem    @   tot-est-embalagem
                         tot-item-seguro       @   tot-est-seguro
                         tot-item-outras       @   tot-est-outras
                         with frame f-tot-gerais-CbsIbs.
                END.
                /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
                ELSE DO:
                    disp de-unit-medio-item    @   tot-est-importado
                         tot-item-mercado      @   tot-est-mercado
                         tot-item-despesa      @   tot-est-despesa
                         tot-item-imposto      @   tot-est-imposto
                         per-item-mercado      @   per-est-mercado
                         per-item-despesa      @   per-est-despesa
                         per-item-imposto      @   per-est-imposto
                         per-item-ii           @   per-est-ii
                         tot-item-ii           @   tot-est-ii
                         tot-item-ipi          @   tot-est-ipi
                         tot-item-pis          @   tot-est-pis
                         tot-item-cofins       @   tot-est-cofins
                         tot-item-icms         @   tot-est-icms
                         tot-item-frete        @   tot-est-frete
                         tot-item-embalagem    @   tot-est-embalagem
                         tot-item-seguro       @   tot-est-seguro
                         tot-item-outras       @   tot-est-outras
                         with frame f-tot-gerais.
                END.
            END.
             
            assign tot-item-importado = 0
                   tot-item-mercado   = 0
                   tot-item-despesa   = 0
                   tot-item-imposto   = 0
                   tot-item-ii        = 0
                   tot-item-ipi       = 0
                   tot-item-icms      = 0
                   tot-item-pis       = 0
                   tot-item-cofins    = 0
                   tot-item-cbs       = 0
                   tot-item-ibs-uf    = 0
                   tot-item-ibs-mun   = 0
                   tot-item-is        = 0
                   tot-item-frete     = 0
                   tot-item-embalagem = 0
                   tot-item-seguro    = 0
                   tot-item-outras    = 0
                   per-item-mercado   = 0
                   per-item-despesa   = 0
                   per-item-imposto   = 0
                   de-unit-medio-item = 0
                   de-tot-qtde-item   = 0
                   i-numero-itens     = 0.
        end.

        /* TOTAL GERAL */
        assign tot-ger-importado = tot-ger-importado
                                  + tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
               tot-ger-mercado   = tot-ger-mercado
                                  + tt-detalha-item.vl-mercado-rea
               tot-ger-despesa   = tot-ger-despesa
                                  + tt-detalha-item.vl-tot-des-rea
               tot-ger-imposto   = tot-ger-imposto
                                  + tt-detalha-item.vl-tot-imp-rea
               tot-ger-ii        = tot-ger-ii
                                  + tt-detalha-item.vl-ii-rea
               tot-ger-ipi       = tot-ger-ipi
                                  + tt-detalha-item.vl-ipi-rea
               tot-ger-icms      = tot-ger-icms
                                  + tt-detalha-item.vl-icms-rea
               tot-ger-pis       = tot-ger-pis
                                  + tt-detalha-item.vl-pis-rea
               tot-ger-cofins    = tot-ger-cofins
                                  + tt-detalha-item.vl-cofins-rea
               tot-ger-frete     = tot-ger-frete
                                  + tt-detalha-item.vl-des-frete
               tot-ger-embalagem = tot-ger-embalagem
                                  + tt-detalha-item.vl-des-embalagem
               tot-ger-seguro    = tot-ger-seguro
                                  + tt-detalha-item.vl-des-seguro
               tot-ger-outras    = tot-ger-outras
                                  + tt-detalha-item.vl-des-outras.
    end.
    
    assign per-ger-mercado = (tot-ger-mercado * 100) / tot-ger-importado
           per-ger-despesa = (tot-ger-despesa * 100) / tot-ger-importado
           per-ger-imposto = (tot-ger-imposto * 100) / tot-ger-importado
           per-ger-ii      = (tot-ger-imposto * 100) / tot-ger-importado.

    
    IF  NOT tt-param.excel AND CAN-FIND(FIRST tt-detalha-item) THEN DO:
        put skip(1).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-total-geral AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "Total_Geral" *}
        ASSIGN c-lbl-liter-total-geral = TRIM(RETURN-VALUE).
        put c-lbl-liter-total-geral FORMAT "X(13)" at 01 SKIP.
        
        /* Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
        IF  l-nt2024002 AND tt-param.l-novos-tributos THEN DO:
            disp tot-ger-importado   
                 tot-ger-mercado     
                 tot-ger-despesa     
                 tot-ger-imposto     
                 per-ger-mercado     
                 per-ger-despesa     
                 per-ger-imposto     
                 per-ger-ii          
                 tot-ger-ii          
                 tot-ger-ipi         
                 tot-ger-cbs
                 tot-ger-ibs-uf
                 tot-ger-ibs-mun
                 tot-ger-is
                 tot-ger-frete       
                 tot-ger-embalagem   
                 tot-ger-seguro      
                 with frame f-tot-geral-1-CbsIbs.  
        END.
        /* FIM -- Reforma Tribut ria - Novos Tributos (DBACKRTDTS-925) */
        ELSE DO:
            disp tot-ger-importado   
                 tot-ger-mercado     
                 tot-ger-despesa     
                 tot-ger-imposto     
                 per-ger-mercado     
                 per-ger-despesa     
                 per-ger-imposto     
                 per-ger-ii          
                 tot-ger-ii          
                 tot-ger-ipi         
                 tot-ger-pis         
                 tot-ger-cofins      
                 tot-ger-icms        
                 tot-ger-frete       
                 tot-ger-embalagem   
                 tot-ger-seguro      
                 with frame f-tot-geral-1.  
        END.
    END.
end.
else do: /*RESUMIDO*/

    for each tt-detalha-item
        use-index ch-item
        break by tt-detalha-item.it-codigo:

        IF tt-param.excel THEN DO:

            bh-dados-excel-detail:BUFFER-CREATE. 
            CREATE QUERY hQueryDetail.
            hQueryDetail:SET-BUFFERS(bh-dados-excel-detail).
            hQueryDetail:QUERY-PREPARE("FOR EACH dadosExcelDetail"). 
            hQueryDetail:QUERY-OPEN().  
            
            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("it-codigo"):BUFFER-VALUE = tt-detalha-item.it-codigo
                   bh-dados-excel-detail:BUFFER-FIELD("descricao"):BUFFER-VALUE = tt-detalha-item.descricao.

            FOR FIRST  tt-embarque-cabec
                  WHERE tt-embarque-cabec.embarque     = tt-detalha-item.embarque
                    AND tt-embarque-cabec.cod-estabel  = tt-detalha-item.cod-estabel NO-LOCK.
             
                 ASSIGN bh-dados-excel-detail:BUFFER-FIELD("pto-despacho"):BUFFER-VALUE           = tt-embarque-cabec.pto-despacho 
                        bh-dados-excel-detail:BUFFER-FIELD("data-despacho"):BUFFER-VALUE          = tt-embarque-cabec.data-despacho
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-desp"):BUFFER-VALUE     = tt-embarque-cabec.data-ult-prev-desp
                        bh-dados-excel-detail:BUFFER-FIELD("pto-embarque"):BUFFER-VALUE           = tt-embarque-cabec.pto-embarque 
                        bh-dados-excel-detail:BUFFER-FIELD("data-embarque"):BUFFER-VALUE          = tt-embarque-cabec.data-embarque
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-embarque"):BUFFER-VALUE = tt-embarque-cabec.data-ult-prev-embarque
                        bh-dados-excel-detail:BUFFER-FIELD("pto-nacional"):BUFFER-VALUE           = tt-embarque-cabec.pto-nacional 
                        bh-dados-excel-detail:BUFFER-FIELD("pto-chegada"):BUFFER-VALUE            = tt-embarque-cabec.pto-chegada  
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                        bh-dados-excel-detail:BUFFER-FIELD("data-nacional"):BUFFER-VALUE          = tt-embarque-cabec.data-nacional
                        bh-dados-excel-detail:BUFFER-FIELD("data-chegada"):BUFFER-VALUE           = tt-embarque-cabec.data-chegada
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-nac"):BUFFER-VALUE      = tt-embarque-cabec.data-ult-prev-nac
                        bh-dados-excel-detail:BUFFER-FIELD("data-ult-prev-chegada"):BUFFER-VALUE  = tt-embarque-cabec.data-ult-prev-chegada.
             END.
        END.
        
        IF FIRST-OF (tt-detalha-item.it-codigo) THEN DO:
            IF NOT tt-param.excel THEN
                disp tt-detalha-item.it-codigo
                     tt-detalha-item.descricao
                    with frame f-item.
        END.
        
        IF tt-detalha-item.i-numero-itens <> 0 THEN
            ASSIGN i-numero-itens   = tt-detalha-item.i-numero-itens.

        IF tt-detalha-item.tot-quantidade <> 0 THEN
            ASSIGN de-tot-qtde-item = tt-detalha-item.tot-quantidade.

        /* ESTABELECIMENTO */
        IF tt-param.excel THEN DO:
            ASSIGN bh-dados-excel-detail:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE                      = tt-detalha-item.cod-estabel
                   bh-dados-excel-detail:BUFFER-FIELD("embarque"):BUFFER-VALUE                         = tt-detalha-item.embarque
                   bh-dados-excel-detail:BUFFER-FIELD("un"):BUFFER-VALUE                               = tt-detalha-item.un
                   bh-dados-excel-detail:BUFFER-FIELD("quantidade"):BUFFER-VALUE                       = tt-detalha-item.quantidade
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-com-ipi-icms-dsp-merc-rea"):BUFFER-VALUE = tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-mercado-rea                 
                   bh-dados-excel-detail:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE                  = tt-detalha-item.per-mercado-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-des-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-tot-des-rea                  
                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-des-rea
                   bh-dados-excel-detail:BUFFER-FIELD("vl-tot-imp-rea"):BUFFER-VALUE                   = tt-detalha-item.vl-tot-imp-rea             
                   bh-dados-excel-detail:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE                  = tt-detalha-item.per-tot-imp-rea.

        END.
        ELSE DO:
            disp tt-detalha-item.cod-estabel
                 tt-detalha-item.embarque
                 tt-detalha-item.un
                 tt-detalha-item.quantidade
                 tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
                 tt-detalha-item.vl-mercado-rea
                 tt-detalha-item.vl-tot-des-rea
                 tt-detalha-item.vl-tot-imp-rea
                 tt-detalha-item.per-mercado-rea
                 tt-detalha-item.per-tot-des-rea
                 tt-detalha-item.per-tot-imp-rea
                 with frame f-item-resumido-2.
            down with frame f-item-resumido-2.
        END.
        
        /* TOTAL ITEM */
        assign tot-item-importado = tot-item-importado
                                  + tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
               tot-item-mercado   = tot-item-mercado
                                  + tt-detalha-item.vl-mercado-rea
               tot-item-despesa   = tot-item-despesa
                                  + tt-detalha-item.vl-tot-des-rea
               tot-item-imposto   = tot-item-imposto
                                  + tt-detalha-item.vl-tot-imp-rea.

        if  last-of (tt-detalha-item.it-codigo) then do:
            assign per-item-mercado   = (tot-item-mercado * 100) / tot-item-importado
                   per-item-despesa   = (tot-item-despesa * 100) / tot-item-importado
                   per-item-imposto   = (tot-item-imposto * 100) / tot-item-importado
                   de-unit-medio-item = (tot-item-importado * i-numero-itens) / de-tot-qtde-item.

            IF tt-param.excel THEN DO:
                bh-dados-excel-total:BUFFER-CREATE. 
                CREATE QUERY hQueryTotal.
                hQueryTotal:SET-BUFFERS(bh-dados-excel-total).
                hQueryTotal:QUERY-PREPARE("FOR EACH dadosExcelTotal"). 
                hQueryTotal:QUERY-OPEN(). 

                ASSIGN bh-dados-excel-total:BUFFER-FIELD("it-codigo"):BUFFER-VALUE           = tt-detalha-item.it-codigo
                       bh-dados-excel-total:BUFFER-FIELD("cod-estabel"):BUFFER-VALUE         = tt-detalha-item.cod-estabel
                       bh-dados-excel-total:BUFFER-FIELD("un"):BUFFER-VALUE                  = tt-detalha-item.un
                       bh-dados-excel-total:BUFFER-FIELD("vl-unit-medio-item"):BUFFER-VALUE  = de-unit-medio-item
                       bh-dados-excel-total:BUFFER-FIELD("vl-mercado-rea"):BUFFER-VALUE      = tot-item-mercado
                       bh-dados-excel-total:BUFFER-FIELD("per-mercado-rea"):BUFFER-VALUE     = per-item-mercado
                       bh-dados-excel-total:BUFFER-FIELD("vl-tot-des-rea"):BUFFER-VALUE      = tot-item-despesa
                       bh-dados-excel-total:BUFFER-FIELD("per-tot-des-rea"):BUFFER-VALUE     = per-item-despesa
                       bh-dados-excel-total:BUFFER-FIELD("vl-tot-imp-rea"):BUFFER-VALUE      = tot-item-imposto
                       bh-dados-excel-total:BUFFER-FIELD("per-tot-imp-rea"):BUFFER-VALUE     = per-item-imposto.
            END.
            ELSE DO:
                put skip(1).
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-total-item-2 AS CHARACTER FORMAT "X(13)" NO-UNDO.
                {utp/ut-liter.i "Total_Item" *}
                ASSIGN c-lbl-liter-total-item-2 = TRIM(RETURN-VALUE).
                put c-lbl-liter-total-item-2 + " " FORMAT "X(13)" at 01 SKIP.

                disp de-unit-medio-item @ tot-item-importado
                     tot-item-mercado
                     tot-item-despesa
                     tot-item-imposto
                     per-item-mercado
                     per-item-despesa
                     per-item-imposto
                     with frame f-tot-gerais-item.
            END.

            assign tot-item-importado = 0
                   tot-item-mercado   = 0
                   tot-item-despesa   = 0
                   tot-item-imposto   = 0
                   per-item-mercado   = 0
                   per-item-despesa   = 0
                   per-item-imposto   = 0
                   de-unit-medio-item = 0
                   i-numero-itens     = 0
                   de-tot-qtde-item   = 0.
        end.

        /* TOTAL GERAL */
        assign tot-ger-importado = tot-ger-importado
                                  + tt-detalha-item.vl-tot-com-ipi-icms-dsp-merc-rea
               tot-ger-mercado   = tot-ger-mercado
                                  + tt-detalha-item.vl-mercado-rea
               tot-ger-despesa   = tot-ger-despesa
                                  + tt-detalha-item.vl-tot-des-rea
               tot-ger-imposto   = tot-ger-imposto
                                  + tt-detalha-item.vl-tot-imp-rea.
    end.
    
    assign per-ger-mercado = (tot-ger-mercado * 100) / tot-ger-importado
           per-ger-despesa = (tot-ger-despesa * 100) / tot-ger-importado
           per-ger-imposto = (tot-ger-imposto * 100) / tot-ger-importado.
    
    IF NOT tt-param.excel AND CAN-FIND(FIRST tt-detalha-item) THEN DO:
        put skip(1).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-total-geral-2 AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "Total_Geral" *}
        ASSIGN c-lbl-liter-total-geral-2 = TRIM(RETURN-VALUE).
        put c-lbl-liter-total-geral-2 FORMAT "X(13)" at 01 SKIP.
        disp tot-ger-importado
             tot-ger-mercado 
             tot-ger-despesa
             tot-ger-imposto
             per-ger-mercado
             per-ger-despesa
             per-ger-imposto
             with frame f-tot-geral-item.
    END.
end.

put skip(1).

IF tt-param.excel THEN DO:
    hQueryDetail:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQueryDetail NO-ERROR.     

    hQueryTotal:QUERY-CLOSE() NO-ERROR.
    DELETE OBJECT hQueryTotal NO-ERROR.
END.


